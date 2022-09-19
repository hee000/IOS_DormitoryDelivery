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

  var deliveryTitle: String
  var deliveryZone: String
  var deliveryPayTip: Int
  var deliveryPayTotal: Int
  var deliveryId : String
  var action: Int?
  var purchaserName: String
  var createdAt: Int
  
  @State var timestamp: String = ""
  
//  @State var now = Date()

  
  
    var body: some View {
        VStack(spacing: 2){
          HStack{ //타이틀, 업체명
            VStack(alignment: .leading, spacing: 3){
                Text(self.deliveryZone)
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
              
//              Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60) < 60 ? Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60): Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60) < 60*60*24 ? Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / (60*60)): Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / (60*60*24))))
              Text(self.timestamp)
                .font(.system(size: 10))
                .foregroundColor(Color.gray)
                .padding(.leading, 10)
            }
            .padding(.top, 5)
  
            
            Spacer()
            
            
            HStack(spacing: 0){ // 금액
              Text(self.deliveryPayTotal != 0 ? "\(self.deliveryPayTotal)원" : "-")
                .padding(.leading, 5)
                .padding(.trailing, 3)
                .font(.custom("BlackHanSans-Regular", fixedSize: 12))
                .lineLimit(1)
                .foregroundColor(self.deliveryPayTotal > self.deliveryPayTip ? .red : .white)
                .frame(width: 58, alignment: .center)
              Text("/")
                .font(.custom("BlackHanSans-Regular", fixedSize: 12))
                .frame(width: 7, alignment: .center)
              Text("\(self.deliveryPayTip)원")
                .padding(.leading, 3)
                .padding(.trailing, 5)
                .font(.custom("BlackHanSans-Regular", fixedSize: 12))
                .lineLimit(1)
                .frame(width: 58, alignment: .center)
              }
                .foregroundColor(Color.white)
                .frame(width: 123, height: 28)
                .background(Image("Rectangle302")
                              .resizable()
                              .scaledToFit()
                              .frame(width: 123, height: 28)
                              .cornerRadius(3))
            }
        } //v
      .padding()
//      .padding([.leading, .trailing])
      .background(Color(.sRGB,red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
      .onAppear(perform: {
        let calendar = Calendar(identifier: .gregorian)  // 예전에는 식별자를 문자열로 했는데, 별도
        let offsetComps = calendar.dateComponents([.day,.hour,.minute], from:Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000), to:datecheck.nowDate)
        print(offsetComps)
        if case let (d?, h?, m?) = (offsetComps.day, offsetComps.hour, offsetComps.minute) {
          if d != 0 {
            self.timestamp = "\(d)일 전"
          } else if h != 0 {
            self.timestamp = "\(h)시간 전"
          } else {
            self.timestamp = "\(m)분 전"
          }
        }
      })
      .onChange(of: datecheck.nowDate) { V in
        let calendar = Calendar(identifier: .gregorian)  // 예전에는 식별자를 문자열로 했는데, 별도
        let offsetComps = calendar.dateComponents([.day,.hour,.minute], from:Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000), to:V)
        print(offsetComps)
        if case let (d?, h?, m?) = (offsetComps.day, offsetComps.hour, offsetComps.minute) {
          if d != 0 {
            self.timestamp = "\(d)일 전"
          } else if h != 0 {
            self.timestamp = "\(h)시간 전"
          } else {
            self.timestamp = "\(m)분 전"
          }
        }
      }
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
