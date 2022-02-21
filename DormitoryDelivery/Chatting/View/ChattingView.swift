//
//  chat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI
import RealmSwift
import Alamofire




struct ChattingView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var keyboardManager: KeyboardManager
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var imsi_data: ChatData


  @StateObject var model: Chatting = Chatting()
  
  @State var RoomChat: ChatDB?
  let rid: String

  @FocusState private var rere: Bool
  @Namespace var bottomID
  
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
//        CustomScrollView(scrollToEnd: true) {
          GeometryReader { scrollgeo in
            ScrollViewReader { proxy in
          
              ScrollView {
                Spacer().frame(height: 10) // 패딩
                LazyVStack(spacing: 3) {
                  if let RoomDB = RoomChat{
                    ForEach(RoomDB.messages.indices, id: \.self) { index in
                      if RoomDB.messages[index].type == "chat" {
                        if let idvalue = UserDefaults.standard.string(forKey: "MyID") {
                          if RoomDB.messages[index].body!.userid == idvalue { // 내 매세지
                            ChatBubble(position: BubblePosition.right, color: Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1)) {
                              Text(RoomDB.messages[index].body!.message!)
                                .font(.system(size: 14, weight: .regular))
                            }
                          } else { // 상대방 처음
                            if index != 0 {
                              if RoomDB.messages[index - 1].type == "system" || RoomDB.messages[index].body!.userid != RoomDB.messages[index - 1].body!.userid{
                                Message(model:model, RoomDB: RoomDB, type: .newLeft, index: index)
                              } else { // 상대 처음 이후
                                ChatBubble(position: BubblePosition.left2, color: .white) {
                                  Text(RoomDB.messages[index].body!.message!)
                                    .font(.system(size: 14, weight: .regular))
                                }
                              }
                            } else {//index 0인지?
                                Message(model:model, RoomDB: RoomDB, type: .newLeft, index: index)
                            }
                          }
                        }
                      } else { // 시스템 메시지
                        if RoomDB.messages[index].body!.action! == "users-new" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(RoomDB.messages[index].body!.data!.name!)님이 참여했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if RoomDB.messages[index].body!.action! == "users-leave" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(RoomDB.messages[index].body!.data!.name!)님이 퇴장했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if RoomDB.messages[index].body!.action! == "order-fixed" {
                          Message(model:model, RoomDB: RoomDB, type: .orderFixed, index: index)
                        } else if RoomDB.messages[index].body!.action! == "order-checked" {
                          Message(model:model, RoomDB: RoomDB, type: .orderChecked, index: index)
                        } else if RoomDB.messages[index].body!.action! == "order-finished" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("방장이 주문을 완료했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if RoomDB.messages[index].body!.action! == "vote-kick-created" {
                          Message(model:model, RoomDB: RoomDB, type: .voteKickCreated, index: index)
                        }
                        else if RoomDB.messages[index].body!.action! == "vote-kick-finished" {
                          Message(model:model, RoomDB: RoomDB, type: .voteKickFinished, index: index)
                        }
                        else if RoomDB.messages[index].body!.action! == "vote-reset-created" {
                          Message(model:model, RoomDB: RoomDB, type: .voteResetCreated, index: index)
                        }
                        else if RoomDB.messages[index].body!.action! == "vote-reset-finished" {
                          Message(model:model, RoomDB: RoomDB, type: .voteResetFinished, index: index)

                        }// else { //나머지 시스템 액션
//                        }
                      }

                    } //for
                  } //if
      
                } //lazyV
                .rotationEffect(Angle(degrees: 180))
                .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                Spacer().frame(height: 10) // 뒤집힌 스크롤 하단 패딩
              } //scrollview
              .rotationEffect(Angle(degrees: 180))
              .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }//reader
          }//geo
          .clipped()
          .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
          .onTapGesture {
            hideKeyboard()
          }
            //MARK:- text editor
        // 주문서 작성 & 준비완료
          if RoomChat?.state?.orderFix == false {
            if RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! || (RoomChat?.menu.count) == 0{
              Button {
                self.model.oderview.toggle()
              } label: {
                Text("주문서 작성")
                  .font(.system(size: 14, weight: .regular))
              }
            .frame(width: UIScreen.main.bounds.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          } else {
            HStack(alignment: .center, spacing: 0){
              Button {
                self.model.oderview.toggle()
              } label: {
                Text("주문서 작성")
                  .font(.system(size: 14, weight: .regular))
              }
              .frame(width: geo.size.width/2)
              Divider()
              Button {
                getReady(rid: self.rid, token: naverLogin.sessionId, model: RoomChat!)
              } label: {
                Text(RoomChat!.ready ? "준비해제" : "준비완료")
                  .font(.system(size: 14, weight: .regular))
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
                  Text(RoomChat?.Kicked ?? false ? "강퇴로 인해 채팅이 불가합니다." : self.model.text)
                    .font(.system(size: 14, weight: .regular))
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
                      Text(self.model.text)
                        .font(.system(size: 14, weight: .regular))
                        .opacity(0)
                        .background(
                          GeometryReader { geo in
                            Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                          }.frame(minHeight: 18))
                        .onPreferenceChange(SizeKey.self) { value in // --- 2
                          self.model.textHeight = value
                        }
                    )

                  TextEditor(text: $model.text)
                    .font(.system(size: 14, weight: .regular))
                    .focused($rere)
                    .frame(width: geosender.size.width, height: 18.0 + (self.model.textHeight ?? 18.0))
                    .opacity(self.rere ? 1 : 0)
                }
                .frame(height: self.rere ? 18.0 + (self.model.textHeight ?? 18.0) : 36)
              } //geo sender

              Button {
                if self.model.text != "" {
                  SocketIOManager.shared.room_emitChat(rid: self.rid, text: self.model.text)
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
              .frame(height: self.rere ? 18.0 + (self.model.textHeight ?? 18.0) : 36)
              .cornerRadius(20)

            } // 채팅샌더 닫기
            .padding([.leading, .trailing])
            .frame(width: geo.size.width ,height: self.rere ? 18.0 + (self.model.textHeight ?? 18.0) + 10 : 46)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        
        }//vstack
        .frame(width: geo.size.width, height: geo.size.height)
        .disabled(self.model.showMenu ? true : false)
        .overlay(self.model.showMenu ? Rectangle()
                  .fill(Color.black.opacity(0.7))
                  .edgesIgnoringSafeArea(.bottom)
                  .frame(width: geo.size.width,height: geo.size.height)
                  .onTapGesture(perform: {
                    withAnimation {
                      self.model.showMenu = false
                    }}) : nil)

        
        if RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.allReady == true && self.model.showMenu == false {
          Button {
            postOderFix(rid: self.rid, token: naverLogin.sessionId)
          } label: {
            HStack{
              VStack(alignment: .leading) {
                Text("모두가 준비를 완료했어요.")
                  .font(.system(size: 16, weight: .bold))
                Text("주문을 확정하시겠습니까?")
                  .font(.system(size: 16, weight: .bold))
              }
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(.sRGB, red: 114/255, green: 160/255, blue: 253/255, opacity: 1), location: 0.05),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 121/255, green: 123/255, blue: 250/255, opacity: 1), location: 0.54),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 112/255, green: 64/255, blue: 255/255, opacity: 1), location: 1)
                                                                   ]), startPoint: UnitPoint(x: 0.25, y: 0.5), endPoint: UnitPoint(x: 0.75, y: 0.5))
                            .transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98))
              )
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
        } // 방장 메뉴 오더 픽스 이벤트
        
        
        if RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.orderFix == true && RoomChat?.state?.orderChecked == false && self.model.showMenu == false {
          Button{
            self.model.odercheck.toggle()
          } label: {
            HStack{
              Text("주문 사진과 배달 금액을 입력해주세요.")
                .font(.system(size: 16, weight: .bold))
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(.sRGB, red: 114/255, green: 160/255, blue: 253/255, opacity: 1), location: 0.05),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 121/255, green: 123/255, blue: 250/255, opacity: 1), location: 0.54),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 112/255, green: 64/255, blue: 255/255, opacity: 1), location: 1)
                                                                   ]), startPoint: UnitPoint(x: 0.25, y: 0.5), endPoint: UnitPoint(x: 0.75, y: 0.5))
                            .transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98))
              )
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
        } // 방장 메뉴 확인 이벤트
        
        if RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.orderChecked == true && RoomChat?.state?.orderDone == false && self.model.showMenu == false {
          Button{
            postOrderDone(rid: self.rid, token: naverLogin.sessionId)
          } label: {
            HStack{
              Text("주문이 완료되면 눌러주세요.")
                .font(.system(size: 16, weight: .bold))
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: Color(.sRGB, red: 114/255, green: 160/255, blue: 253/255, opacity: 1), location: 0.05),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 121/255, green: 123/255, blue: 250/255, opacity: 1), location: 0.54),
                                                                    Gradient.Stop(color: Color(.sRGB, red: 112/255, green: 64/255, blue: 255/255, opacity: 1), location: 1)
                                                                   ]), startPoint: UnitPoint(x: 0.25, y: 0.5), endPoint: UnitPoint(x: 0.75, y: 0.5))
                            .transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98))
              )
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
        } // 방장 주문 확인 이벤트
        
        if self.model.showMenu {
          ChatSideMenu(model: model, RoomChat: $RoomChat, rid: self.rid)
          .frame(width: geo.size.width * (9/10), height: geo.size.height)
          .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1)), alignment: .top)
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/10)
      } //showmenu
      
        NavigationLink(destination: OrderListView(RoomChat: RoomChat, rid: self.rid), isActive: $model.oderlistview) {}
        
    } //Zstack
      .gesture(drag)
      .disabled(RoomChat?.Kicked ?? false ? true : false)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(RoomChat != nil ? RoomChat!.title! : "채팅방")
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
              }
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            HStack{
              Button {
                withAnimation {
                  self.model.showMenu.toggle()
                }
              } label: {
                Image(systemName: "line.horizontal.3")
              }
            }
          }
      }
    } //geo
    
    .fullScreenCover(isPresented: $model.oderview) {
      if self.RoomChat != nil{
        OrderView(chatdata: self.RoomChat!, roomid: self.rid)
      }
    }
    .fullScreenCover(isPresented: $model.odercheck) {
      OrderCheckView(roomid: self.rid)
    }
    .fullScreenCover(isPresented: $model.userodercheck) {
      ReceiptView(roomid: self.rid)
    }
    .accentColor(.black)
    .onChange(of: model.leave) { newValue in
      self.RoomChat = nil
      presentationMode.wrappedValue.dismiss()
    }

    .onAppear {
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
          if let lastindex = RoomChat!.messages.last{
            RoomChat!.systemConfirmation = lastindex.idx.value!
          }
//          RoomChat!.confirmation = Int(RoomChat!.messages.filter("type == 'chat'").last!.idx!)!
        }
      })
    }
    .onChange(of: RoomChat?.index, perform: { V in
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
          if let lastindex = RoomChat!.messages.last{
            RoomChat!.systemConfirmation = lastindex.idx.value!
          }
//          RoomChat!.confirmation = Int(RoomChat!.messages.filter("type == 'chat'").last!.idx!)!
        }
      })
    })
    .onDisappear {
      let realm = try! Realm()
      if self.model.leave {
        self.RoomChat = nil
        try! realm.write({
          for i in roomidtodbconnect(rid: self.rid)!.messages {
            guard let body = i.body else { continue }
            if let data = body.data {
              realm.delete(data)
            }
            realm.delete(body)
          }
          realm.delete(roomidtodbconnect(rid: self.rid)!.messages)
          realm.delete(roomidtodbconnect(rid: self.rid)!.member)
          if let superUser = roomidtodbconnect(rid: self.rid)!.superUser {
            realm.delete(superUser)
          }
          if let state = roomidtodbconnect(rid: self.rid)!.state {
            realm.delete(state)
          }
          realm.delete(roomidtodbconnect(rid: self.rid)!)
        })
      } else{
          try! realm.write({
            if RoomChat != nil {
              RoomChat!.confirmation = RoomChat!.index
              if let lastindex = RoomChat!.messages.last{
                RoomChat!.systemConfirmation = lastindex.idx.value!
              }
//              RoomChat!.confirmation = Int(RoomChat!.messages.filter("type == 'chat'").last!.idx!)!
            }
          })
      }
      
    }
  }
  
}
