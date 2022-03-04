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
  @Published var section: Int? = nil
  @Published var rid = ""
  @Published var height: CGFloat? = .zero
  @Published var postalertstate = false
  @Published var isAccount = false
  
  
  func validcheck() -> Bool {
    var valid = true
    if shopName == "" || deliveryPriceAtLeast == "" || category == nil || section == nil {
      valid = false
    }
    return valid
  }
}
