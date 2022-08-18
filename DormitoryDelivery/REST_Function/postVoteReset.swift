//
//  postVoteReset.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire


func postVoteReset(rid: String) {
  restApiQueue.async {

    let url = urlvotereset(rid: rid)
    
    AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseString { response in
      print(response)
    }
  }
  
}
