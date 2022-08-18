//
//  RoomDetail.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/20.
//

import Foundation
import Combine
import Alamofire


class RoomDetail: ObservableObject {

  @Published var isActive = false
  @Published var matchid: String = ""
  @Published var purchaserName: String = ""
  @Published var createdAt: Int = 0
}

struct roomdetaildata: Codable, Hashable, Identifiable {
  let id: String;  // 룸 아이디
  var shopName: String
  var category: String;
  var section: String;
  var shopLink: String;
  var atLeast: Int;
  var participants: Int;
  var purchaser: userdata;
}

class RoomDetailData: ObservableObject {
  @Published var data: roomdetaildata? = nil
  @Published var isActive = false
  @Published var isInvalidCheck = false
  @Published var invalidText = ""
  
  var roomdata: roomdata
  
  init(room: roomdata) {
    self.roomdata = room
  }
  
  func getRoomDetail(matchid: String) {
    let tk = TokenUtils()
    let url = roomdetail(matchId: matchid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())
      req.responseJSON { response in

        //리스폰 상태 200일떄로 이프문 걸기
        guard let statusCode = response.response?.statusCode else { return }
        
        if statusCode == 200 {
          guard let restdata = try? JSONDecoder().decode(roomdetaildata.self, from: response.data!) else { return }
          self.data = restdata
        }
        
//      let result = response.value as! [String: Any]
//      do {
//          let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
//          let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
//        self.data = session
////        self.isActive.toggle()
//        }
//      catch {
//        print(error)
//      }
    }
  }
}
