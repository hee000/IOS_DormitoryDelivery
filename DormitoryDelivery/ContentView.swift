//
//  ContentView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI

struct ContentView: View {
//  @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey:"isLoggedIn")
//  @StateObject var user = User()
  @EnvironmentObject var naverLogin: NaverLoginF

  init() {
    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
  }
  
//  @EnvironmentObject var naverToken: NaverToken
    var body: some View {
//      logintest()
//      VStack{
//        SwiftUIView2()
//        SwiftUIView()
//        SwiftUIView2().background(Color.red)
//      }
      
      if !naverLogin.IsLogin {
        NaverLogin()
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)

      } else {
        
        if naverLogin.IsValidAccessToken {
          TabViews()
        } else {
          Loading()
            .onAppear {
            naverLogin.postRefreshToken()
          }
        }
      }
      
//      Join(Id_room: 16)
      
//      if user.isLoggedIn {
//        TabViews(user: user)
//      } else {
//        Login(user: user)
//      }
      
//      TEST()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
