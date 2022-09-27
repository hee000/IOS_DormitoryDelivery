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
//  @EnvironmentObject var naverLogin: NaverLogin
//  @EnvironmentObject var imsi_data: ChatData
  
  @StateObject var model: Chatting = Chatting()
  @StateObject var sendTextModel: ChattingSendText = ChattingSendText()
  @StateObject var privacy = UserData()
  
//  @ObservedObject var createRoomData: CreateRoom = CreateRoom()

//  @State var RoomChat: ChatDB?
  @StateObject var chatdb: ObservedChatDB
//  @ObservedObject var chatdb: ObservedChatDB
  
  let rid: String
  
  init(roomid: String) {
    self.rid = roomid
    self._chatdb = StateObject(wrappedValue: ObservedChatDB(roomid: roomid))
//    self._chatdb = ObservedObject(wrappedValue: ObservedChatDB(roomid: roomid))
  }


  @FocusState private var rere: Bool
  @Namespace var bottomID

  let barColor: LinearGradient = LinearGradient(
    gradient: Gradient(stops: [Gradient.Stop(color: Color(.sRGB, red: 114/255, green: 160/255, blue: 253/255, opacity: 1), location: 0.05),
                               Gradient.Stop(color: Color(.sRGB, red: 121/255, green: 123/255, blue: 250/255, opacity: 1), location: 0.54),
                               Gradient.Stop(color: Color(.sRGB, red: 112/255, green: 64/255, blue: 255/255, opacity: 1), location: 1)
                              ]),
    startPoint: UnitPoint(x: 0.25, y: 0.5), endPoint: UnitPoint(x: 0.75, y: 0.5)
  )
  
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
        if model.isReceiver{
          EmptyView()
           .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
             getChatLog(rid: self.rid, idx: 999)
             getRoomUpdate(rid: self.rid)
             getParticipantsUpdate(rid: self.rid)
             print("채팅 리시버")
           }
        } //isreceiver
        
        VStack(spacing: 0) {

          //MARK:- chat scroll view
          MessageView(roomid: self.rid, chatmodel: model, chatdb: chatdb)
          
            //MARK:- text editor
        // 주문서 작성 & 준비완료
          if chatdb.db?.state?.orderFix == false {
            if chatdb.db?.superUser?.userId == privacy.data?.id || chatdb.db?.readyAvailable == false {
              Button {
                self.model.oderview.toggle()
              } label: {
                Text("주문서 작성")
                  .font(.system(size: 14, weight: .regular))
              }
            .frame(width: UIScreen.main.bounds.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .disabled(chatdb.db?.Kicked ?? false ? true : false)
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
                getReady(rid: self.rid, model: chatdb.db!)
              } label: {
                Text(chatdb.db!.ready ? "준비해제" : "준비완료")
                  .font(.system(size: 14, weight: .regular))
              }
              .frame(width: geo.size.width/2)
            }
            .frame(width: geo.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .disabled(chatdb.db?.Kicked ?? false ? true : false)
          }
        }// 주문서 작성 & 준비완료 닫기
        
        
          HStack { // 채팅샌더
            HStack(spacing: 0) {
              GeometryReader { geosender in
                ZStack {
                  Text(chatdb.db?.Kicked ?? false ? "강퇴로 인해 채팅이 불가합니다." : self.sendTextModel.text)
                    .padding(.leading)
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
                      Text(self.sendTextModel.text)
                        .font(.system(size: 14, weight: .regular))
                        .opacity(0)
                        .background(
                          GeometryReader { geo in
                            Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                          }.frame(minHeight: 18, maxHeight: 100.33333333333333))
//                        .frame(maxHeight: 150)
                        .onPreferenceChange(SizeKey.self) { value in // --- 2
//                          print(value)
                          self.sendTextModel.textHeight = value
                        }
                    )

                  TextEditor(text: $sendTextModel.text)
                    .font(.system(size: 14, weight: .regular))
                    .focused($rere)
                    .frame(width: geosender.size.width, height: 18.0 + (self.sendTextModel.textHeight ?? 18.0))
                    .opacity(self.rere ? 1 : 0)
                  
                }
                .frame(height: self.rere ? 18.0 + (self.sendTextModel.textHeight ?? 18.0) : 36)
              } //geo sender

              Button {
                if self.sendTextModel.text != "" {
                  SocketIOManager.shared.room_emitChat(rid: self.rid, text: self.sendTextModel.text)
                  self.sendTextModel.text = ""
                }
                } label: {
                  VStack(spacing: 0){
                    if self.rere && 18.0 + (self.sendTextModel.textHeight ?? 18.0) > 40{
                      Spacer()
                    }
                    
                    HStack{
                      Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:30, height: 30)
                        .foregroundColor(self.sendTextModel.text != "" ? Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1) : Color.gray)
                    }
                    .frame(height: 36)
                  }
                }
                .disabled(self.sendTextModel.text != "" ? false : true)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
              }
              .background(.white)
              .frame(height: self.rere ? 18.0 + (self.sendTextModel.textHeight ?? 18.0) : 36)
              .cornerRadius(20)

            } // 채팅샌더 닫기
            .padding([.leading, .trailing])
            .frame(width: geo.size.width ,height: self.rere ? 18.0 + (self.sendTextModel.textHeight ?? 18.0) + 10 : 46)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
            .disabled(chatdb.db?.Kicked ?? false ? true : false)
          
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

        
        if chatdb.db?.superUser?.userId == privacy.data?.id && chatdb.db?.state?.allReady == true && self.model.showMenu == false && chatdb.db?.state?.orderCancel == false {
          Button {
            postOderFix(rid: self.rid)
          } label: {
            HStack{
              VStack(alignment: .leading) {
                Text("모두가 준비를 완료했어요.")
                  .font(.system(size: 14, weight: .bold))
                Text("메뉴와 인원을 확정하시겠습니까?")
                  .font(.system(size: 14, weight: .bold))
              }
              .padding(.leading)
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: 53)
              .background(self.barColor.transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98)))
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
          .disabled(chatdb.db?.Kicked ?? false ? true : false)
        } // 방장 메뉴 오더 픽스 이벤트
        
        if chatdb.db?.superUser?.userId == privacy.data?.id && chatdb.db?.state?.orderFix == true && chatdb.db?.state?.orderChecked == false && self.model.showMenu == false && chatdb.db?.state?.orderCancel == false {
          Button{
            self.model.odercheck.toggle()
          } label: {
            HStack{
              Text("주문 사진과 배달 금액을 입력해주세요.")
                .font(.system(size: 14, weight: .bold))
                .padding(.leading)
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: 53)
              .background(self.barColor.transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98)))
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
          .disabled(chatdb.db?.Kicked ?? false ? true : false)
        } // 방장 메뉴 확인 이벤트
        
        if chatdb.db?.superUser?.userId == privacy.data?.id && chatdb.db?.state?.orderChecked == true && chatdb.db?.state?.orderDone == false && self.model.showMenu == false && chatdb.db?.state?.orderCancel == false {
          Button{
            postOrderDone(rid: self.rid)
          } label: {
            HStack{
              Text("주문이 완료되면 눌러주세요.")
                .font(.system(size: 14, weight: .bold))
                .padding(.leading)
              Spacer()
              Image("ImageChatBell")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            }
              .padding()
              .foregroundColor(.white)
              .frame(maxWidth: .infinity, maxHeight: 53)
              .background(self.barColor.transformEffect(CGAffineTransform(a: 1.1, b: 0, c: -1.34, d: 2.94, tx: 0.61, ty: -0.98)))
              .cornerRadius(35)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1)))
          .disabled(chatdb.db?.Kicked ?? false ? true : false)
        } // 방장 주문 확인 이벤트
        
        if self.model.voteview {
          VoteView(chatmodel: model, RoomDB: $chatdb.db)
        }
        
        if self.model.showMenu {
          ChatSideMenu(model: model, RoomChat: $chatdb.db, rid: self.rid)
          .frame(width: geo.size.width * (9/10), height: geo.size.height)
          .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1)), alignment: .top)
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/10)
      } //showmenu
      
