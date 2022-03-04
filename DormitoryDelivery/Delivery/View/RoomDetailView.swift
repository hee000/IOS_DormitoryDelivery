//
//  RoomDetail.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import SwiftUI
import Alamofire
import SocketIO
import RealmSwift

struct RoomDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var chatnavi: ChatNavi
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var datecheck: DateCheck

//  @StateObject var detaildata: RoomDetailData = RoomDetailData()
  @StateObject var detaildata: RoomDetailData
//  @State var roomdata: roomdata
  @Binding var tabSelect: Int

  @State var timestamp: String = ""

  
    var body: some View {
      VStack(spacing: 20) {
        if detaildata.data != nil {
          HStack{ //프사 이름
            HStack{
              Image("ImageDefaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .cornerRadius(100)
                .shadow(color: Color.black.opacity(0.5), radius: 1)
              Text(self.detaildata.roomdata.purchaserName)
                .font(.system(size: 15, weight: .bold))
                .padding(.leading)
              Spacer()
              Text(detaildata.data!.section)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color.gray)
//              Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.detaildata.roomdata.createdAt)/1000))) / 60)) + "분전")
              Text(self.timestamp)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color.gray)
            }
            .padding([.leading, .trailing])
          }
          .frame(height: 60)
          .background(Color(.sRGB, red: 249/255, green: 249/255, blue: 250/255, opacity: 1))
          .cornerRadius(5)
          
          VStack(spacing: 0){
            Text(categoryNameToKor[detaildata.data!.category]!)
              .font(.system(size: 15, weight: .bold))
              .padding(.top, 30)
              .padding(.bottom, 7)
            Text(detaildata.data!.shopName)
              .font(.system(size: 24, weight: .bold))
              .padding(.bottom, 15)
            Button {
              //링크 Text(detaildata.data!.shopLink)
            } label: {
              Text("주문 매장 링크확인 >")
                .font(.system(size: 10, weight: .regular))
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
                .foregroundColor(.gray)
                .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 0.12))
                .cornerRadius(13)
//                .resizable()
//                .scaledToFit()
            }
            .padding(.bottom, 30)
          }
          .frame(maxWidth: .infinity)
          .background(Color.white)
          .cornerRadius(5)
          .shadow(color: Color.black.opacity(0.2), radius: 8)
          
          
          VStack (spacing: 30) {
            HStack{
              Text("최소 주문금액")
                .font(.system(size: 17, weight: .regular))
              Spacer()
              Text(String(detaildata.data!.atLeast))
                .font(.system(size: 19, weight: .bold))
              Text("원")
                .font(.system(size: 19, weight: .bold))
            }
            HStack{
              Text("현재 참여인원")
                .font(.system(size: 17, weight: .regular))
              Spacer()
              Text(String(detaildata.data!.participants))
                .font(.system(size: 19, weight: .bold))
              Text("명")
                .font(.system(size: 19, weight: .bold))
            }
          }
        
          Divider()
          
          Spacer()
          
          Button{
              getRoomJoin(matchid: self.detaildata.roomdata.id, title:detaildata.data!.shopName, rid: detaildata.data!.id, detaildata: detaildata, navi: chatnavi)
          } label: {
            Text("참여하기")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.white)
              .frame(height: 50)
              .frame(maxWidth: .infinity)
          }
          .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
          .cornerRadius(5)
        } //if
      } //v
      .padding(.top)
      .padding([.leading, .trailing])
      .padding([.leading, .trailing])
      .onChange(of: detaildata.isActive, perform: { newValue in
        presentationMode.wrappedValue.dismiss()
      })
      .onDisappear(perform: {
        if detaildata.isActive {
          self.tabSelect = 2
        }
      })
      .onAppear {
        self.detaildata.getRoomDetail(matchid: self.detaildata.roomdata.id)
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(detaildata.roomdata.shopName)
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
                  .foregroundColor(.black)
              }
            }
          }
      }
      .onAppear(perform: {
        let calendar = Calendar(identifier: .gregorian)  // 예전에는 식별자를 문자열로 했는데, 별도
        let offsetComps = calendar.dateComponents([.day,.hour,.minute], from:Date(timeIntervalSince1970: TimeInterval(self.detaildata.roomdata.createdAt)/1000), to:datecheck.nowDate)
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
        let offsetComps = calendar.dateComponents([.day,.hour,.minute], from:Date(timeIntervalSince1970: TimeInterval(self.detaildata.roomdata.createdAt)/1000), to:V)
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
