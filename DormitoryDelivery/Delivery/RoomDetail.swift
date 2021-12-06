//
//  RoomDetail.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import SwiftUI
import Alamofire
import SocketIO

struct RoomDetail: View {
  @EnvironmentObject var detaildata: RoomDetailData
  var matchid : String
  
  func GetRoomDetail() {
    let url = roomdetail(matchId: self.matchid)
    let authorization = UserDefaults.standard.string(forKey: "AccessToken")!
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    req.responseJSON { response in
      let result = response.value as! [String: Any]
      do {
          let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
          self.detaildata.data = session
        }
      catch {
        print(error)
      }
    }
  }
  
    var body: some View {
      VStack{
        if detaildata.data != nil {
          Text(detaildata.data!.section)
          
          Text(detaildata.data!.category)
          Text(detaildata.data!.shopName)
          Text(detaildata.data!.shopLink)
          
          Text(String(detaildata.data!.atLeast))
          Text(String(detaildata.data!.participants))
          
      
          Button(action: {
            
            let url = roomjoin(matchId: self.matchid)
            let authorization = UserDefaults.standard.string(forKey: "AccessToken")!
            
            let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
//            req.responseJSON { response in
            req.response { response in
              print(response.response)
              print(response.result)
              print(response.value)
//              print(response.value)
//              if response.value != nil {
//                let result = response.value! as! [String: Any]
//                print(result)
//              }
              do {
//                let data2 = try JSONSerialization.data(withJSONObject: response.data!, options: []) as? [String : Any]
//                let data2 = try JSONEncoder().encode(response.value!!)
                
//                let data3 = try JSONSerialization.data(withJSONObject: data2, options: .prettyPrinted)
                if response.value != nil {
                  print(String(decoding: response.value!!, as: UTF8.self))
                }
//                print(data2)
//                  let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
//                  self.detaildata.data = session
                }
              catch {
                print(error)
              }
            }
            
          }) {
            NavigationLink(destination: ChattingView(Id_room: "33")) {
            Text("Button")
            }
//            .navigationBarHidden(true)
          }

         
        }

        
        
      }
        .onAppear {
          GetRoomDetail()
        }
    }
}

//struct RoomDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomDetail()
//    }
//}
