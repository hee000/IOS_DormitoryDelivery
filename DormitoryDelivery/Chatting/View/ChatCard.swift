import SwiftUI

struct ChatCard: View {
//  @State var RoomDB : ChatDB?
  var title: String?
  var lastmessage: String?
  var lastat: String?
  var users: Int?
  var index: Int?
  var confirmation: Int?
  
    var body: some View {
      HStack{
        HStack{
            if users == 1 {
              Image("ImageDefaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .cornerRadius(28)
                .shadow(color: Color.black.opacity(0.5), radius: 1)
            } else if self.users == 2 {
              ZStack(alignment: .topLeading) {
                Image("ImageDefaultProfile")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 44, height: 44)
                  .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                  .cornerRadius(28)
                  .offset(x: 3, y: 3)
                  .shadow(color: Color.black.opacity(0.5), radius: 1)
                Image("ImageDefaultProfile")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 44, height: 44)
                  .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                  .cornerRadius(28)
                  .offset(x: -3, y: -3)
                  .shadow(color: Color.black.opacity(0.5), radius: 1)
                  .shadow(color: Color.black.opacity(0.5), radius: 3, x:3, y:3)
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if self.users == 3 {
              VStack(alignment: .leading) {
                HStack{
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                }
                Image("ImageDefaultProfile")
                  .resizable()
                  .scaledToFit()
                  .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                  .cornerRadius(28)
              }
            } else {
              VStack(alignment: .leading) {
                HStack{
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                }
                HStack{
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                  Image("ImageDefaultProfile")
                    .resizable()
                    .scaledToFit()
                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                    .cornerRadius(28)
                  
                }
              }
            }
        }
        .frame(width: 50, height: 50)
        .padding(.trailing, 5)


          VStack(alignment: .leading, spacing: 5){
            if let title = self.title {
              Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.black)
            }
            
            if let lastmessage = self.lastmessage {
              Text(lastmessage)
                .font(.system(size: 12, weight: .regular))
                  .foregroundColor(Color.gray)
            } else {
              Text("")
                .font(.system(size: 12, weight: .regular))
            }
          }

          Spacer()

          VStack(alignment: .trailing, spacing: 10) {
            if let lastat = self.lastat {

              Text(datetokor(chatdate: lastat))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color.black)
            }
            
            if (self.index ?? 0) - (self.confirmation ?? 0) != 0 {
              Text(String(self.index! - self.confirmation!))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color.white)
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                .background(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                .cornerRadius(21)
            } else {
              Text("")
                .font(.system(size: 10, weight: .regular))
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            }

          }.padding(.trailing)
      }
      .frame( height: 60, alignment: .leading)
      .padding([.leading, .trailing])
      .padding([.top, .bottom], 10)
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
