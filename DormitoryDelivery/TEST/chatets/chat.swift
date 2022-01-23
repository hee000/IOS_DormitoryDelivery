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

  @ObservedObject var model = ChatModel()
  @EnvironmentObject var chatdata: ChatData
  @EnvironmentObject var naverLogin: NaverLogin
  @State var RoomChat : ChatDB?
  var roomid: String
  
  
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
                          if RoomDB.messages[index].body!.userid == idvalue {
                            ChatBubble(position: BubblePosition.right, color: .green) {
                              Text(RoomDB.messages[index].body!.message!)
                            }
                          } else {
                            if RoomDB.messages[index - 1].type == "system" || RoomDB.messages[index].body!.userid != RoomDB.messages[index - 1].body!.userid{
                              ChatBubble(position: BubblePosition.left, color: .blue) {
                                Text(RoomDB.messages[index].body!.message!)
                              }
                            } else {
                              ChatBubble(position: BubblePosition.left2, color: .blue) {
                                Text(RoomDB.messages[index].body!.message!)
                              }
                            }
                            
                          }
                        }
                        
                      } else {
                        ChatBubble(position: BubblePosition.center, color: .green) {
                          Text(RoomDB.messages[index].body!.action!)
                        }
                      }
                    }
                    
                  }
                  
                  
                }
            } //scrollview
            //MARK:- text editor
            HStack(alignment: .center){
              Button("주문서 작성") {
                self.model.oderview.toggle()
              }
              Divider()
              Button("준비완료") {
                if let mytoken = naverLogin.loginInstance?.accessToken {
                    getReady(rid: self.roomid, token: mytoken)
                }
              }

            }
            .frame(width: UIScreen.main.bounds.size.width, height: 30, alignment: .center)
            HStack {
                ZStack {
                  TextEditor(text: $model.text)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(.gray)
                }.frame(height: 50)
                
                Button("send") {
                  if self.model.text != "" {
                    SocketIOManager.shared.room_emitChat(rid: self.roomid, text: self.model.text)
                    self.model.text = ""
                    }
                }
            }
        }//vstack
      .frame(width: geo.size.width, height: geo.size.height)
      .disabled(self.model.showMenu ? true : false)
      .overlay(self.model.showMenu ? Rectangle().fill(Color.black.opacity(0.8)).frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height).ignoresSafeArea() : nil)

        
        
        if self.model.showMenu {
//        Rectangle().fill(Color.black.opacity(0.8))
//          .frame(width: geo.size.width, height: geo.size.height)
        
          ChatSideMenu(model: self.model, rid: self.roomid)
          .frame(width: geo.size.width * (5/6))
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/6)
      }
    
    } //Zstack
      .gesture(drag)
        
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle((RoomChat != nil) ? RoomChat!.title! : "채팅방")
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("<"){
              presentationMode.wrappedValue.dismiss()
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("햄버거"){
              withAnimation {
                self.model.showMenu.toggle()
              }
            }
          }
      }
    } //geo
    .fullScreenCover(isPresented: $model.oderview) {
      OderView(roomid: self.roomid)
    }
    .fullScreenCover(isPresented: $model.oderlistview) {
      OderListView()
    }
    .accentColor(.black)
    .onChange(of: model.leave) { newValue in
      presentationMode.wrappedValue.dismiss()
    }
    .onDisappear {
      if self.model.leave {
        chatdata.leaveroomrid = self.roomid
      }
    }
    
    
  }
}
