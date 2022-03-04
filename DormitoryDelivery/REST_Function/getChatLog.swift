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
  let index = idx + 1
  let url = urlchatlog(rid: rid, idx: String(index))
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    do {
//      let result = response.value as! [Any]
//      let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
//      let json = try JSONDecoder().decode([ChatMessageDetail].self, from: message)
      guard let data = response.data else { return }
      guard let json = try? JSONDecoder().decode([ChatMessageDetail].self, from: data) else { return }
        
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
          guard !(chatdb?.messages.contains(chat))! else {
            print("이미 있음")
            continue
          }
          print("저장함")
          chatdb?.messages.append(chat)
        }
        
        
//        let chatdb = roomidtodbconnect(rid: rid)
//        chatdb?.messages.append(objectsIn: json)
      }

      
    } catch {
      print(error)
    }

  }
}
