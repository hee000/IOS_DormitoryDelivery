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
import JWTDecode
import RealmSwift

class NaverLogin: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  @Published var oauthLogin: Bool = UserDefaults.standard.bool(forKey: "oauthLogin") {
      didSet {
          UserDefaults.standard.set(oauthLogin, forKey: "oauthLogin")
      }
  }
  
  @Published var Login: Bool = UserDefaults.standard.bool(forKey: "Login") {
      didSet {
          UserDefaults.standard.set(Login, forKey: "Login")
      }
  }
    
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
//      getInfo()
    
    let url2 = urlsession()
    let token2 = loginInstance!.accessToken!
    let createkey2 = authsession(type: "naver", accessToken: loginInstance!.accessToken!, deviceToken: TokenUtils().readDevice() ?? "")

    guard let param2 = try? createkey2.asDictionary() else { return }
    
    AF.request(url2, method: .post,
               parameters: param2,
               encoding: JSONEncoding.default
    ).responseJSON { response2 in
      print(response2)
        if response2.response?.statusCode == 201 {
          guard let restdata = try? JSONDecoder().decode(tokenvalue.self, from: response2.data!) else { return }
          
          let tk = TokenUtils()
          tk.create(token: restdata)
          guard let token = tk.read(),
                let jwt = try? decode(jwt: token),
                let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
                let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
          
          let user = UserPrivacy()
          user.id = jwtdata.id
          user.name = jwtdata.name
          user.belong = jwtdata.univId
          
          let realm = try! Realm()
          try? realm.write {
              realm.add(user)
          }
          self.Login = true
          self.oauthLogin = true
        } else {
          self.oauthLogin = true
        }
      }
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//    self.refreshed = loginInstance?.accessToken
    print("리프레시 성공")
    print(loginInstance?.accessToken)
  }
  
  
  // 회원탈퇴
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out // 회원탈퇴")
    logoutuserdelete()
    self.oauthLogin = false
    self.Login = false
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
      
//      let user = UserPrivacy()
//      user._id = id
//      user.name = name
//      user.belong = "한경대학교"
//      adduser(user)
    }
  }

}
