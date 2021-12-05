//
//  NaverLoginFunc.swift.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/04.
//

import SwiftUI
import UIKit
import NaverThirdPartyLogin
import Alamofire

class NaverToken: ObservableObject{
  @Published var RToken: String {
    didSet {
        UserDefaults.standard.set(RToken, forKey: "RefreshToken")
    }
  }
  

  init() {
    self.RToken = UserDefaults.standard.object(forKey: "RefreshToken") as? String ?? ""
  }
}


class NaverLoginF: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
//  loginInstance?.delegate = self
  @Published var IsLogin: Bool = false
  @Published var IsValidAccessToken: Bool = false
//  @EnvironmentObject var naverToken: NaverToken

  @Published var AToken: String = UserDefaults.standard.object(forKey: "AccessToken") as? String ?? "ddddddd"{
    didSet {
        UserDefaults.standard.set(AToken, forKey: "AccessToken")
    }
  }
    
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
//      getInfo()
      self.AToken = loginInstance?.accessToken ?? ""
      self.IsValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() ?? false
      self.IsLogin = true
    print(UserDefaults.standard.string(forKey: "AccessToken")!)
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//      loginInstance?.accessToken
  }
  
  // 로그아웃
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out")
    self.IsLogin = false
  }
  
  // 모든 error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
      print("error = \(error.localizedDescription)")
  }
  
  func isValidAccessToken() -> Bool{
//    print(self.AToken)
//    self.IsValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() ?? false
//    print("isValidAccessToken 검사")
//    print(self.IsValidAccessToken)
//    print(self.AToken)
    return false
  }
  
  func postRefreshToken() {
    // 리프레스 토큰 갱신 코드
  }
  
  func logout(){
    loginInstance?.delegate = self
        loginInstance?.requestDeleteToken()
  }
  func login(){
    print("로그인 시도중")
    loginInstance?.delegate = self
//    func login() {
//    print("onClickButton");
//    loginInstance?.delegate = self
//       print(test.login)
//       test.login = "99999999999993"
//       print(test.login)
//    print(self.AToken)
    loginInstance?.requestThirdPartyLogin()

//    print(loginInstance?.accessToken ?? "없대")
//    self.NaverToken. =  loginInstance?.loginInstance?.accessToken else { return }
    
//    loginInstance?.requestDeleteToken()
//          loginInstance?.requestDeleteToken()

//    let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow()

//      return isValidAccessToken
  }
  
  func getInfo() {
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    print("========")
    print(isValidAccessToken)
    print("========")
    if !isValidAccessToken {
      return
    }
    
    guard let refreshToken = loginInstance?.refreshToken else { return }
    guard let tokenType = loginInstance?.tokenType else { return }
    guard let accessToken = loginInstance?.accessToken else { return }
      
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    
    print("================================")
//    print(tokenType)
    print(refreshToken)
//    print(accessToken)
    print("================================")
    
    let authorization = "\(tokenType) \(accessToken)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    
    req.responseJSON { response in
      guard let result = response.value as? [String: Any] else { return }
      guard let object = result["response"] as? [String: Any] else { return }
//      guard let name = object["name"] as? String else { return }
//      guard let email = object["email"] as? String else { return }
//      guard let id = object["id"] as? String else {return}
      
      print(object)
      
//      self.nameLabel.text = "\(name)"
//      self.emailLabel.text = "\(email)"
//      self.id.text = "\(id)"
    }
  }
  
}
