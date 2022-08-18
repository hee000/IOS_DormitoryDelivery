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
    let index = idx + 1
    let url = urlchatlog(rid: rid, idx: String(index))
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    req.responseJSON { response in
      do {
  //      let result = response.value as! [Any]
  //      let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
  //      let json = try JSONDecoder().decode([ChatMessageDetail].self, from: message)

        print(response)
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
        guard let json = try? JSONDecoder().decode([ChatMessageDetail].self, from: data) else { return }
        
        print(json)
        let realm = try! Realm()
        try! realm.write {
  //        for chatdetail in json {
  //          if chatdetail.type == "system" {
  //            print("시스템이래")
  //          }
  //          let chatdb = roomidtodbconnect(rid: rid)
  //          chatdb?.messages.append(<#T##object: ChatMessageDetail##ChatMessageDetail#>)
  //        }
          let chatdb = roomidtodbconnect(rid: rid)
          realm.add(json, update: .modified)
          
          for chat in json {
            guard !((chatdb?.messages.contains(chat)) ?? false) else {
  //            print("이미 있음")
              continue
            }
  //          print("저장함")
            chatdb?.messages.append(chat)
            if chat.type == "chat" {
              chatdb?.sortforat = Int(chat.at!)!
            }
          }
          
          if let last = chatdb?.messages.filter("type == 'chat'").last?.at {
            chatdb?.sortforat = Int(last)!
          }
          

        
          if let sortmessages = chatdb?.messages.sorted(byKeyPath: "idx", ascending: true).list {
            
            chatdb?.messages.removeAll()
            chatdb?.messages.append(objectsIn: sortmessages)
          }
          
          
  //        let chatdb = roomidtodbconnect(rid: rid)
  //        chatdb?.messages.append(objectsIn: json)
        }

        
      } catch {
        print(error)
      }

    }
  }
}
