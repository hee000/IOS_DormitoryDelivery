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
  @Published var userId: String = "sadasd"
  @Published var shopName: String = "노브랜드버거_안성석성점"
  @Published var deliveryPriceAtLeast: String = "12000"
  @Published var shopLink: String = "링크"
  @Published var category: String = "korean"
  @Published var section = 0
  @Published var rid = ""
  @Published var height: CGFloat? = .zero
  
}
