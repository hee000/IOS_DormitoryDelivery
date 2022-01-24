//
//  chat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI
import RealmSwift

struct Chat: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) var managedObjectContext
  
  @EnvironmentObject var keyboardManager: KeyboardManager

  @ObservedObject var model = ChatModel()
  @EnvironmentObject var chatdata: ChatData
  @EnvironmentObject var naverLogin: NaverLogin
  @State var RoomChat : ChatDB?
  var roomid: String
  

  @FocusState private var rere: Bool
  @State var textHeight: CGFloat = 17
  @State var rows: CGFloat = 0

  
  
  var body: some View {
    let drag = DragGesture()
      .onEnded {
        if $0.translation.width > 100 {
          withAnimation {
            self.model.showMenu = false
          }
        }
      }

    GeometryReader { geo in
      ZStack {
      VStack(spacing: 0) {
            //MARK:- ScrollView
            CustomScrollView(scrollToEnd: true) {
                LazyVStack {
                  if let RoomDB = RoomChat{
                    ForEach(0..<RoomDB.messages.count, id:\.self) { index in
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
            Button("준비완료") { // 임시용
              if let mytoken = naverLogin.loginInstance?.accessToken {
                  getReady(rid: self.roomid, token: mytoken)
              }
            }
            Button("주문서 작성") {
              self.model.oderview.toggle()
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          } else {
              HStack(alignment: .center, spacing: 0){
                Button("주문서 작성") {
                  self.model.oderview.toggle()
                }
                .frame(width: geo.size.width/2)
                Divider()
                Button("준비완료") {
                  if let mytoken = naverLogin.loginInstance?.accessToken {
                      getReady(rid: self.roomid, token: mytoken)
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
                  ZStack{
                    Text(self.model.text)
                      .lineLimit(1)
                      .padding(.leading, 10)
                      .frame(width: geosender.size.width, height: 35, alignment: .leading)
                      .background(.white)
                      .cornerRadius(20)
                      .opacity(self.keyboardManager.isVisible ? 0 : 1)
                      .onTapGesture {
                        self.rere.toggle()
                      }
//                    TextEditor(text: $model.text)
//                      .padding(.leading, 5)
//                      .focused($rere)
//                      .opacity(self.keyboardManager.isVisible ? 1 : 0)
                    DynamicHeightTextField(text: $model.text, height: $textHeight, rows: $rows)
                                          .padding(.leading, 5)
                                          .focused($rere)
                                          .opacity(self.keyboardManager.isVisible ? 1 : 0)
                                          .frame(alignment: .bottom)
                  }
                } //geo sender

                  
                Button {
                  if self.model.text != "" {
                    SocketIOManager.shared.room_emitChat(rid: self.roomid, text: self.model.text)
                    self.model.text = ""
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
              .frame(height: self.keyboardManager.isVisible ? max(45, self.rows * 45) - 10 : 35)
              .cornerRadius(20)

            } // 채팅샌더 닫기
            .padding([.leading, .trailing])
            .frame(width: geo.size.width ,height: self.keyboardManager.isVisible ? max(45, self.rows * 45) : 45)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        
        }//vstack
      .frame(width: geo.size.width, height: geo.size.height)
      .disabled(self.model.showMenu ? true : false)
      .overlay(self.model.showMenu ? Rectangle().fill(Color.black.opacity(0.8)).frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height).ignoresSafeArea().onTapGesture(perform: {
        withAnimation {
          self.model.showMenu.toggle()
        }
      }) : nil)

        if RoomChat?.superid == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.oderfix != false && self.model.showMenu == false {
          Button("주문 사진과 배달 금액을 입력해주세요"){
            self.model.odercheck.toggle()
          }
          .frame(width: (geo.size.width/5) * 4, height: 60)
          .background(Color(.sRGB, red: 165/255, green: 162/255, blue: 246/255, opacity: 0.9))
          .cornerRadius(30)
          .offset(y: -geo.size.height/2 + 45)
        } // 방장 메뉴 화인 이벤트
        
        if self.model.showMenu {
          ChatSideMenu(model: self.model, rid: self.roomid)
          .frame(width: geo.size.width * (9/10), height: geo.size.height-2)
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/10, y:2)
      }
    
    } //Zstack
      .gesture(drag)
      .onChange(of: keyboardManager.isVisible, perform: { V in
        print(V)
      })
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(RoomChat!.title!)
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
                self.model.showMenu.toggle()
              }
            } label: {
              Image(systemName: "line.horizontal.3")
            }
          }
      }
    } //geo
    .fullScreenCover(isPresented: $model.oderview) {
      OderView(roomid: self.roomid)
    }
    .fullScreenCover(isPresented: $model.oderlistview) {
      OderListView(rid: self.roomid)
    }
    .fullScreenCover(isPresented: $model.odercheck) {
      OderCheckView()
    }
    .accentColor(.black)
    .onChange(of: model.leave) { newValue in
      presentationMode.wrappedValue.dismiss()
    }
    .onDisappear {
      if self.model.leave {
        self.RoomChat = nil
        try! realm.write({
          realm.delete(roomidtodbconnect(rid: self.roomid)!)
        })
      }
    }
  }
}
