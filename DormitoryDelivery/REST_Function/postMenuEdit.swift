//
//  postMenuEdit.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire
import RealmSwift

func postMenuEdit(oderdata: orderdata, rid: String){

  let addkey = addmenu(name: oderdata.name, quantity: oderdata.quantity, description: oderdata.description, price: oderdata.price!)
  let url = urlmenus(uid: UserData().data.id!, rid: rid, mid: oderdata.id)
  
  
  guard let param = try? addkey.asDictionary() else { return }
  AF.request(url, method: .put,
             parameters: param,
             encoding: JSONEncoding.default,
             headers: TokenUtils().getAuthorizationHeader()
  ).responseString { response in
    print(response)
  }
  
}
