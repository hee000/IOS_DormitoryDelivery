//
//  postOderFix.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire


func postOderFix(rid: String){
  restApiQueue.async {
    let url = urloderfix(rid: rid)
    
    AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseJSON { response in
      print(response)
      appVaildCheck(res: response)
    }
  }
  
}
