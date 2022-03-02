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

      ZStack{
        VStack(alignment: .center) {

          Image("ImageSplashLogo_V")
            .resizable()
            .scaledToFit()
            .frame(width: 66, height: 264)

          
          VStack{
            Text("간편하게 로그인하고")
              .bold()
            Text("필요한 것들을 1/n하세요!")
              .bold()
          }
          .foregroundColor(Color(.sRGB, red: 197/255, green: 197/255, blue: 197/255, opacity: 1))
          .font(.system(size: 16))
          .padding(.top, 20)
        }
        
        VStack{
          Spacer()
//          Button {
//            naverLogin.logout()
//          } label: {
//            Text("로그아웃")
//          }
//          .padding()
//          .padding()
          
        } //v
        Button {
          naverLogin.login()
        } label: {
         Image("naverloginbutton")
            .resizable()
            .scaledToFit()
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
        .offset(y: UIScreen.main.bounds.height * 8/10 / 2)

      } //z

  
    }
}


struct NaverLogin_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

