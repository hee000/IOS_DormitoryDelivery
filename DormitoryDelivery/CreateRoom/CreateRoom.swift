//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/20.
//

import Foundation
import SwiftUI

class CreateRoom: ObservableObject {

  @Published var isActive = false
  @Published var userId: String = ""
  @Published var shopName: String = ""
  @Published var deliveryPriceAtLeast: String = ""
  @Published var shopLink: String = ""
  @Published var category: Int? = nil
  @Published var section = 0
  @Published var rid = ""
  @Published var height: CGFloat? = .zero
  @Published var postalertstate = false
  
  func validcheck() -> Bool {
    var valid = true
    if shopName == "" || deliveryPriceAtLeast == "" || category == nil {
      valid = false
    }
    return valid
  }
}
