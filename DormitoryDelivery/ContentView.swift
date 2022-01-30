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
  @EnvironmentObject var roomdata: RoomData


  init() {
//    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    UITabBar.appearance().barTintColor = .white
    UITabBar.appearance().backgroundColor = .white
  }

    var body: some View {



      if !naverLogin.isLoggedIn {
        LoginView()
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)

      } else {
        ZStack {
          NavigationView{
            TabViews()
          }
          .onAppear {
//            naverLogin.loginInstance?.requestThirdPartyLogin()
            datecheck.startAction()
            if let token  = naverLogin.loginInstance?.accessToken {
              SocketIOManager.shared.establishConnection(token: token, roomdata: roomdata)
            }
          }
//          if !((naverLogin.loginInstance?.isValidAccessTokenExpireTimeNow()) != nil) {
////          if true {
//            Rectangle()
//              .fill(Color.black.opacity(0.4))
//              .ignoresSafeArea(.all)
//              .edgesIgnoringSafeArea(.all)
//              .onAppear {
//                naverLogin.loginInstance?.requestAccessTokenWithRefreshToken()
//              }
//          }
        }//z
        .onChange(of: naverLogin.refreshed) { rtoken in
          if let token = rtoken {
            SocketIOManager.shared.establishConnection(token: token, roomdata: roomdata)
          }
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
