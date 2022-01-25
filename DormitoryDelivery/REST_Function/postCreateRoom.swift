//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func postCreateRoom(createRoomData: CreateRoom, section: String, deliveryPriceAtLeast: Int, token: String){
  print("방만들기 시도")
  let createkey = createroomdata(shopName: createRoomData.shopName, shopLink: createRoomData.shopLink, category: createRoomData.category, section: section, deliveryPriceAtLeast: deliveryPriceAtLeast)
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
            chatroomopen.superid = UserDefaults.standard.string(forKey: "MyID")!
            chatroomopen.title = createRoomData.shopName
            let userinfo = ChatUsersInfo()
            userinfo.id = UserDefaults.standard.string(forKey: "MyID")!
            userinfo.name = UserDefaults.standard.string(forKey: "MyID")!
            chatroomopen.member.append(userinfo)
            addChatting(chatroomopen)
            createRoomData.rid = rid
          }
        }
      }

    case .failure(let error):
        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    }
  }
}
