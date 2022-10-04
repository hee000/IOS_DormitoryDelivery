//
//  DormitoryDeliveryApp.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import UIKit
import NaverThirdPartyLogin
import Alamofire

@main
struct DormitoryDeliveryApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @AppStorage("appVersionVaild") var appVersionVaild: Bool = UserDefaults.standard.bool(forKey: "appVersionVaild")

  init (){
    UserDefaults.standard.removeObject(forKey: "OauthProvider")
    UserDefaults.standard.register(defaults: ["OauthProvider" : "None"])
    UserDefaults.standard.removeObject(forKey: "restError")
    UserDefaults.standard.register(defaults: ["restError" : false])
    UserDefaults.standard.removeObject(forKey: "restErrorMessage")
    UserDefaults.standard.register(defaults: ["restErrorMessage" : ""])
  }
  
  
    var body: some Scene {
        WindowGroup {
            
          ContentView()
            .overlay(self.appVersionVaild ? AlertOneButton(isActivity: $appVersionVaild) { Text("앱 업데이트가 필요합니다.").font(.system(size: 16, weight: .regular)) }.onDisappear{
              
              let url = "itms-apps://itunes.apple.com/app/1618195217"
              if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                  if #available(iOS 10.0, *) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                  } else {
                      UIApplication.shared.openURL(url)
                  }
              }
              
                  UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                      exit(0)
                  }
            } : nil)
            .environmentObject(NaverLogin())
            .environmentObject(DateCheck())
            .environmentObject(RoomData())
            .environmentObject(dormitoryData())
            .environmentObject(ChatData())
            .environmentObject(ChatNavi())
            .environmentObject(KeyboardManager())
            .environmentObject(Order())
            .environmentObject(Noti())
            .environmentObject(OrderList())
            .environmentObject(AppleToken())
            .onOpenURL(perform: { url in
              NaverThirdPartyLoginConnection
              .getSharedInstance()?
              .receiveAccessToken(url)
            })
            .onAppear {
              NetworkMonitor.shared.startMonitoring()
//              UserDefaults.standard.removeObject(forKey: "OauthProvider")
            }
        }
    }
}
