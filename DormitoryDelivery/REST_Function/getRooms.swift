//
//  getRooms.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/03.
//

import Foundation
import Alamofire
import RealmSwift

func getRooms(uid: String, token: String) {
  let url = urlrooms(uid: uid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
    print(response)
    do {
      switch response.result {
      case .success(let value):
        if response.response?.statusCode == 200 {
          let result = value as! [Any]
            let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let json = try JSONDecoder().decode([rooms].self, from: message)
              print(json)
        }
      case .failure(let error):
        print(error)
      }
            

      
    } catch {
      print(error)
    }

  }
}

struct rooms: Codable{
  var id: String;
  var purchaserId: String
  var shopName: String;
  var state: Int;
  var role: String;
  var isReady: Bool;
}
