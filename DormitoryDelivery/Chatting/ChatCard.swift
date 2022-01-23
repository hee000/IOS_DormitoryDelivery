//
//  ChatCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import SwiftUI

struct ChatCard: View {
//  @State var RoomDB : ChatDB?
  var title: String?
  var lastmessage: String?
  var lastat: String?
  
    var body: some View {
      HStack{
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))


          VStack(alignment: .leading, spacing: 5){
            if let title = self.title {
              Text(title)
                .font(.title3)
                .foregroundColor(Color.black)
            }
            
            if let lastmessage = self.lastmessage {
              Text(lastmessage)
                  .font(.body)
                  .foregroundColor(Color.black)
            }
          }

          Spacer()

          VStack(alignment: .trailing, spacing: 10) {
            if let lastat = self.lastat {

              Text(datetokor(chatdate: lastat))
                .font(.caption)
                .foregroundColor(Color.black)
            }
            Text(String(4))
              .foregroundColor(Color.white)
              .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
              .background(Color.red)
              .cornerRadius(21)

          }.padding(.trailing)
      }
      .frame( height: 60, alignment: .leading)
      .padding()
    }//h

  func datetokor(chatdate: String) -> String {
    let date = DateFormatter()
    date.locale = Locale(identifier: "ko_kr")
    date.timeZone = TimeZone(abbreviation: "KST")
    date.dateFormat = "dd일 HH:mm"
    let chatdate = date.string(from: Date(timeIntervalSince1970: TimeInterval(Int(chatdate)!)/1000))
    return chatdate
  }
}

//struct ChatCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatCard()
//    }
//}

////
////  ChatCard.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/12/08.
////
//
//import SwiftUI
//import RealmSwift
//
//struct ChatCard: View {
//  var roomid: String
//  @State var RoomDB : ChatDB?
//  @State var title: String
//  @State var lastmessage: String?
//  @State var lastat: String?
//
//    var body: some View {
//      HStack{
//          Image(systemName: "person.circle.fill")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 40, height: 40)
//            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
//            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
//
//
//          VStack(alignment: .leading, spacing: 5){
//            Text(self.title)
//              .font(.title3)
//              .foregroundColor(Color.black)
//            if self.lastmessage != nil  {
//              Text(self.lastmessage!)
//                .font(.body)
//                .foregroundColor(Color.black)
//            }
//          }
//
//          Spacer()
//
//          VStack(alignment: .trailing, spacing: 10) {
//            if self.lastat != nil {
//
//              Text(datetokor(chatdate: self.lastat!))
//                .font(.caption)
//                .foregroundColor(Color.black)
//            }
//            Text(String(4))
//              .foregroundColor(Color.white)
//              .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
//              .background(Color.red)
//              .cornerRadius(21)
//
//          }.padding(.trailing)
//      }
//      .frame( height: 60, alignment: .leading)
//      .padding()
//    }
//
//  func datetokor(chatdate: String) -> String {
//    let date = DateFormatter()
//    date.locale = Locale(identifier: "ko_kr")
//    date.timeZone = TimeZone(abbreviation: "KST")
//    date.dateFormat = "dd일 HH:mm"
//    let chatdate = date.string(from: Date(timeIntervalSince1970: TimeInterval(Int(chatdate)!)/1000))
//    return chatdate
//  }
//}
//
////struct ChatCard_Previews: PreviewProvider {
////    static var previews: some View {
////        ChatCard()
////    }
////}
//
