//
//  OnChat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import RealmSwift

func onChat(){
  print("쳇온")
  SocketIOManager.shared.roomSocket.off("chat")
  SocketIOManager.shared.roomSocket.on("chat") { (dataArray, ack) in

    
    do {
      var jsonResult = dataArray[0] as? Dictionary<String, AnyObject>
      if let messages = jsonResult?["messages"] as? NSArray {
        let message = try! JSONSerialization.data(withJSONObject: messages.firstObject!, options: .prettyPrinted)
//          print(messages)
//          print(String(data: messages, encoding: .utf8)!)
        let json = try JSONDecoder().decode(ChatMessageDetail.self, from: message)
        
        let realm = try! Realm()
        let chatroom = realm.object(ofType: ChatDB.self, forPrimaryKey: "0")    /// 수정 필요
        try! realm.write {
          chatroom?.messages.append(json)
        }

        
      }
      
      let data = try! JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
      print("파싱결과")
//        print(String(data: data, encoding: .utf8)!)
//        let json = try JSONDecoder().decode(ChatDB.self, from: data)
//        addChatting(json)
      
      print("암것도아님")
    } catch {
      print(error)
    }
    }
}
