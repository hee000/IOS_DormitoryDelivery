//
//  getReady.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire
import RealmSwift

func getReady(rid: String, token: String, model: ChatDB) {
  let url = urlready(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid, state: model.ready)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseString { response in

    let realm = try! Realm()
    try! realm.write({
      model.ready.toggle()
    })
    print(response)

  }
}
