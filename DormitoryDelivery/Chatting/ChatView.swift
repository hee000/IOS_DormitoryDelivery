//
//  ChatView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import SwiftUI

struct ChatView: View {
  @EnvironmentObject var chatdata: ChatData

    var body: some View {
      VStack{
        Text("채팅")
          .font(.system(size: 21))
          .padding([.leading, .top])
          .foregroundColor(Color.black)
          .frame(width: UIScreen.main.bounds.size.width, height: 50, alignment: .leading)
        Divider()
        ScrollView{
          VStack(spacing: 0){
              ForEach(chatdata.chatlist.indices, id: \.self) { index in
                ChatCard(roomid: chatdata.chatlist[index].rid!, RoomDB: roomidtodbconnect(rid: chatdata.chatlist[index].rid!))
              }
          }
        }
        Spacer()
      }
      .navigationBarTitle("") //this must be empty
      .navigationBarHidden(true)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
