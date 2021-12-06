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


class NaverLogin: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  @Published var isValidAccessToken: Bool = false

  @Published var AToken: String = UserDefaults.standard.object(forKey: "AccessToken") as? String ?? "empty"{
    didSet {
        UserDefaults.standard.set(AToken, forKey: "AccessToken")
    }
  }
    
  @Published var RToken: String = UserDefaults.standard.object(forKey: "RefreshToken") as? String ?? "empty"{
    didSet {
        UserDefaults.standard.set(RToken, forKey: "RefreshToken")
    }
  }
  
  @Published var isLoggedIn: Bool = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false {
      didSet {
          UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
      }
  }
    
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
//      getInfo()
      self.AToken = loginInstance?.accessToken ?? ""
      self.isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() ?? false
      self.isLoggedIn = true
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    self.AToken = loginInstance?.accessToken ?? ""
//    print("리프레시 성공")
//    print(loginInstance?.isValidAccessTokenExpireTimeNow())
  }
  
  // 로그아웃
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out")
    self.isLoggedIn = false
  }
  
  // 모든 error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
      print("error = \(error.localizedDescription)")
  }
  
  func validcheck(){
    self.isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() ?? false
  }
  
  func tokenrefresh() {
    loginInstance?.delegate = self
    loginInstance?.requestAccessTokenWithRefreshToken()
  }
  
  func logout(){
    loginInstance?.delegate = self
        loginInstance?.requestDeleteToken()
  }
  
  func login(){
    print("로그인 시도중")
    loginInstance?.delegate = self
    loginInstance?.requestThirdPartyLogin()
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
