//
//  RoomDetail.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/20.
//

import Foundation

class RoomDetail: ObservableObject {

  @Published var isActive = false
  @Published var matchid: String = ""
  @Published var purchaserName: String = ""
  @Published var createdAt: Int = 0
}
