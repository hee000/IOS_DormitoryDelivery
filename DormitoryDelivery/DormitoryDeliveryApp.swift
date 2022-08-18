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

    var body: some Scene {
        WindowGroup {
            
          ContentView()
            .overlay(self.appVersionVaild ? AlertOneButton(isActivity: $appVersionVaild) { Text("앱 업데이트가 필요합니다.").font(.system(size: 16, weight: .regular)) }.onDisappear{
                  UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
            .onOpenURL(perform: { url in
              NaverThirdPartyLoginConnection
              .getSharedInstance()?
              .receiveAccessToken(url)
            })
            .onAppear {
              NetworkMonitor.shared.startMonitoring()
            }
        }
    }
}
