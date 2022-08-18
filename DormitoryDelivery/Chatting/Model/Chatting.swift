//
//  Chatting.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation
import SwiftUI
import Alamofire

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

class ChattingSendText: ObservableObject {
  @Published var textHeight: CGFloat?
  @Published var text = ""
}

class Chatting: ObservableObject {
//  @Published var textHeight: CGFloat?
//  @Published var text = ""
  @Published var showMenu = false
  @Published var leave = false
  @Published var oderview = false
  @Published var oderlistview = false
  @Published var odercheck = false
  @Published var userodercheck = false
  @Published var resetview = false
  @Published var voteview = false
  @Published var voteindex = 0
  @Published var isReceiver = true
  @Published private var offset = CGFloat.zero
  @Published private var stacksize = CGFloat.zero
  @Published private var scrollsize = CGFloat.zero
  @Published var voteId = ""
  
  func getRoomLeave(rid: String, token: String) {
    let url = urlroomleave(rid: rid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
    req.response { response in
      do {
        if response.response?.statusCode == 200 {
          self.leave.toggle()
        }
      } catch {
        print(error)
      }
    }
  }
}
