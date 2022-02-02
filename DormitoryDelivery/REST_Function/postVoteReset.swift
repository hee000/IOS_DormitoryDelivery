//
//  postVoteReset.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire


func postVoteReset(rid: String, token: String){
  let url = urlvotereset(rid: rid)
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  
  AF.request(request).responseString { response in
    print(response)
  }
  
}
