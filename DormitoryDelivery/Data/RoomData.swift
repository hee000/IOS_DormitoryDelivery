//
//  RoomData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine



struct roomdata: Codable, Hashable {
  var id: String;
  var shopName: String;         // 제목
  var section: String;          // 배달지역
  var total: Int;               // 현재 총 금액
  var priceAtLeast: Int;        // 최소 주문 금액
  var purchaserName: String;    // 방장 이름
  var createdAt: Int;           // 만들어진 시간
}

struct roomsdata: Codable, Hashable {
  
  var data: Array<roomdata>
  var status: Int
}

class RoomData: ObservableObject, Identifiable {
  @Published var data: roomsdata? = nil
}


struct roomdetaildata: Codable {
  var id: String  // 룸 아이디
  var shopName: String
  var category: String
  var section: String
  var shopLink: String
  var atLeast: Int;
  var participants: Int;
}

class RoomDetailData: ObservableObject {
  @Published var data: roomdetaildata? = nil
  @Published var isActive = false
}
