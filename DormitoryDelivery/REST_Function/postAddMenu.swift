//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire
import RealmSwift

func postAddMenu(oderdata: orderdata, rid: String, token: String){
  print("방만들기 시도")
  let addkey = addmenu(name: oderdata.name, quantity: oderdata.quantity, description: oderdata.description, price: oderdata.price!)
  let url = urladdmenu(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid)
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(addkey)
  } catch {
      print("http Body Error")
  }
  
  AF.request(request).responseString { response in
    switch response.result {
    case .success(let value):
      print(value)
      let realm = try! Realm()
      let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
      try! realm.write {
        db?.menu.append(value)
      }
    case .failure(let error):
      print(error)
    }
  }
  
}
