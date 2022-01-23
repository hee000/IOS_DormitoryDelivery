//
//  chat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

struct Chat: View {
    @ObservedObject var model = ChatModel()
    @EnvironmentObject var chatdata: ChatData
    @EnvironmentObject var naverLogin: NaverLogin
    @State var chatme = ""
    @State var RoomChat : ChatDB?
  var roomid: String
    var body: some View {
//      let _ = print(chatdata.chatlist)
//      let _ = print(chatdata.chatlist.count)
//      let _ = print(chatdata.chatlist[0].messages)
//      let _ = print(UserDefaults.standard.string(forKey: "MyID")!)
        GeometryReader { geo in
            VStack {
                //MARK:- ScrollView
                CustomScrollView(scrollToEnd: true) {
                    LazyVStack {
//                        ForEach(0..<model.arrayOfMessages.count, id:\.self) { index in
//                            ChatBubble(position: model.arrayOfPositions[index], color: model.arrayOfPositions[index] == BubblePosition.right ?.green : .blue) {
//                                Text(model.arrayOfMessages[index])
//                            }
//                        }
                          
                          //test
                      if let RoomDB = RoomChat{
                        ForEach(0..<RoomDB.messages.count, id:\.self) { index in
                          if RoomDB.messages[index].type == "chat" {
                            if let idvalue = UserDefaults.standard.string(forKey: "MyID") {
                              if RoomDB.messages[index].body!.userid == idvalue{
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
                HStack {
                    ZStack {
                        TextEditor(text: $chatme)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(.gray)
                    }.frame(height: 50)
                    
                    Button("send") {
                      if self.chatme != "" {
                          SocketIOManager.shared.room_emitChat(rid: self.roomid, text: self.chatme)
                          self.chatme = ""
                        }
                    }
                }.padding()
            }//vstack
          
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("채팅방이름")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  Button("햄버거"){
                    print("햄버거작동")
                  }
                }
            }
        } //geo
        }
}
