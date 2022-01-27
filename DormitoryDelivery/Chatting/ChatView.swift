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
        if chatdata.chatlist.count == 0 {
          VStack(alignment: .center) {
            Spacer()
            Text("참여하신 배달방이 없어요.")
              .bold()
              .font(.title)
              .padding()
            Text("홈화면에서 먹고싶은 메뉴의")
            Text("배달방을 개설하거나 참여해보세요!")
            Spacer()
            Spacer()
          }.frame(width: geo.size.width)
        } else {
          ScrollView {
            VStack(spacing: 1) {
              ForEach(chatdata.chatlist.indices, id: \.self) { index in
                NavigationLink(destination: Chat(RoomChat: chatdata.chatlist[index]
                                                 , roomid: chatdata.chatlist[index].rid!)) {
                  ChatCard(title: chatdata.chatlist[index].title, lastmessage: chatdata.chatlist[index].messages.last?.body?.message, lastat: chatdata.chatlist[index].messages.last?.at, users: chatdata.chatlist[index].member.count, index: chatdata.chatlist[index].index, confirmation: chatdata.chatlist[index].confirmation)
                    .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                }
              } // for
            } //v
          } // scroll
        }
        
      }//geo
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
