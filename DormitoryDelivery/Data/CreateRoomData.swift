//
//  CreateRoomData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine


struct createroomdata: Codable {
  var shopName: String            // 제목
  var shopLink: String            // 링크
  var category: String            // 카테고리
  var section: Int             // 배달 지역
  var deliveryPriceAtLeast: Int   // 최소 주문 금액
}


struct addmenu: Codable {
  var name: String            // 이름
  var quantity: Int            // 개수
  var description: String            // 내용
  var price: Int             // 가격
}
