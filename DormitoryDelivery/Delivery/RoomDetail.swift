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
  @State var isActive = false
  var matchid : String
  
  @State var injoin = false
  
  
    var body: some View {
      VStack{
        if detaildata.data != nil {
          Text(detaildata.data!.section)
          
          Text(detaildata.data!.category)
          Text(detaildata.data!.shopName)
          Text(detaildata.data!.shopLink)
          
          Text(String(detaildata.data!.atLeast))
          Text(String(detaildata.data!.participants))
          
          
          ZStack{
            Button {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getRoomJoin2(matchid: self.matchid, token: mytoken, title:self.detaildata.data!.shopName, rid: self.detaildata.data!.id)
              }
              
            } label: {
              Text("조인")
            }
            NavigationLink(destination: ChattingView(RoomDB: roomidtodbconnect(rid: self.detaildata.data!.id), Id_room: self.detaildata.data!.id), isActive: $isActive) {EmptyView().hidden()}.hidden()
          }
      
          
            
            
        }

        
        
      }
      .onChange(of: injoin, perform: { newValue in
        print("조인성겅")
        self.isActive = true
        isActive = true
        print("조인성겅")
      })
        .onAppear {
          print("조인시작")
          if let mytoken = naverLogin.loginInstance?.accessToken {
            getRoomDetail(matchid: self.matchid, token: mytoken, detaildata: self.detaildata)
          }
        }
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
