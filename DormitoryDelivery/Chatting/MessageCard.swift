//
//  MessageCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import SwiftUI
import RealmSwift

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
  @State var index : Int
  @State var RoomDB : ChatDB?
  
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
        else if self.userid != self.myid && self.type != "system"{
          otheruser()
//          HStack(alignment: .top) {
//
//
//            if self.userid != RoomDB!.messages[self.index - 1].body!.userid! {
//              Image(systemName: "person.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 30, height: 30)
//                .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
//                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
//            } else {
//              Spacer()
//                .frame(width: 30, height: 30)
//                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
//            }
//            VStack(alignment: .leading, spacing: 5) {
//              Text(self.username!)
//                .fontWeight(.bold)
//                .font(.system(size: 12))
//              Text(self.message!)
//            }
//            .onAppear(perform: {
//              print("인덱스는 \(self.index)")
//              print("self.userid는 \(self.userid)")
//              print("전 단계 인덱스는 \(self.index - 1)")
//              print("전 단계 userid는 \(RoomDB?.messages[self.index - 1].id!)")
//            })
//            .foregroundColor(.black)
//            .padding(10)
//            .background(Color(white: 0.95))
//            .cornerRadius(15)
//          }
//          .id(UUID(uuidString: self.mid!))
        } // 나의 메시지
        else {
          VStack(alignment: .trailing, spacing: 0) {
            Text(self.message!)
          }
          .foregroundColor(.white)
          .padding(10)
          .background(Color.blue)
          .cornerRadius(15)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
          .id(UUID(uuidString: self.mid!))
        }
        
        


        // 남의 채팅
        if (self.type == "chat") && (self.userid != self.myid) {
        Spacer()
      }
      }
      
      .padding(4)
    }
  
  @ViewBuilder
  func otheruser() -> some View {
    let othercard = {
    HStack(alignment: .top) {
      if RoomDB?.messages[self.index - 1].type != "system" {
        if self.userid != RoomDB?.messages[self.index - 1].body!.userid! {
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
        .foregroundColor(.black)
        .padding(10)
        .background(Color(white: 0.95))
        .cornerRadius(15)
      } else {
        
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
        VStack(alignment: .leading, spacing: 5) {
          Text(self.username!)
            .fontWeight(.bold)
            .font(.system(size: 12))
          Text(self.message!)
        }
        .foregroundColor(.black)
        .padding(10)
        .background(Color(white: 0.95))
        .cornerRadius(15)
      }
    }
      .id(UUID(uuidString: self.mid!))
    }
    return othercard()
  }
}

//struct MessageCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageCard()
//    }
//}
