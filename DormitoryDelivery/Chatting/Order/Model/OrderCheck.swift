//
//  OrderCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation
import UIKit

class OrderCheck: ObservableObject {
  @Published var isShowPhotoLibrary = false
  @Published var image = UIImage()
  @Published var tip = ""
  @Published var imageupload = false
}


struct OrdercheckTip: Codable {
  var rid: String
  var delivery_tip : Int
}
