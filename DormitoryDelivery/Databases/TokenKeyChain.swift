//
//  TokenKeyChain.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/03/04.
//

import Foundation
import Security
import Alamofire
import JWTDecode


extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}


class TokenUtils {
  private let account = "TokenService"
  private let service = Bundle.main.bundleIdentifier
  
  func createDevice(token: String) {
    // 1. query작성
    let keyChainQuery: NSDictionary = [
        kSecClass : kSecClassGenericPassword,
        kSecAttrService: "deviceTokenService",
        kSecAttrAccount: "deviceToken",
        kSecValueData: token.data(using: .utf8, allowLossyConversion: false)!
    ]
    
    SecItemDelete(keyChainQuery)
    
    let status: OSStatus = SecItemAdd(keyChainQuery, nil)
    assert(status == noErr, "failed to saving Token")
  }

  func readDevice() -> String? {
      let KeyChainQuery: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrService: "deviceTokenService",
          kSecAttrAccount: "deviceToken",
          kSecReturnData: kCFBooleanTrue, // CFData타입으로 불러오라는 의미
          kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져오라는 의미
      ]
      // CFData 타입 -> AnyObject로 받고, Data로 타입변환해서 사용하면됨
      
      // Read
      var dataTypeRef: AnyObject?
      let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)
      
      // Read 성공 및 실패한 경우
      if(status == errSecSuccess) {
          let retrievedData = dataTypeRef as! Data
          let value = String(data: retrievedData, encoding: String.Encoding.utf8)
          return value
      } else {
          print("failed to loading, status code = \(status)")
          return nil
      }
  }

  
  func create(token: tokenvalue) {
    guard let value = try? JSONEncoder().encode(token) else { return }
    // 1. query작성
    let keyChainQuery: NSDictionary = [
        kSecClass : kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecValueData: value
    ]
    
    SecItemDelete(keyChainQuery)
    
    let status: OSStatus = SecItemAdd(keyChainQuery, nil)
    assert(status == noErr, "failed to saving Token")
  }

  func read() -> String? {
    let KeyChainQuery: NSDictionary = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecReturnData: kCFBooleanTrue, // CFData타입으로 불러오라는 의미
        kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우 하나의 값만 가져오라는 의미
    ]

    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)
    
    if(status == errSecSuccess) {
        let retrievedData = dataTypeRef as! Data
        guard let token = try? JSONDecoder().decode(tokenvalue.self, from: retrievedData) else { return nil}

        let jwt = try! decode(jwt: token.accessToken)
      
        if jwt.expiresAt!.timeIntervalSince(Date()) < 0 {
          guard let para = try? token.asDictionary() else { return ""}
          let req = AF.request(urlsession(), method: .patch, parameters: para, encoding: JSONEncoding.default)
          
          let semaphore = DispatchSemaphore(value: 1)
          var returnValue = ""
          semaphore.wait()
          req.responseJSON(queue: .global()) { response in
            if response.response?.statusCode == 200 {
              guard let json = response.data else { return }
              guard let newtoken = try? JSONDecoder().decode(tokenvalue.self, from: json) else { return }
              self.create(token: newtoken)
              returnValue = newtoken.accessToken
              semaphore.signal()
            }
          }
          semaphore.wait()
          semaphore.signal()
          return returnValue
        } else {
          return token.accessToken
        }
    } else {
        print("failed to loading, status code = \(status)")
        return nil
    }
  }
      
      // Delete
  func delete(_ service: String, account: String) {
    let keyChainQuery: NSDictionary = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account
    ]
    
    let status = SecItemDelete(keyChainQuery)
    assert(status == noErr, "failed to delete the value, status code = \(status)")
  }

  
  func getAuthorizationHeader() -> HTTPHeaders? {
      if let accessToken = self.read() {
          return ["Authorization" : "bearer \(accessToken)"] as HTTPHeaders
      } else {
          return nil
      }
  }
}
