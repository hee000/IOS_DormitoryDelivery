//
//  ChatModule.swift.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/07.
//

import Foundation
import SwiftUI
import zlib


func chatsoket(){
  SocketIOManager.shared.socket.on("chat") { (dataArray, ack) in
    do {
      ForEach(0 ..< dataArray.count) { index in
        let a = dataArray[index]
      }
    }
    catch {
      print(error)
    }
  }
  
}
