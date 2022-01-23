//
//  Oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation


class Oder: ObservableObject {
  @Published var name = ""
  @Published var quantity = ""
  @Published var description = ""
  @Published var price = ""
  @Published var isActive = false
}

