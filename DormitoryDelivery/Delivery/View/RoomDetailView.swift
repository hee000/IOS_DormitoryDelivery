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

  @StateObject var detaildata: RoomDetailData = RoomDetailData()
  @State var roomdata: roomdata
  @Binding var tabSelect: Int

  
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
              Text(self.roomdata.purchaserName)
                .bold()
                .padding(.leading)
              Spacer()
              Text(sectionNameToKor[detaildata.data!.section]!)
                .foregroundColor(Color.gray)
              Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.roomdata.createdAt)/1000))) / 60)) + "분전")
                .foregroundColor(Color.gray)
            }
            .padding([.leading, .trailing])
          }
          .frame(height: 60)
          .background(Color(.sRGB, red: 249/255, green: 249/255, blue: 250/255, opacity: 1))
          
          VStack(spacing: 0){
            Text(categoryNameToKor[detaildata.data!.category]!)
              .bold()
              .padding(.top, 30)
              .padding(.bottom, 7)
            Text(detaildata.data!.shopName)
              .font(.title)
              .bold()
              .padding(.bottom, 15)
            Button {
              //링크 Text(detaildata.data!.shopLink)
            } label: {
              Text("주문 매장 링크확인 >")
                .font(.caption2)
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
                .font(.title3)
              Spacer()
              Text(String(detaildata.data!.atLeast))
                .font(.title3)
                .bold()
              Text("원")
                .font(.title3)
                .bold()
            }
            HStack{
              Text("현재 참여인원")
                .font(.title3)
              Spacer()
              Text(String(detaildata.data!.participants))
                .font(.title3)
                .bold()
              Text("명")
                .font(.title3)
                .bold()
            }
          }
        
          Divider()
          
          Spacer()
          
          Button{
            if let mytoken = naverLogin.loginInstance?.accessToken {
              getRoomJoin(matchid: self.roomdata.id, token: mytoken, title:detaildata.data!.shopName, rid: detaildata.data!.id, detaildata: detaildata, navi: chatnavi)
            }
          } label: {
            Text("참여하기")
              .font(.title3)
              .foregroundColor(.white)
              .bold()
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
        if let mytoken = naverLogin.loginInstance?.accessToken {
          self.detaildata.getRoomDetail(matchid: self.roomdata.id, token: mytoken)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(detaildata.data != nil ? detaildata.data!.shopName : "상세보기")
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
        
    }
}

//struct RoomDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDetail()
//    }
//}
