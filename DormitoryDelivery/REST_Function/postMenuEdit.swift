//
//  postMenuEdit.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire
import RealmSwift

func postMenuEdit(oderdata: tetemenussss, rid: String, token: String){

  let addkey = addmenu(name: oderdata.name, quantity: oderdata.quantity, description: oderdata.description, price: oderdata.price!)
  let url = urlmenus(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid, mid: oderdata.id!)
  var request = URLRequest(url: url)
  request.httpMethod = "PUT"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(addkey)
  } catch {
      print("http Body Error")
  }
  
  AF.request(request).responseString { response in
    print(response)
  }
  
}
