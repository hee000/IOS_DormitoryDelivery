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
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var datecheck: DateCheck
  @StateObject var detaildata: RoomDetailData = RoomDetailData()
  @State var roomdata: roomdata
  @State var detaildata2 = RoomDetailData()

  
    var body: some View {
      VStack{
        if detaildata.data == nil {
          Text("아니 이게 무슨일이야~~")
        }
        if detaildata.isActive {
          Text("초기화여부확인")
        }
        if detaildata2.data != nil {
          Text(detaildata2.data?.category ?? "없다는디")
        }
        if detaildata.data != nil {
          HStack{ //프사 이름
            Image(systemName: "person.circle.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30)
              .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
              .padding(.leading)
            Text(self.roomdata.purchaserName)
            Spacer()
            Text(detaildata.data!.section)
            Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.roomdata.createdAt)/1000))) / 60)) + "분전")
              .padding(.trailing)
              .foregroundColor(Color.gray)
          }
          .frame(width: 380, height: 60)
          .background(Color(.sRGB, red: 0/255, green: 0/255, blue: 0/255, opacity: 0.02))
          .padding()
          
          VStack{
            Text(detaildata.data!.category)
              .font(.title3)
            Text(detaildata.data!.shopName)
              .font(.title)
              .bold()
            Button {
              //링크 Text(detaildata.data!.shopLink)
            } label: {
              Image("oderlink")
//                .resizable()
//                .scaledToFit()
            }
          }
          .frame(width: 380, height: 200)
//          .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
          .border(Color(.sRGB, red: 0/255, green: 0/255, blue: 0/255, opacity: 0.05), width: 1)
          .shadow(color: Color.gray, radius: 5, x: 5, y: 5)
          
          Spacer()
            .frame(height: 40)
          
          VStack (spacing: 30) {
            HStack{
              Text("최소 주문금액")
                .font(.title3)
                .padding(.leading)
              Spacer()
              Text(String(detaildata.data!.atLeast))
                .bold()
              Text("원")
                .bold()
                .padding(.trailing)
            }
            HStack{
              Text("현재 참여인원")
                .font(.title3)
                .padding(.leading)
              Spacer()
              Text(String(detaildata.data!.participants))
                .bold()
              Text("명")
                .bold()
                .padding(.trailing)
            }
          }
        
        Divider()
          
          Spacer()
          Spacer()
          Spacer()
          ZStack{
            Button {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getRoomJoin(matchid: self.roomdata.id, token: mytoken, title:detaildata.data!.shopName, rid: detaildata.data!.id, detaildata: detaildata)
              }
              
            } label: {
              Image("Rectangle302")
                .resizable()
                .scaledToFit()
                .frame(width: 335, height: 70)

                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                .overlay(Text("참여하기")
                          .bold()
                          .foregroundColor(Color.white))
            }
            
//            NavigationLink(destination: ChattingView(RoomChat: roomidtodbconnect(rid: detaildata.data!.id), roomid: detaildata.data!.id), isActive: $detaildata.isActive) {
//            }.hidden()
            
          } // zstack
          
            
        }
        Spacer()
      }

//      .onChange(of: detaildata, perform: <#T##(Equatable) -> Void##(Equatable) -> Void##(_ newValue: Equatable) -> Void#>)
      .onAppear {
        print("조인시작")
        if let mytoken = naverLogin.loginInstance?.accessToken {
//          getRoomDetail(matchid: self.roomdata.id, token: mytoken, detaildata: detaildata, detaildata2: detaildata2)
          self.detaildata.getRoomDetail(matchid: self.roomdata.id, token: mytoken)
        }
      }
        
    }

  
}

//struct RoomDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDetail()
//    }
//}
