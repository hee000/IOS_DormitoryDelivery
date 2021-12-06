////
////  JoinButton.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/12/06.
////
//
//import Foundation
//
//
//func JoinButton(){
//  let url = createroomposturl
//  let headers : [String: String] = [
//    "Authorization": UserDefaults.standard.string(forKey: "AccessToken")!
//  ] as Dictionary
//  var request = URLRequest(url: URL(string: url)!)
//  request.httpMethod = "POST"
//  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//  request.timeoutInterval = 10
//
//
//  do {
//    print("인코딩 시작")
//      try request.httpBody = JSONEncoder().encode(createform)
//      try request.allHTTPHeaderFields = headers
//    print("인코딩 성공")
//  } catch {
//      print("http Body Error")
//  }
//
//  AF.request(request).responseJSON { (response) in
//      switch response.result {
//      case .success(let value):
//          print("POST 성공")
//        print(value)
//        print("=======")
//
//      case .failure(let error):
//          print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
//      }
//  }
//}
