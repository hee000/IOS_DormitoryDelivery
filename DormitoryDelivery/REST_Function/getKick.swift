//
//  getKick.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire
//import RealmSwift

func getKick(rid: String, uid: String, token: String) {
  let url = urlkick(rid: rid, uid: uid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
    
    print(response)
  }
}
