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



class NaverLogin: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  @Published var isLoggedIn: Bool = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false {
      didSet {
          UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
      }
  }
  @Published var refreshed: String? = ""
    
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
      getInfo()
      self.isLoggedIn = true
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    self.refreshed = loginInstance?.accessToken
    print("리프레시 성공")
    print(loginInstance?.accessToken)
  }
  
  // 로그아웃
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out")
    logoutuserdelete()
    self.isLoggedIn = false
  }
  
  // 모든 error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
      print("error = \(error.localizedDescription)")
  }
  
  func getAccessToken() -> String? {
    if let accessToken = loginInstance?.accessToken {
      return accessToken
    }
    return "None"
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
    loginInstance?.delegate = self
    loginInstance?.requestThirdPartyLogin()
  }
  
  func getInfo() {
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    if !isValidAccessToken {
      return
    }
    
    guard let refreshToken = loginInstance?.refreshToken else { return }
    guard let tokenType = loginInstance?.tokenType else { return }
    guard let accessToken = loginInstance?.accessToken else { return }
      
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    
    let authorization = "\(tokenType) \(accessToken)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    

    req.responseJSON { response in
      guard let result = response.value as? [String: Any] else { return }
      guard let object = result["response"] as? [String: Any] else { return }
//      guard let email = object["email"] as? String else { return }
      guard let name = object["name"] as? String else { return }
      guard let id = object["id"] as? String else {return}
      UserDefaults.standard.set(id, forKey: "MyID")
      UserDefaults.standard.set(name, forKey: "MyName")
      
      let user = UserPrivacy()
      user._id = id
      user.name = name
      user.belong = "한경대학교"
      adduser(user)
    }
  }

}
