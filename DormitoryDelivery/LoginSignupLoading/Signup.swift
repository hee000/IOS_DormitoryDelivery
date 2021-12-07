//
//  Signup.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import Alamofire
import SocketIO


struct Signup: View {
  @EnvironmentObject var naverLogin: NaverLogin

  @State var signupId: String = ""
  @State var signupPassword: String = ""
  @State var signupEmail: String = ""
  @State var emailCheckButton: Bool = false
  @State var emailCheck: String = "4:30"
  
    var body: some View {
      Form {
        TextField("ID", text: $signupId)
        TextField("Password", text: $signupPassword)
        
        HStack {
          TextField("Email", text: $signupEmail)
          Text("@hknu.ac.kr")
          if emailCheckButton {
            Text(self.emailCheck)
              .foregroundColor(Color.red)
          } else {
            
            Button(action: {
              self.emailCheckButton = true
              if let mytoken = naverLogin.loginInstance?.accessToken {
                emailSend(email: self.signupEmail, token: mytoken)
              }
              
              
            }) {
              Text("인증")
            }
              .buttonStyle(BorderlessButtonStyle())
              .font(.system(size: 14))
              .foregroundColor(Color.white)
              .background(Color.blue)
              .cornerRadius(3.0)
          }
        }
        
        Button(action: {
        }) {
          Text("회원가입")
        }
      }
    }
}



func authCodeSend(code: String, token: String) {
  let createkey = authcodedata(authCode: code)
  let url = authcodesendurl
  var request = URLRequest(url: URL(string: url)!)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(createkey)
  } catch {
      print("http Body Error")
  }

  AF.request(request).responseJSON { (response) in
    switch response.result {
    case .success(let value):
      print("코드 보내기 실패? \(value)")
    case .failure(let error):
        print("코드 보내기 성공? \(error)")
    }
  }
}

func emailSend(email: String, token: String) {
  let createkey = emaildata(email: email+"@naver.com")
  let url = emailsendurl
  var request = URLRequest(url: URL(string: url)!)
  request.httpMethod = "POST"
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
  request.timeoutInterval = 10
  request.allHTTPHeaderFields = (["Authorization": token])
  
  do {
      try request.httpBody = JSONEncoder().encode(createkey)
  } catch {
      print("http Body Error")
  }

  AF.request(request).responseJSON { (response) in
    switch response.result {
    case .success(let value):
      print("이메일 보내기 실패 \(value)")


    case .failure(let error):
        print("이메일 보내기 성공 \(error)")
    }
  }
}

struct emaildata : Codable {
  var email: String
}

struct authcodedata : Codable {
  var authCode: String
}



struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
