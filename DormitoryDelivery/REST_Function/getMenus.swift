//
//  getMenus.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire

func getMenus(uid: String, rid: String, mid: String, token: String, model: Order) {
  let url = urlmenus(uid: uid, rid: rid, mid: mid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
//    let result = response.value as! [String: Any]
    
    
    do {
      let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
      var session = try JSONDecoder().decode(orderdata.self, from: data2)
//        detaildata.data = session
//      print(session)
      session.id = mid
        model.data.append(session)
        model.forcompare.append(session)
//      print(model.data)
      }
    catch {
      print(error)
    }
  }
}