//
//  PostMenuDelete.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/24.
//

import Foundation
import Alamofire
import SwiftUI

func postMenuDelete(model:Order, index: Int, oderdata: orderdata, rid: String, token: String, anima: Binding<Bool>){

  let url = urldeletemenu(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: rid, mid: oderdata.id)
  var request = URLRequest(url: url)
  request.httpMethod = "Delete"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
//  do {
//      try request.httpBody = JSONEncoder().encode(addkey)
//  } catch {
//      print("http Body Error")
//  }
  
  AF.request(request).responseJSON { response in
    print(response)
    if response.response?.statusCode == 200 {
      for (index, comparedata) in model.forcompare.enumerated() {
        if comparedata.id == oderdata.id {
          model.forcompare.remove(at: index)
//          anima.wrappedValue.toggle()
          model.data.remove(at: index)
          break
        }
      }
    }
  }
  
}
