//
//  MessageCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import SwiftUI

struct MessageCard: View {
  @EnvironmentObject var chatdata: ChatData

  @State var ridIdx: String?
  @State var mid: String?
  @State var type: String?
  @State var action: String?
  @State var data: ChatMessageDetailBodyData? = ChatMessageDetailBodyData()
  @State var userid: String?
  @State var username: String?
  @State var message: String?
  @State var idx: String?
  @State var at: String?
  
  
  var myid = UserDefaults.standard.object(forKey: "MyID") as? String
  
    var body: some View {
      HStack {
            //내 채팅
        if (self.type != "chat") || (self.userid == self.myid) {
          Spacer()
        }

        //시스템 메시지
        if self.type != "chat"{
          if self.action == "users-new" {
            Text("누가 입장했습니다 ㅎㅎ")
          }
          
        } // 상대방 메시지
        else if self.userid != self.myid{
          HStack(alignment: .top) {
            if self.userid == (chatdata.chatlist[0].messages[Int(self.idx!)! - Int(chatdata.chatlist[0].messages[0].idx!)! - 1].body?.userid!){
              Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
            } else {
              Spacer()
                .frame(width: 30, height: 30)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
            }
            VStack(alignment: .leading, spacing: 5) {
              Text(self.username!)
                .fontWeight(.bold)
                .font(.system(size: 12))
              Text(self.message!)
            }
            .onAppear(perform: {
              print(Int(self.idx!)! - Int(chatdata.chatlist[0].messages[0].idx!)! - 1)
            })
            .foregroundColor(.black)
            .padding(10)
            .background(Color(white: 0.95))
            .cornerRadius(15)
            .onAppear {
              print(chatdata.chatlist[0].messages[Int(self.idx!)! - Int(chatdata.chatlist[0].messages[0].idx!)! - 1].body?.userid)
            }
          }
          .id(UUID(uuidString: self.mid!))
        } // 나의 메시지
        else {
          VStack(alignment: .trailing, spacing: 0) {
            Text(self.message!)
          }
          .id(UUID(uuidString: self.mid!))
          .foregroundColor(.white)
          .padding(10)
          .background(Color.blue)
          .cornerRadius(15)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
        }
        
        


        // 남의 채팅
        if (self.type == "chat") && (self.userid != self.myid) {
        Spacer()
      }
      }
      
      .padding(4)
    }
}

struct MessageCard_Previews: PreviewProvider {
    static var previews: some View {
        MessageCard()
    }
}
