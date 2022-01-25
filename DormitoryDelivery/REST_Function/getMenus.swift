//
//  getMenus.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire

func getMenus(uid: String, rid: String, mid: String, token: String, model: tete244) {
  let url = urlmenus(uid: uid, rid: rid, mid: mid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
//    let result = response.value as! [Any]
//    print(response.value)
    
    
    do {
      let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
      let session = try JSONDecoder().decode(tetemenussss.self, from: data2)
//        detaildata.data = session
//      print(session)
        model.data.append(session)
//      print(model.data)
      }
    catch {
      print(error)
    }
  }
}
