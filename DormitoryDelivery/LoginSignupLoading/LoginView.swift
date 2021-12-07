//
//  NaverLogin.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/04.
//


import SwiftUI

struct LoginView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  
    var body: some View {


      Spacer()

      VStack {
        HStack {
          Text("1/n")
            .foregroundColor(Color(.sRGB, red: 197/255, green: 197/255, blue: 197/255, opacity: 1))
            .font(.system(size: 31))
        }
        Text("같이")
          .fontWeight(.black)
          .foregroundColor(Color(.sRGB, red: 113/255, green: 45/255, blue: 255/255, opacity: 1))
          .font(.system(size: 64))
        Text("하실")
          .fontWeight(.black)
          .foregroundColor(Color(.sRGB, red: 113/255, green: 45/255, blue: 255/255, opacity: 1))
          .font(.system(size: 64))
        
        Spacer()
          .frame(height: 15)
        
        Text("간편하게 로그인하고")
          .foregroundColor(Color(.sRGB, red: 197/255, green: 197/255, blue: 197/255, opacity: 1))
          .font(.system(size: 14))
        Text("필요한 것들을 1/n하세요!")
          .foregroundColor(Color(.sRGB, red: 197/255, green: 197/255, blue: 197/255, opacity: 1))
          .font(.system(size: 14))
//          .fontWeight(UIFont.Weight(400))
      }
      
      Spacer()
      
        Button {
          naverLogin.logout()
        } label: {
          Text("로그아웃")
        }

        Button {
          naverLogin.login()
        } label: {
         Image("naverloginbutton")
            .resizable()
            .scaledToFit()
        }
        .frame(width: 300, height: 50)

  
    }
}


struct NaverLogin_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

