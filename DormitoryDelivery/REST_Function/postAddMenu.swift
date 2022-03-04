//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire
import RealmSwift

func postAddMenu(oderdata: orderdata, rid: String){
  print("방만들기 시도")
  let addkey = addmenu(name: oderdata.name, quantity: oderdata.quantity, description: oderdata.description, price: oderdata.price!)
  let url = urladdmenu(uid: UserData().data.id!, rid: rid)
  
  guard let param = try? addkey.asDictionary() else { return }
  AF.request(url, method: .post,
             parameters: param,
             encoding: JSONEncoding.default,
             headers: TokenUtils().getAuthorizationHeader()
  ).responseString { response in
    switch response.result {
    case .success(let value):
      print(value)
      let realm = try! Realm()
      let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
      try! realm.write {
//        db?.menu.insert(value, at: 0)
        db?.menu.append(value)
      }
    case .failure(let error):
      print(error)
    }
  }
  
}
