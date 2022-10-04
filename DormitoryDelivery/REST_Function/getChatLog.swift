//
//  getChatLog.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire
import RealmSwift


func getChatLog(rid: String, idx: Int) {
  restApiQueue.async {
    let url1 = urlchatread(rid: rid)
    let req1 = AF.request(url1, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    req1.responseJSON { response in
      appVaildCheck(res: response)

      guard let data = response.data,
            let json = try? JSONDecoder().decode(List<ChatRead>.self, from: data)
      else { return }
      
      let realm = try! Realm()
      try! realm.write {
        if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
          db.read = json
          
          for i in json {
            if i.userId == UserData().data?.id {
              db.confirmation = i.messageId
            }
          }
        }
      }
    }
    
    
    
    
    let index = idx + 1
    let url = urlchatlog(rid: rid, idx: String(index))
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    req.responseJSON { response in
      do {
  //      let result = response.value as! [Any]
  //      let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
  //      let json = try JSONDecoder().decode([ChatMessageDetail].self, from: message)

//        print(response)
        guard let code = response.response?.statusCode else { return }
        appVaildCheck(res: response)
        
        print(response.response?.statusCode, rid  )
        if response.response?.statusCode == 403 {
          let realm = try! Realm()
          try! realm.write {
            if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
              print("펑션 지우기rid", rid)
              realm.delete(db)
            }
          }
        }
        
        guard let data = response.data else { return }
        guard let json = try? JSONDecoder().decode(List<ChatMessageDetail>.self, from: data) else { return }
        
        let realm = try! Realm()
        try! realm.write {
          if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
            realm.add(json, update: .modified)
            db.messages = json
            
            if let last = db.messages.filter("type == 'chat'").last?.at {
              db.sortforat = Int(last)!
            }
            
//            print("@@@", db.title, db.read)
          }
        }
//        print(json)
//        let realm = try! Realm()
//        try! realm.write {
//  //        for chatdetail in json {
//  //          if chatdetail.type == "system" {
//  //            print("시스템이래")
//  //          }
//  //          let chatdb = roomidtodbconnect(rid: rid)
//  //          chatdb?.messages.append(<#T##object: ChatMessageDetail##ChatMessageDetail#>)
//  //        }
//          let chatdb = roomidtodbconnect(rid: rid)
//          realm.add(json, update: .modified)
//
//          for chat in json {
//            guard !((chatdb?.messages.contains(chat)) ?? false) else {
//  //            print("이미 있음")
//              continue
//            }
//  //          print("저장함")
//            chatdb?.messages.append(chat)
//            if chat.type == "chat" {
//              chatdb?.sortforat = Int(chat.at!)!
//            }
//          }
//
//          if let last = chatdb?.messages.filter("type == 'chat'").last?.at {
//            chatdb?.sortforat = Int(last)!
//          }
//
//
//
//          if let sortmessages = chatdb?.messages.sorted(byKeyPath: "idx", ascending: true).list {
//
//            chatdb?.messages.removeAll()
//            chatdb?.messages.append(objectsIn: sortmessages)
//          }
          
          
  //        let chatdb = roomidtodbconnect(rid: rid)
  //        chatdb?.messages.append(objectsIn: json)
//        }

        
      } catch {
        print(error)
      }

    }
  }
}
