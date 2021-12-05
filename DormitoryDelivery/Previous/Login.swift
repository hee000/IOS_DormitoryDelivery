//
//  Login.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import Alamofire

struct Login: View {
  @ObservedObject var user: User
  @State var userId: String = ""
  @State var userPassword: String = ""
  @ObservedObject var uersd: _UserSession = _UserSession()
  

    var body: some View {
      NavigationView {
        VStack{
          
          TextField("ID", text: $userId)
          TextField("Password", text: $userPassword)
          
          Button(action: {
            self.user.isLoggedIn = true
            
            let url = "http://192.168.0.20:3010/auth/login"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
            
            // POST 로 보낼 정보
            let params = ["userId":"qwer", "password":"qwer"] as Dictionary

            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
            } catch {
                print("http Body Error")
            }
      
            AF.request(request).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print("POST 성공")
                  print(value)
                  print("=======")
      
                  do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    
                    let session = try JSONDecoder().decode(UserSession.self, from: data)
  //                  session.sessionId
                    uersd.sessionId = "{token : "+session.sessionId+"}"
                    uersd.sessionId2 = session.sessionId
  //                  uersd.sessionId = session.sessionId
                  }
                  catch {
                    
                  }
                  print(uersd.sessionId2)
                
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
          }) {
            Text("로그인")
          }
          
          NavigationLink(destination: Signup()) { Text("회원가입") }

        }
      }
    }
}

//struct Login_Previews: PreviewProvider {
//    static var previews: some View {
//      Login(user: User)
//    }
//}Z
