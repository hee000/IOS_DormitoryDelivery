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
        NavigationView{
            TabViews()
                .onAppear{
              print(SocketIOManager.shared.socket.status)
            }
              
          }
          .onChange(of: SocketIOManager.shared.socket.status, perform: { newValue in
            print(newValue)
          })
          .onAppear {
            datecheck.startAction()
            if let token  = naverLogin.loginInstance?.accessToken {
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
