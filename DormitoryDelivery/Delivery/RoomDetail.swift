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
  var matchid : String
  
  
    var body: some View {
      VStack{
        if detaildata.data != nil {
          Text(detaildata.data!.section)
          
          Text(detaildata.data!.category)
          Text(detaildata.data!.shopName)
          Text(detaildata.data!.shopLink)
          
          Text(String(detaildata.data!.atLeast))
          Text(String(detaildata.data!.participants))
          
          
          Button {
            if let mytoken = naverLogin.loginInstance?.accessToken {
              roomJoin(matchid: self.matchid, token: mytoken)
            }
          } label: {
            Text("조인")
          }

      
          Button(action: {
          }) {
            NavigationLink(destination: ChattingView(Id_room: "33")) {
            Text("Button")
            }
          }
        }

        
        
      }
        .onAppear {
          if let mytoken = naverLogin.loginInstance?.accessToken {
            getRoomDetail(matchid: self.matchid, token: mytoken, detaildata: self.detaildata)
          }
        }
    }
}

//struct RoomDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDetail()
//    }
//}