//        NavigationLink(destination: OrderListView(chatdb.db: chatdb.db, rid: self.rid), isActive: $model.oderlistview) {}
        
    } //Zstack
      .gesture(drag)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(chatdb.db != nil ? chatdb.db!.title! : "채팅방")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          HStack{
            Button {
//              chatdb.pressDeninit()

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
      if self.chatdb.db != nil{
        OrderView(chatdata: self.chatdb.db!, roomid: self.rid)
      }
    }
    .fullScreenCover(isPresented: $model.oderlistview) {
      OrderListView(RoomChat: chatdb.db, rid: self.rid)
    }
    .fullScreenCover(isPresented: $model.odercheck) {
      OrderCheckView(roomid: self.rid)
    }
    .fullScreenCover(isPresented: $model.userodercheck) {
      ReceiptView(roomid: self.rid)
    }
    .fullScreenCover(isPresented: $model.resetview) {
      ResetView(roomid: self.rid)
        .overlay(ErrorAlertView())
    }
    .fullScreenCover(isPresented: $model.isReport) {
      ReportView(messageId: self.model.messageId)
    }

    .accentColor(.black)
    .onChange(of: model.leave) { newValue in
      self.chatdb.db = nil
      presentationMode.wrappedValue.dismiss()
    }
    .onAppear {
//      model.isReceiver = true
      getChatLog(rid: self.rid, idx: 999)
      getRoomUpdate(rid: self.rid)
      getParticipantsUpdate(rid: self.rid)
      if let idx = chatdb.db?.messages.last?.idx {
        SocketIOManager.shared.room_emitChatIdx(rid: self.rid, idx: idx)
      }
      realmQueue.async {
        let realm = try! Realm()
        try! realm.write({
          if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: self.rid){
            if let lastindex = db.messages.last, let idx = lastindex.idx{
              db.confirmation = idx
            }
          }
        }) //write
      }//dispatch
    }
    .onChange(of: chatdb.db?.messages.count, perform: { V in
      if let idx = chatdb.db?.messages.last?.idx {
        SocketIOManager.shared.room_emitChatIdx(rid: self.rid, idx: idx)
      }
      realmQueue.async {
        let realm = try! Realm()
        try! realm.write({
          if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: self.rid){
            if let lastindex = db.messages.last, let idx = lastindex.idx{
              db.confirmation = idx
            }
          }
        }) //write
      } //dispatch
    })
    
    .onDisappear {
//      if !model.oderlistview {
//        model.isReceiver = false
//      }
      chatdb.pressDeninit()
      
      model.isReceiver = false
      if self.model.leave {
        self.chatdb.db = nil
        
//        try! realm.write({
//          print(self.rid)
//          if let deleteDB = roomidtodbconnect(rid: self.rid) {
//            for i in deleteDB.messages {
//              guard let body = i.body else { continue }
//              if let data = body.data {
//                realm.delete(data)
//              }
//              realm.delete(body)
//            }
//            realm.delete(deleteDB.messages)
//            realm.delete(deleteDB.member)
//            if let superUser = deleteDB.superUser {
//              realm.delete(superUser)
//            }
//            if let state = deleteDB.state {
//              realm.delete(state)
//            }
//            realm.delete(deleteDB)
//          }
//        })
      } else{
        realmQueue.async {
          let realm = try! Realm()
          try! realm.write({
            if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: self.rid){
              if let lastindex = db.messages.last, let idx = lastindex.idx{
                db.confirmation = idx
              }
            }
          })//write
        }//dispatch
      }
        
    }
  }
  
}


