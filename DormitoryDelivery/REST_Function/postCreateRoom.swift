//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func postCreateRoom(shopName: String, shopLink: String, category: String, section: String, deliveryPriceAtLeast: Int, token: String){
  print("방만들기 시도")
  let createkey = createroomdata(shopName: shopName, shopLink: shopLink, category: category, section: section, deliveryPriceAtLeast: deliveryPriceAtLeast)
  let url = createroomposturl
  var request = URLRequest(url: URL(string: url)!)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(createkey)
  } catch {
      print("http Body Error")
  }
  
  AF.request(request).responseJSON { (response) in
    switch response.result {
    case .success(let value):
//      print("방 생성 성공")
//      print(value)
//      print("=======")
      if let id = value as? [String: Any] {
        if let idvalue = id["id"] {
          let chatroomopen = ChatDB()
          if let rid = idvalue as? String {
            chatroomopen.rid = rid
            chatroomopen.title = shopName
            addChatting(chatroomopen)
          }
        }
      }

    case .failure(let error):
        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    }
  }
}
