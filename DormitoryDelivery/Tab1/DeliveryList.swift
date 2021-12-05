//
//  DeliveryList.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import Foundation

struct DeliveryList: View {
  @State var deliveryTitle: String
  @State var deliveryZone: String
  @State var deliveryPayTip: Int
  @State var deliveryPayTotal: Int
  @State var deliveryId : String
  @State var action: Int?
  @State var purchaserName: String
  @State var createdAt: Int
  
  @State var now = Date()
//  @State var interval : Double
//  @State var interval = 0

//  init(deliveryTitle: String, deliveryZone: String, deliveryPayTip: Int, deliveryPayTotal: Int, deliveryId : String, action: Int?, purchaserName: String) {
//    self.deliveryTitle = deliveryTitle
//    self.deliveryZone = deliveryZone
//    self.deliveryPayTip = deliveryPayTip
//    self.deliveryPayTotal = deliveryPayTotal
//    self.deliveryId = deliveryId
//    self.action = action
//    self.purchaserName = purchaserName
//
//    self.createdAt = 0
//    self.now = Date()
//    self.interval = now.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))
//  }
  
    var body: some View {
      HStack{
      NavigationLink(destination: Join(Id_room: self.deliveryId)) {
        VStack(spacing: 2){
          HStack{ //타이틀, 업체명
            VStack(alignment: .leading, spacing: 3){
              Text("\(self.deliveryZone)관")
                .font(.system(size: 15))
                .foregroundColor(Color.gray)
              Text(self.deliveryTitle)
//                .font(.custom("AppleSDGothicNeoEB00-Regular",size: 18))
                .font(.system(size: 18))
                .foregroundColor(Color.black)
                .fontWeight(.heavy)
            }
            Spacer()
            }
            
          
          HStack{
            VStack(alignment: .leading){
              
              HStack(spacing: 2){
                Image(systemName: "person.circle.fill")
                  .foregroundColor(Color(.init(srgbRed: 180/255, green: 200/255, blue: 255/255, alpha: 1)))
//                  .font(.system(size: 12))
                Text(self.purchaserName)
                  .font(.system(size: 12))
                  .foregroundColor(Color.gray)
                
                
                
                var interval = self.now.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))
                
                Text(String(Int(interval / 60)))
                  .font(.system(size: 10))
                  .foregroundColor(Color.gray)
                  .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Text("분전")
                  .font(.system(size: 10))
                  .foregroundColor(Color.gray)
              }

            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
  
            
            Spacer()
            
            
            HStack{ // 금액
              Text(String(self.deliveryPayTotal))
                .font(.system(size: 12))
                .fontWeight(.black)
              Text("/")
                .font(.system(size: 12))
                .fontWeight(.black)
              Text(String(self.deliveryPayTip))
                .font(.system(size: 12))
                .fontWeight(.black)
                              
              }
                .foregroundColor(Color.white)
                .frame(width: 123, height: 28)
                .background(Image("Rectangle302")
                              .resizable()
                              .frame(width: 123, height: 28))
            }


        }
        
        
    }
      .padding()
  }
//      .frame(height: 119)
//      .padding()
      .background(Color(.sRGB,red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
//      .cornerRadius(10)
//      .overlay(
//        RoundedRectangle(cornerRadius: 0)
//          .stroke(Color(.sRGB,red: 245/255, green: 245/255, blue: 251/255, opacity: 1), lineWidth: 0)
//      )

  }
  
}

struct DeliveryList_Previews: PreviewProvider {
    static var previews: some View {
      DeliveryList(deliveryTitle: "맥도날드 먹을 사람 찾아요", deliveryZone: "나래관",
                   deliveryPayTip: 500,
                   deliveryPayTotal: 1000,
                   deliveryId: "3",
                   purchaserName: "조창희",
                   createdAt: 1638699322614
      )
    }
}


//
//import SwiftUI
//
//struct DeliveryList: View {
//  @State var deliveryTitle: String
//  @State var deliveryZone: String
//  @State var deliveryPayTip: Int
//  @State var deliveryPayTotal: Int
//  @State var deliveryId : Int
//  @State var action: Int?
//  @State var isFavorite: Bool = false
//
//    var body: some View {
//      HStack{
//      NavigationLink(destination: Join(Id_room: self.deliveryId)) {
//        HStack{
//          VStack{
//            Text(String(self.deliveryPayTip))
//              .bold()
//              .foregroundColor(Color.red)
//            Text(String(self.deliveryPayTotal))
//              .bold()
//          }
//          .frame(width: 70, height: 70)
//          .background(Color.gray)
//          .cornerRadius(10)
//
//          VStack(alignment: .leading){
//            Text(self.deliveryTitle)
//            Text("배달지역: \(self.deliveryZone)")
////            Text(self.deliveryPay.)
//          }
//
//          Spacer()
//        }
//      }
//        .foregroundColor(Color.black)
//
//      if isFavorite {
//        Label("Toggle Favorite", systemImage: "heart.fill")
//            .labelStyle(.iconOnly)
//            .foregroundColor(Color.pink)
//            .font(.title)
//            .onTapGesture {
//              self.isFavorite = false
//            }
//      } else {
//      Label("Toggle Favorite", systemImage: "heart")
//          .labelStyle(.iconOnly)
//          .foregroundColor(Color.gray)
//          .font(.title)
//          .onTapGesture {
//            self.isFavorite = true
//          }
//      }
//
//    }
//      .padding()
//      .cornerRadius(10)
//      .overlay(
//        RoundedRectangle(cornerRadius: 10)
//          .stroke(Color(.sRGB,red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 0)
//      )
//
//  }
//}
//
//struct DeliveryList_Previews: PreviewProvider {
//    static var previews: some View {
//        DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPayTip: 3000, deliveryPayTotal: 12000, deliveryId: 14)
//    }
//}
//























////
////  DeliveryList.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/16.
////
//
//import SwiftUI
//
//struct DeliveryList: View {
//  @State var deliveryTitle: String
//  @State var deliveryZone: String
//  @State var deliveryPay: String
//  @State var deliveryId : Int
//  @State var action: Int?
//
//    var body: some View {
//      HStack{
//        NavigationLink(destination: Join(Id_room: self.deliveryId), tag: 1, selection: $action) {
//            Text("조인")
//        }.hidden()
//          .frame(width: 0, height: 0)
//
//        VStack{
////          Text(self.deliveryPay)
//          Text("8000")
//            .bold()
//            .foregroundColor(Color.red)
//          Text("12000")
//            .bold()
//        }
//        .frame(width: 70, height: 70)
//        .background(Color.gray)
//        .cornerRadius(10)
//
//        VStack(alignment: .leading){
//
//          Text(self.deliveryTitle)
//          Text("배달지역: \(self.deliveryZone)")
//          Text(self.deliveryPay)
//
//        }
//
//        Spacer()
//
//
//        Label("Toggle Favorite", systemImage: "heart")
//            .labelStyle(.iconOnly)
//            .foregroundColor(Color.gray)
//            .font(.title)
//
////        Button(action: {
////          self.action = 1
////        }) {
////          Text("조인")
////        }
////          .buttonStyle(BorderlessButtonStyle())
////          .font(.system(size: 14))
////          .frame(width: 50, height: 30, alignment: .center)
////          .foregroundColor(Color.white)
////          .background(Color.red)
////          .opacity(0.9)
////          .cornerRadius(10.0)
//
//      }
//        .padding()
//        .cornerRadius(10)
//        .overlay(
//          RoundedRectangle(cornerRadius: 10)
//            .stroke(Color(.sRGB,red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), lineWidth: 0)
//        )
//    }
//}
//
//struct DeliveryList_Previews: PreviewProvider {
//    static var previews: some View {
//        DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPay: "8000/4000", deliveryId: 14)
//    }
//}
