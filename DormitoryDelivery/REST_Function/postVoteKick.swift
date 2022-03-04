//
//  postVoteKick.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import Foundation
import Alamofire


func postVoteKick(rid: String, uid: String){
  let url = urlvotekick(rid: rid, uid: uid)
  
  AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseString { response in
    print(response)
  }
  
}
