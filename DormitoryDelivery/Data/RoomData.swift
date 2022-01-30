//
//  RoomData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine
import Alamofire



struct roomdata: Codable, Hashable, Identifiable {
  let id: String;
  var shopName: String;         // 제목
  var section: String;          // 배달지역
  var total: Int;               // 현재 총 금액
  var priceAtLeast: Int;        // 최소 주문 금액
  var purchaserName: String;    // 방장 이름
  var createdAt: Int;           // 만들어진 시간
}

struct roomsdata: Codable, Hashable, Identifiable {
  let id = UUID()
//  var data: Array<roomdata>
  var data: [roomdata]
  var status: Int
}

class RoomData: ObservableObject, Identifiable{
  @Published var data: roomsdata? = nil
}


struct roomdetaildata: Codable, Hashable, Identifiable {
  let id: String;  // 룸 아이디
  var shopName: String
  var category: String;
  var section: String;
  var shopLink: String;
  var atLeast: Int;
  var participants: Int;
  var purchaser: useree;
}

struct useree: Codable, Hashable{
  var name: String?
  var userId: String?
}

class RoomDetailData: ObservableObject {
  @Published var data: roomdetaildata? = nil
  @Published var isActive = true
  
  
  
  func getRoomDetail(matchid: String, token: String) {
    let url = roomdetail(matchId: matchid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
      req.responseJSON { response in
      print(response.value)
      
      let result = response.value as! [String: Any]
      do {
          let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
        self.data = session
        self.isActive.toggle()
        }
      catch {
        print(error)
      }
    }
  }
}
