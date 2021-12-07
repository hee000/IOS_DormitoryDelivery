//
//  Emitsub.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation

func emitSubscribe(rooms:RoomData, section: [String], category: [String]){
  
  rooms.data = nil
  do{
    let subscribeform = homeViewOption(category: category, section: section)
    print("구독시작22")
    SocketIOManager.shared.matchSocket.emitWithAck("subscribe", subscribeform).timingOut(after: 2, callback: { (data) in
      do {
        if data[0] as? String != "NO ACK" {
          let data2 = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomsdata.self, from: data2)
          rooms.data = session
        }
      }
      catch {
        print(error)
      }
    })
  } catch {
    print(error)
  }
  
}
