//
//  ChatData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine
import Alamofire
import RealmSwift
import SocketIO


struct ChatRoom: Codable, Identifiable {
  let id: UUID      // vid를 의미
  let message: String //
  let user: String
  let userID: Bool
}


struct chatEmitData: Codable, SocketData {
  var roomId: String
  var message: String
  
  func socketRepresentation() -> SocketData {
      return ["roomId": roomId, "message": message]
  }
}
