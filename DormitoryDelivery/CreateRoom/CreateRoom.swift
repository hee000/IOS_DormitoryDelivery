//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/20.
//

import Foundation
import SwiftUI


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = value + nextValue()
    }
}

struct createroomdata: Codable {
  var shopName: String            // 제목
  var shopLink: String            // 링크
  var category: String            // 카테고리
  var section: Int             // 배달 지역
  var deliveryPriceAtLeast: Int   // 최소 주문 금액
}

class CreateRoom: ObservableObject {
  @Published var isActive = false
  @Published var userId: String = ""
  @Published var shopName: String = ""
  @Published var deliveryPriceAtLeast: String = ""
  @Published var shopLink: String = "주문할 매장 URL을 공유해주세요. \n외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요."
// https://baemin.me/1a64sSKxS
//  @Published var category: Int? = nil
  @Published var category: Int? = nil
  @Published var section: Int? = nil
  @Published var rid = ""
  @Published var height: CGFloat? = .zero
  @Published var postalertstate = false
  @Published var isAccount = false
  @Published var isInvalidCreateRoom = false
  @Published var invalidCreateRoomText = ""
  @Published var texteditTest = "주문할 매장 URL을 공유해주세요. \n외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요."
  
  func validcheck() -> Bool {
    var valid = true
    if shopName == "" || deliveryPriceAtLeast == "" || category == nil || section == nil {
      valid = false
    }
    return valid
  }
  
  deinit {
    print("방만들기 deinit")
  }
}
