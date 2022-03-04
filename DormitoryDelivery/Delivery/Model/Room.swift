//
//  Room.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation
import Combine

struct roomdata: Codable, Hashable, Identifiable {
  var id: String;
  var shopName: String;         // 제목
  var section: String;          // 배달지역
  var total: Int;               // 현재 총 금액
  var priceAtLeast: Int;        // 최소 주문 금액
  var purchaserName: String;    // 방장 이름
  var createdAt: Int;           // 만들어진 시간
}

struct roomsdata: Codable {
//  var data: Array<roomdata>
  var data: [roomdata]
  var status: Int
}

class RoomData: ObservableObject, Identifiable{
  @Published var data: roomsdata? = nil
}

