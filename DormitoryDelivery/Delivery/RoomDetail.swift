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

struct RoomDetail: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var detaildata: RoomDetailData
  @EnvironmentObject var datecheck: DateCheck
  
  @State var isActived = false
  var matchid : String
  var purchaserName : String
  @State var createdAt: Int
  
  @State var injoin = false
  
  
    var body: some View {
      VStack{
        if detaildata.data != nil {
          HStack{ //프사 이름
            Image(systemName: "person.circle.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 30, height: 30)
              .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
              .padding(.leading)
            Text(purchaserName)
            Spacer()
            Text(detaildata.data!.section)
            Text(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(self.createdAt)/1000))) / 60)) + "분전")
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
                getRoomJoin2(matchid: self.matchid, token: mytoken, title:detaildata.data!.shopName, rid: detaildata.data!.id)
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
//              Text("참여하기")
//                .foregroundColor(Color.white)
////                .padding(EdgeInsets(top: 0, leading: 100, bottom: 0, trailing: 100))
//                .frame(width: 350, height: 50)
//                .background(Color.blue)
            }
            NavigationLink(destination: ChattingView(RoomDB: roomidtodbconnect(rid: detaildata.data!.id), Id_room: detaildata.data!.id), isActive: $isActived) {EmptyView().hidden()}.hidden()
          }
          
            
        }
        Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
          ToolbarItem(placement: .principal) {
              HStack {
                Spacer()
                  Text("상세정보창").font(.headline)
                  .padding(.trailing)
                Spacer()
                
              }}}


      .onAppear {
        print("조인시작")
        if let mytoken = naverLogin.loginInstance?.accessToken {
          getRoomDetail(matchid: self.matchid, token: mytoken, detaildata: detaildata)
        }
      }
      .onChange(of: injoin, perform: { newValue in
        print("조인성겅")
        self.isActived = true
        isActived = true
        print("조인성겅")
      })
        
    }
  
  func getRoomJoin2(matchid: String, token: String, title: String, rid: String) {
    print("조인시작")
    let url = roomjoin(matchId: matchid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
    req.response { response in
      print(response)
      do {
        if response.response?.statusCode == 200 {
            let chatroomopen = ChatDB()
            chatroomopen.rid = rid
          chatroomopen.title = title
  //          let realm = try! Realm()
  //          try! realm.write({
  //            realm.add(chatroomopen)
  //          })
            addChatting(chatroomopen)
          self.injoin = true
        }
      } catch {
        print(error)
      }
    }
  }
  
}

//struct RoomDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDetail()
//    }
//}
