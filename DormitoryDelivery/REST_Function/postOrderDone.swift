//
//  postOrderDone.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire


func postOrderDone(rid: String) {
  restApiQueue.async {

    let url = urloderdone(rid: rid)
    
    AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseJSON { response in
      appVaildCheck(res: response)
      print(response)
    }
  }
  
}
