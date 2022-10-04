//
//  getKick.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire
//import RealmSwift

func getKick(rid: String, uid: String) {
  let url = urlkick(rid: rid, uid: uid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    appVaildCheck(res: response)
    print(response)
  }
}
