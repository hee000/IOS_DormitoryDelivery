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
  
  
    var body: some View {
      VStack{
        if detaildata.data != nil {
          Text(detaildata.data!.section)
          
          Text(detaildata.data!.category)
          Text(detaildata.data!.shopName)
          Text(detaildata.data!.shopLink)
            .onAppear {
              print(self.matchid)
            }
          
          Text(String(detaildata.data!.atLeast))
          Text(String(detaildata.data!.participants))
          
          
          ZStack{
            Button {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getRoomJoin(matchid: self.matchid, token: mytoken, title:self.detaildata.data!.shopName)
              }
              self.isActive = true
            } label: {
              Text("조인")
            }
            NavigationLink(destination: ChattingView(Id_room: self.detaildata.data!.id), isActive: $isActive) {EmptyView().hidden()}.hidden()
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
