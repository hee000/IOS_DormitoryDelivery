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

enum LoginProviders: String {
  case none = "None"
  case naver = "naver"
  case apple = "apple"
}

class LoginSystem {
  func login(provider: String, payload: String) {
    let url = urlsession()
    let oauth = oauthInfo(provider: provider, payload: payload)
    let loginToken = loginToken(oauthInfo: oauth, deviceToken: TokenUtils().readDevice() ?? "")
    guard let parameter = try? loginToken.asDictionary() else { return }

    AF.request(url, method: .post,
               parameters: parameter,
               encoding: JSONEncoding.default, headers: httpAppVersion
    ).responseJSON { response in
      print(response)
      
        if response.response?.statusCode == 201 {
          guard let restdata = try? JSONDecoder().decode(tokenvalue.self, from: response.data!) else { return }
          
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
          user.provider = provider
          
          let realm = try! Realm()
          try? realm.write {
              realm.add(user)
          }

          self.setLogin(true)
          self.setOauthLogin(provider)
          
        } else {
          self.setOauthLogin(provider)
        }
      }
  }
  
  func logout() {
    print("applogout")
    self.setLogin(false)
    self.removeOauthLogin()
    logoutuserdelete()
  }
  
  func getLogin() -> Bool {
    return UserDefaults.standard.bool(forKey: "Login")
  }
  
  func getOauthLogin() -> String {
    return UserDefaults.standard.string(forKey: "OauthProvider") ?? ""
  }
  
  func setLogin(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: "Login")
  }
  
  func setOauthLogin(_ value: String) {
    UserDefaults.standard.set(value, forKey: "OauthProvider")
  }
  
  func removeOauthLogin() {
    UserDefaults.standard.removeObject(forKey: "OauthProvider")
  }
}


class NaverLogin: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
    
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
    
//    let url2 = urlsession()
    
    let payload = "{\"accessToken\": \"\(loginInstance!.accessToken!)\"}"
    
    LoginSystem().login(provider: LoginProviders.naver.rawValue, payload: payload)
    
//    let oauth = oauthInfo(provider: "naver", payload: payload)
    
//    let loginToken = loginToken(oauthInfo: oauth, deviceToken: TokenUtils().readDevice() ?? "")

//    guard let param2 = try? loginToken.asDictionary() else { return }
    
//    AF.request(url2, method: .post,
//               parameters: param2,
//               encoding: JSONEncoding.default, headers: httpAppVersion
//    ).responseJSON { response2 in
//      print(response2)
//
//        if response2.response?.statusCode == 201 {
//          guard let restdata = try? JSONDecoder().decode(tokenvalue.self, from: response2.data!) else { return }
//
//          let tk = TokenUtils()
//          tk.create(token: restdata)
//          guard let token = tk.read(),
//                let jwt = try? decode(jwt: token),
//                let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
//                let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
//
//          let user = UserPrivacy()
//          user.id = jwtdata.id
//          user.name = jwtdata.name
//          user.belong = jwtdata.univId
////          user.belongStr = "네이버 로그인 ㄱ"
//
//          let realm = try! Realm()
//          try? realm.write {
//              realm.add(user)
//          }
//
//          LoginSystem().setLogin(true)
//          LoginSystem().setOauthLogin("naver")
////          self.Login = true
////          self.oauthLogin = true
//        } else {
//          LoginSystem().setOauthLogin("naver")
////          self.oauthLogin = true
//        }
//      }
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//    self.refreshed = loginInstance?.accessToken
    print("리프레시 성공")
    print(loginInstance?.accessToken)
    LoginSystem().setOauthLogin("naver")
  }
  
  
  // 회원탈퇴
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out // 회원탈퇴")
    LoginSystem().logout()
//    logoutuserdelete()
//    LoginSystem().setLogin(false)
//    LoginSystem().removeOauthLogin()
    
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
      print(object)
//      UserDefaults.standard.set(id, forKey: "MyID")
//      UserDefaults.standard.set(name, forKey: "MyName")
      
//      let user = UserPrivacy()
//      user._id = id
//      user.name = name
//      user.belong = "한경대학교"
//      adduser(user)
    }
  }

}
