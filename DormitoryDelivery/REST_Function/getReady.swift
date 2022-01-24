//
//  getReady.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire

func getReady(rid: String, token: String) {
  let url = urlready(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseString { response in
//    let result = response.value as! [String: Any]
//    print(result)
    print(response)
//    print(type(of: response.value!))
//    print(response.description)
//    print(response.result)
//    print(response.data!)
//    print(response.)
  }
}
