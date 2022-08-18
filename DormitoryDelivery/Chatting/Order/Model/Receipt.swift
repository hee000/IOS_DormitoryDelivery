//
//  Receipt.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation
import UIKit

class Receipt: ObservableObject {
  @Published var image = UIImage()
  @Published var images = [UIImage]()
  @Published var data: receiptdata? = nil
}


struct receiptdata: Codable {
  var menus: [orderlistmenudata];
  var tipForUser: Int?;
  var totalPrice: Int?;
  var accountNumber: String;
  var accountBank: String;
  var accountUserName: String;
}
