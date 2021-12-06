//
//  DeliveryList.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import Foundation

struct RoomCard: View {
  @EnvironmentObject var datecheck: DateCheck

  @State var deliveryTitle: String
  @State var deliveryZone: String
  @State var deliveryPayTip: Int
  @State var deliveryPayTotal: Int
  @State var deliveryId : String
  @State var action: Int?
  @State var purchaserName: String
  @State var createdAt: Int
  
//  @State var now = Date()

  
  
    var body: some View {
      HStack{
      NavigationLink(destination: RoomDetail()) {
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
                
                
//                var interval = self.now.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))
                
//                String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60))
                Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60)))
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
      RoomCard(deliveryTitle: "맥도날드 먹을 사람 찾아요", deliveryZone: "나래관",
                   deliveryPayTip: 500,
                   deliveryPayTotal: 1000,
                   deliveryId: "3",
                   purchaserName: "조창희",
                   createdAt: 1638699322614
      )
    }
}
