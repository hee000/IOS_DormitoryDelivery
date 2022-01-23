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



      if !naverLogin.isLoggedIn {
        LoginView()
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)

      } else {
//        NavigationView{
//          NavigationLink(destination: naviTEXT()){
//            Text("테스트")
//          }
//        }
        NavigationView{
          TabViews()
        }
            .onAppear {
              datecheck.startAction()
            }
      }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//
//  ContentView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//
//
//import SwiftUI
//
//struct ContentView: View {
//  @EnvironmentObject var naverLogin: NaverLogin
//  @EnvironmentObject var datecheck: DateCheck
//
//
//  init() {
//    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
//  }
//
//    var body: some View {
//
//
//    Chat()
//
//
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
