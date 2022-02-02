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
        VStack(spacing: 2){
          HStack{ //타이틀, 업체명
            VStack(alignment: .leading, spacing: 3){
              Text("\(sectionNameToKor[self.deliveryZone]!)관")
                .font(.system(size: 15))
                .foregroundColor(Color.gray)
              Text(self.deliveryTitle)
                .font(.system(size: 18))
                .foregroundColor(Color.black)
                .fontWeight(.heavy)
                .padding(.top, 5)
            }
            Spacer()
            }
            
          
          HStack{
              
            HStack{
              Image("ImageDefaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
                .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .cornerRadius(100)
                .shadow(color: Color.black.opacity(0.5), radius: 1)

              Text(self.purchaserName)
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
              
              Text("\(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60))) 분전")
                .font(.system(size: 10))
                .foregroundColor(Color.gray)
                .padding(.leading, 10)
            }
            .padding(.top, 5)
  
            
            Spacer()
            
            
            HStack{ // 금액
              Spacer()
              Text(self.deliveryPayTotal != 0 ? "\(String(self.deliveryPayTotal))원" : "-")
                .font(.system(size: 12))
                .fontWeight(.black)
                .foregroundColor(self.deliveryPayTotal > self.deliveryPayTip ? .red : .white)
              Spacer()
              Text("/")
                .font(.system(size: 12))
                .fontWeight(.black)
              Spacer()
              Text("\(String(self.deliveryPayTip))원")
                .font(.system(size: 12))
                .fontWeight(.black)
              Spacer()
              }
                .foregroundColor(Color.white)
                .frame(width: 123, height: 28)
                .background(Image("Rectangle302")
                              .resizable()
                              .scaledToFit()
                              .frame(width: 123, height: 28))
            }
        } //v
      .padding()
//      .padding([.leading, .trailing])
      .background(Color(.sRGB,red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
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
