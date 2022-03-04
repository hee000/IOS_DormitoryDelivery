//
//  postOderFix.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire


func postOderFix(rid: String){
  let url = urloderfix(rid: rid)
  
  AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseString { response in
    print(response)
  }
  
}
