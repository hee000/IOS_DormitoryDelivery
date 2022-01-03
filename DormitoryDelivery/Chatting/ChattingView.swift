//
//  SwiftUIView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Chat()
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}


//
//  Join.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import Foundation
import Combine
import RealmSwift

let realm = try! Realm()

func roomidtodbconnect (rid: String) -> ChatDB? {
  return realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
}

struct ChattingView: View {
//  @ObservedResults
//  @ObservedRealmObject
//
  @EnvironmentObject var chatdata: ChatData
  let RoomDB : ChatDB?
  var Id_room: String
  @State private var mymessage = "input"



  func scrollToLastMessage(proxy: ScrollViewProxy) {
    if let lastMessage = RoomDB?.messages.last { // 4
//      withAnimation(.easeOut(duration: 0.4)) {
        proxy.scrollTo(UUID(uuidString: lastMessage.id!), anchor: .bottom) // 5
//      }
    }
  }


    var body: some View {

      VStack {
        ScrollView {
          ScrollViewReader { proxy in // 1
            LazyVStack(spacing: 0) {
              if var roomdb = RoomDB {
                ForEach(roomdb.messages.indices, id: \.self) { index in
                   let ridIdx = roomdb.rid
                   let mid = roomdb.messages[index].id
                   let type = roomdb.messages[index].type
                   let action = roomdb.messages[index].body?.action
                   let data = roomdb.messages[index].body?.data
                   let userid = roomdb.messages[index].body?.userid
                   let username = roomdb.messages[index].body?.username
                   let message = roomdb.messages[index].body?.message
                   let idx = roomdb.messages[index].idx
                   let at = roomdb.messages[index].at

                  MessageCard(ridIdx: ridIdx, mid: mid, type: type, action: action, data: data, userid: userid, username: username, message: message, idx: idx, at: at, index: index, RoomDB: RoomDB)



                }
              }
            }
             .onChange(of: RoomDB?.messages.count ?? 0) { _ in // 3
              scrollToLastMessage(proxy: proxy)
            }

          }
        }.frame(width: UIScreen.main.bounds.size.width)

        Spacer()
        // Message field.
        HStack {
          Text("주문서 작성")
        }
        .background(Color(.sRGB, red: 0/255, green: 0/255, blue: 0/255, opacity: 0.3))
        
        HStack {
          TextField("Message", text: $mymessage) // 2
            .padding(10)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(5)


          Button(action: {

            SocketIOManager.shared.room_emitChat(rid: self.Id_room, text: self.mymessage)


          }) { // 3
            Image(systemName: "arrowshape.turn.up.right")
              .font(.system(size: 20))
          }
          .padding(.trailing)
          .disabled(mymessage.isEmpty) // 4
        }
        .padding(.leading)

      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
          ToolbarItem(placement: .principal) {
              HStack {
                  Image(systemName: "sun.min.fill")
                  Text("Title").font(.headline)
                Spacer()
                Button {
                  print("gkgk")
                } label: {
                  Text("채팅방")
                }
              }}}

    }
}

//struct Join_Previews: PreviewProvider {
//    static var previews: some View {
//        ChattingView(Id_room: "14")
//    }
//}
