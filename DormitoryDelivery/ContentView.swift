//
//  ContentView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var datecheck: DateCheck
  
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
  }

    var body: some View {

      
//      if !naverLogin.isLoggedIn {
//        LoginView()
//          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//          .edgesIgnoringSafeArea(.all)
//
//      } else {
//                if datecheck.startAction() { }
//
//                if naverLogin.loginInstance!.isValidAccessTokenExpireTimeNow() {
//                  Signup()
//                } else {
//                  Loading()
//                    .onAppear {
//                      naverLogin.loginInstance?.requestAccessTokenWithRefreshToken()
//                  }
//                }
//      }
      
      
      if !naverLogin.isLoggedIn {
        LoginView()
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)

      } else {
                  TabViews()
                    .onAppear {
                      datecheck.startAction()
                    }
//        if naverLogin.loginInstance!.isValidAccessTokenExpireTimeNow() {
//          TabViews()
//            .onAppear {
//              datecheck.startAction()
//            }
//        } else {
//          Loading()
//            .onAppear {
//              naverLogin.loginInstance?.requestAccessTokenWithRefreshToken()
//          }
//        }
      }
      

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
