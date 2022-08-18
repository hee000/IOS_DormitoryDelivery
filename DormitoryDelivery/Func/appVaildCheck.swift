//
//  appVaildCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/08/08.
//

import Foundation
import SwiftUI
import Alamofire

func appVaildCheck(res: AFDataResponse<Any>) {
  print(res)
  guard let statusCode = res.response?.statusCode else { return }
  print(statusCode)
  if statusCode == 410 {
    UserDefaults.standard.set(true, forKey: "appVersionVaild")
  }
  
  if statusCode == 400 || statusCode == 409 {
    guard let error = res.value as? [String: Any],
          let errorMessages = error["message"] as? [String]
    else { return }
    
    let restErrorMessage = errorMessages.reduce(""){
      if $0 == "" {
        return $1
      } else {
        return $0 + "\n" + $1
      }
    }
    
    UserDefaults.standard.set(restErrorMessage, forKey: "restErrorMessage")
    
    withAnimation {
      UserDefaults.standard.set(true, forKey: "restError")
    }
  }// 400 or 409
}