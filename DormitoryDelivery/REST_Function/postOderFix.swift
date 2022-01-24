//
//  postOderFix.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire


func postOderFix(rid: String, token: String){
  let url = urloderfix(rid: rid)
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  
  AF.request(request).responseString { response in
    print(response)
  }
  
}
