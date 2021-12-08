////
////  Join.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/16.
////
//
//import SwiftUI
//import Foundation
//import Combine
//
//
//
//
////struct ReceivingChatMessage: Decodable, Identifiable {
////  let date: Date
////  let id: UUID
////  let message: String
////}
//
//
//
//
//
//
//struct ChattingView: View {
//  @EnvironmentObject var chatdata: ChatData
//
//  var myuserid : String = "test"
//  var Id_room: String
//  @State private var mymessage = "input"
//
//
//
//
//
//
//    var body: some View {
//
//      VStack {
//        ScrollView {
//          VStack{
//            HStack{
//              Text(chatdata.chatlist[0].messages[2].body!.username!)
//              Text(chatdata.chatlist[0].messages[2].type!)
//              Text(chatdata.chatlist[0].messages[0].body!.userid!)
//              Text(chatdata.chatlist[0].messages[0].body!.message!)
//              Text(chatdata.chatlist[0].messages[0].id!)
//
//
//            }
//          }
//        }
//
//        // Message field.
//        HStack {
//          TextField("Message", text: $mymessage) // 2
//            .padding(10)
//            .background(Color.secondary.opacity(0.2))
//            .cornerRadius(5)
//
//
//          Button(action: {
//
//            chatemit(text: mymessage)
//
//
//          }) { // 3
//            Image(systemName: "arrowshape.turn.up.right")
//              .font(.system(size: 20))
//          }
//          .padding(.trailing)
//          .disabled(mymessage.isEmpty) // 4
//        }
//        .padding(.leading)
//
//      }
//
//    }
//}
//
//struct Join_Previews: PreviewProvider {
//    static var previews: some View {
//        ChattingView(Id_room: "14")
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




//struct ReceivingChatMessage: Decodable, Identifiable {
//  let date: Date
//  let id: UUID
//  let message: String
//}






struct ChattingView: View {
  @EnvironmentObject var chatdata: ChatData

  var myuserid : String = "test"
  var Id_room: String
  @State private var mymessage = "input"




  func scrollToLastMessage(proxy: ScrollViewProxy) {
    if let lastMessage = chatdata.chatlist[0].messages.last { // 4
      withAnimation(.easeOut(duration: 0.4)) {
        proxy.scrollTo(UUID(uuidString: lastMessage.id!), anchor: .bottom) // 5
      }
    }
  }


    var body: some View {

      VStack {
        ScrollView {
          ScrollViewReader { proxy in // 1
            LazyVStack(spacing: 0) {
              ForEach(chatdata.chatlist[0].messages.indices, id: \.self) { index in
                   let ridIdx = chatdata.chatlist[0].rid
                   let mid = chatdata.chatlist[0].messages[index].id
                   let type = chatdata.chatlist[0].messages[index].type
                   let action = chatdata.chatlist[0].messages[index].body?.action
                   let data = chatdata.chatlist[0].messages[index].body?.data
                   let userid = chatdata.chatlist[0].messages[index].body?.userid
                   let username = chatdata.chatlist[0].messages[index].body?.username
                   let message = chatdata.chatlist[0].messages[index].body?.message
                   let idx = chatdata.chatlist[0].messages[index].idx
                   let at = chatdata.chatlist[0].messages[index].at
                
          
        
                
                  MessageCard(ridIdx: ridIdx, mid: mid, type: type, action: action, data: data, userid: userid, username: username, message: message, idx: idx, at: at)
                
//                HStack {
//                      //내 채팅
//                  if (chatdata.chatlist[0].messages[index].type! != "chat") || (chatdata.chatlist[0].messages[index].body!.userid! == myuserid) {
//                    Spacer()
//                  }
//
//                  VStack(alignment: .leading, spacing: 6) {
//                    HStack {
//                      Text(chatdata.chatlist[0].messages[index].body!.username!)
//                        .fontWeight(.bold)
//                        .font(.system(size: 12))
//                    }
//
//                    Text(chatdata.chatlist[0].messages[index].body!.message!)
//                  }
//                  .id(chatdata.chatlist[0].messages[index].id!)
//                  .foregroundColor(chatdata.chatlist[0].messages[index].body!.userid! == myuserid ? .white : .black)
//                  .padding(10)
//                  .background(chatdata.chatlist[0].messages[index].body!.userid! == myuserid ? Color.blue : Color(white: 0.95))
//                  .cornerRadius(5)
//
//
//                  // 남의 채팅
//                if (chatdata.chatlist[0].messages[index].type! == "chat") && (chatdata.chatlist[0].messages[index].body!.userid! != myuserid) {
//                  Spacer()
//                }
//                }
//                .padding()


              }
            }
            .onChange(of: chatdata.chatlist[0].messages.count) { _ in // 3
              scrollToLastMessage(proxy: proxy)
            }
          }
        }

        // Message field.
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

    }
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView(Id_room: "14")
    }
}
