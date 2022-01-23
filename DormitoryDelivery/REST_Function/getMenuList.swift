//
//  getMenuList.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire

func getMenuList(rid: String, token: String) {
  let url = urlmenulist(rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
    let result = response.value as! [String: Any]
    print(result)
  }
}
