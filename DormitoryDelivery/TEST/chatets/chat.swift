//
//  chat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI
import RealmSwift
import Alamofire

struct Chat: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var keyboardManager: KeyboardManager

  @ObservedObject var model = ChatModel()
//  @EnvironmentObject var chatdata: ChatData
  @EnvironmentObject var naverLogin: NaverLogin
  @State var RoomChat : ChatDB?
  var roomid: String
  

  @FocusState private var rere: Bool
  @State var textHeight: CGFloat?

  @State var text = ""
  @State var showMenu = false
  @State var leave = false
  @State var oderview = false
  @State var oderlistview = false
  @State var odercheck = false
  @State var userodercheck = false
  
  var body: some View {
    let drag = DragGesture()
      .onEnded {
        if $0.translation.width > 100 {
          withAnimation {
            self.showMenu = false
          }
        }
      }

    GeometryReader { geo in
      ZStack {
      VStack(spacing: 0) {
            //MARK:- ScrollView
        CustomScrollView(scrollToEnd: true) {
          LazyVStack(spacing: 3) {
                  if let RoomDB = RoomChat{
//                    ForEach(Array(zip(RoomDB.messages.indices, RoomDB.messages)), id: \.1) { index, item in

//                    ForEach(0..<RoomDB.messages.count, id:\.self) { index in
                    ForEach(RoomDB.messages.indices, id: \.self) { index in

                      if RoomDB.messages[index].type == "chat" {
                        if let idvalue = UserDefaults.standard.string(forKey: "MyID") {
                          if RoomDB.messages[index].body!.userid == idvalue { // 내 매세지
                            ChatBubble(position: BubblePosition.right, color: Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1)) {
                              Text(RoomDB.messages[index].body!.message!)
                            }
                          } else { // 상대방 처음
                            if RoomDB.messages[index - 1].type == "system" || RoomDB.messages[index].body!.userid != RoomDB.messages[index - 1].body!.userid{
                              ChatBubble(position: BubblePosition.left, color: .white) {
                                Text(RoomDB.messages[index].body!.message!)
                              }
                            } else { // 상대 처음 이후
                              ChatBubble(position: BubblePosition.left2, color: .white) {
                                Text(RoomDB.messages[index].body!.message!)
                              }
                            }
                            
                          }
                        }
                        
                      } else { // 시스템 메시지
                        if RoomDB.messages[index].body!.action! == "users-new" {
                          ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(RoomDB.messages[index].body!.data!.name!)님이 입장하셨습니다.")
                          }
                        } else if RoomDB.messages[index].body!.action! == "all-ready" {
                          if RoomDB.superid == UserDefaults.standard.string(forKey: "MyID")! {
                            ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                                VStack{
                                Text("모두가 레디함")
                                Button("준비확인"){
                                  if let mytoken = naverLogin.loginInstance?.accessToken {
                                  postOderFix(rid: self.roomid, token: mytoken)
                                  }
                                }}
                            }
                          }
                        } else if RoomDB.messages[index].body!.action! == "all-ready-canceled" {
                          if RoomDB.superid == UserDefaults.standard.string(forKey: "MyID")! {
                            ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                                VStack{
                                Text("준비 해제")
                                }
                            }
                          }
                        } else if RoomDB.messages[index].body!.action! == "order-checked" {
                          if RoomDB.superid != UserDefaults.standard.string(forKey: "MyID")! {
                            ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                                VStack{
                                Text("오더 체크끝")
                                  Button("확인하기"){
                                    
                                    self.userodercheck.toggle()
                                    
                                  }
                                }
                            }
                          }
                        } else {
                          ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text(RoomDB.messages[index].body!.action!)
                          }
                        }
                    }
                    
                  }
                  
                  }
                }
            } //scrollview
            .onTapGesture {
              hideKeyboard()
            }
            //MARK:- text editor
        // 주문서 작성 & 준비완료
        if RoomChat?.state?.oderfix == false {
          if RoomChat?.superid == UserDefaults.standard.string(forKey: "MyID")! || (RoomChat?.menu.count) == 0{
            Button("주문서 작성") {
              self.oderview.toggle()
//              self.testbool.toggle()
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          } else {
              HStack(alignment: .center, spacing: 0){
                Button("주문서 작성") {
                  self.oderview.toggle()
//                  self.testbool.toggle()
                }
                .frame(width: geo.size.width/2)
                Divider()
                Button(RoomChat!.ready ? "준비해제" : "준비완료") {
                  if let mytoken = naverLogin.loginInstance?.accessToken {
                    getReady(rid: self.roomid, token: mytoken, model: RoomChat!)
                  }
                }
                .frame(width: geo.size.width/2)

              }
              .frame(width: geo.size.width, height: 45, alignment: .center)
              .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          }
        }// 주문서 작성 & 준비완료 닫기
        
        
            HStack { // 채팅샌더
              HStack(spacing: 0) {
                GeometryReader { geosender in
                  ZStack {
                    Text(self.text)
                      .lineLimit(1)
                      .frame(width: geosender.size.width, alignment: .leading)
                      .background(Color.white)
                      .opacity(self.rere ? 0 : 1)
                      .onTapGesture {
                        self.rere.toggle()
                      }
                    
                    Text("") // 에디터 줄 확인
                      .frame(width: geosender.size.width, height: 70, alignment: .leading)
                      .frame(maxHeight: .infinity)
                      .background(
                        Text(self.text)
                          .opacity(0)
                          .background(
                            GeometryReader { geo in
                              Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                            }.frame(minHeight: 18))
                          .onPreferenceChange(SizeKey.self) { value in // --- 2
                                self.textHeight = value
                          }
                      )

                    TextEditor(text: $text)
                      .focused($rere)
                      .frame(width: geosender.size.width, height: 18.0 + (self.textHeight ?? 18.0))
                      .opacity(self.rere ? 1 : 0)
                  }
                  .frame(height: self.rere ? 18.0 + (self.textHeight ?? 18.0) : 36)
                } //geo sender

                Button {
                  if self.text != "" {
                    SocketIOManager.shared.room_emitChat(rid: self.roomid, text: self.text)
                    self.text = ""
                    }
                } label: {
                  Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:30, height: 30)
                    .foregroundColor(Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
              }
              .background(.white)
              .frame(height: self.rere ? 18.0 + (self.textHeight ?? 18.0) : 36)
              .cornerRadius(20)

            } // 채팅샌더 닫기
            .padding([.leading, .trailing])
            .frame(width: geo.size.width ,height: self.rere ? 18.0 + (self.textHeight ?? 18.0) + 10 : 46)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        
        }//vstack
      .frame(width: geo.size.width, height: geo.size.height)
      .disabled(self.showMenu ? true : false)
      .overlay(self.showMenu ? Rectangle()
                .fill(Color.black.opacity(0.7))
                .edgesIgnoringSafeArea(.bottom)
                .frame(width: geo.size.width,
                       height: geo.size.height)
                .onTapGesture(perform: {
        withAnimation {
          self.showMenu.toggle()
        }
      }) : nil)

        if RoomChat?.superid == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.oderfix != false && self.showMenu == false {
          Button("주문 사진과 배달 금액을 입력해주세요"){
            self.odercheck.toggle()
          }
          .frame(width: (geo.size.width/5) * 4, height: 60)
          .background(Color(.sRGB, red: 165/255, green: 162/255, blue: 246/255, opacity: 0.9))
          .cornerRadius(30)
          .offset(y: -geo.size.height/2 + 45)
        } // 방장 메뉴 화인 이벤트
        
        if self.showMenu {
          ChatSideMenu(model: self.model, showMenu: $showMenu, oderlistview: $oderlistview, rid: self.roomid)
          .frame(width: geo.size.width * (9/10), height: geo.size.height)
          .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1)), alignment: .top)
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/10)
      } //showmenu
      
    
    } //Zstack
      .gesture(drag)
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(RoomChat != nil ? RoomChat!.title! : "채팅방")
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "chevron.left")
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              withAnimation {
                self.showMenu.toggle()
              }
            } label: {
              Image(systemName: "line.horizontal.3")
            }
          }
      }
    } //geo
    .fullScreenCover(isPresented: $oderview) {
      if self.RoomChat != nil{
        OderView(chatdata: self.RoomChat!, roomid: self.roomid)
      }
    }
    .fullScreenCover(isPresented: $oderlistview) {
      OderListView(rid: self.roomid)
    }
    .fullScreenCover(isPresented: $odercheck) {
      OderCheckView(roomid: self.roomid)
    }
    .fullScreenCover(isPresented: $userodercheck) {
      UserOrderCheckView(roomid: self.roomid)
    }
    .accentColor(.black)
    .onChange(of: model.leave) { newValue in
      presentationMode.wrappedValue.dismiss()
    }

    .onAppear {
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
        }
      })
    }
    .onChange(of: RoomChat?.index, perform: { V in
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
        }
      })
    })
    .onDisappear {
      print("SAdasd")
      let realm = try! Realm()
      if self.model.leave {
        self.RoomChat = nil
        try! realm.write({
          realm.delete(roomidtodbconnect(rid: self.roomid)!)
        })
      } else{
          try! realm.write({
            if RoomChat != nil {
              RoomChat!.confirmation = RoomChat!.index
            }
          })
      }
      
    }
  }
}
