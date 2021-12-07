//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func createRoom(shopName: String, shopLink: String, category: String, section: String, deliveryPriceAtLeast: Int, token: String) -> String{
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
      print("방 생성 성공")
//      print(value)
      print("=======")
      do {
        let data2 = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//        let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
        
//        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) as? [String: Any]
        var dic = try JSONSerialization.jsonObject(with: data2, options: [])
        print(dic)
//        print(type(of: dic))
      } catch {
        print(error)
      }

    case .failure(let error):
        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    }
  }
  return "asd"
}
