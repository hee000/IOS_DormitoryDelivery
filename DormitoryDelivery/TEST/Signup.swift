//
//  Signup.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI

struct Signup: View {
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

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        Signup()
    }
}
