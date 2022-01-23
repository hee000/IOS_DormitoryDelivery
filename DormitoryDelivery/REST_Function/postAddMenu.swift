//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func postAddMenu(oderdata: Oder, rid: String, token: String){
  print("방만들기 시도")
  let addkey = addmenu(name: oderdata.name, quantity: Int(oderdata.quantity)!, description: oderdata.description, price: Int(oderdata.price)!)
  let url = urladdmenu(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid)
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(addkey)
  } catch {
      print("http Body Error")
  }
  
  AF.request(request).responseJSON { (response) in
    switch response.result {
    case .success(let value):
      print("메뉴츄가성공")

    case .failure(let error):
        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    }
  }
}
