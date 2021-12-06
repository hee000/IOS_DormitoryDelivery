//
//  RoomData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine


struct roomdata: Codable {
  var id: String;
  var shopName: String;         // 제목
  var section: String;          // 배달지역
  var total: Int;               // 현재 총 금액
  var priceAtLeast: Int;        // 최소 주문 금액
  var purchaserName: String;    // 방장 이름
  var createdAt: Int;           // 만들어진 시간
}

struct roomsdata: Codable {
  var data: Array<roomdata>
  var status: Int
}

class RoomData: ObservableObject {
  @Published var data: roomsdata? = nil
  
//  init() {
//    self.data = nil
//  }
}
