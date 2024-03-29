//
//  getReady.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire
import RealmSwift

func getReady(rid: String, model: ChatDB) {
  let url = urlready(uid: UserData().data!.id!, rid: rid, state: model.ready)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  
  req.responseJSON { response in
    appVaildCheck(res: response)
//    print("@@@@@", response.response?.statusCode)
//    print(response)
    if response.response?.statusCode == 200 {
      getRoomUpdate(rid: rid)
    }
//    let realm = try! Realm()
//    try! realm.write({
//      if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
//        db.ready.toggle()
//      }
////      model.ready.toggle()
//    })
//    print(response)

  }
}
