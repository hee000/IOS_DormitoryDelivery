//
//  ChatView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import SwiftUI
import RealmSwift

struct ChatView: View {
  @EnvironmentObject var chatdata: ChatData
//  var naviRid = ""
//  var naviRoomDB: ChatDB? = nil
//  @State var isActived = false
//  @ObservedObject var naviChat: NaviChat = NaviChat()
//  @ObservedObject var db = testdada()
  
    var body: some View {
      GeometryReader { geo in
        ScrollView{
          ForEach(chatdata.chatlist.indices, id: \.self) { index in
            NavigationLink(destination: Chat(RoomChat: chatdata.chatlist[index]
                                             , roomid: chatdata.chatlist[index].rid!)) {
              ChatCard(title: chatdata.chatlist[index].title, lastmessage: chatdata.chatlist[index].messages.last?.body?.message, lastat: chatdata.chatlist[index].messages.last?.at, users: chatdata.chatlist[index].member.count, index: chatdata.chatlist[index].index, confirmation: chatdata.chatlist[index].confirmation)
            }
          }
          Spacer()
        }
      }
      
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
