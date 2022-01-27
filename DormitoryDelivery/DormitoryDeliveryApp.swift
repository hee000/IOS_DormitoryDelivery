//
//  DormitoryDeliveryApp.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import UIKit
import NaverThirdPartyLogin

@main
struct DormitoryDeliveryApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  

    var body: some Scene {
        WindowGroup {
          ContentView()
            .environmentObject(NaverLogin())
            .environmentObject(DateCheck())
            .environmentObject(RoomData())
            .environmentObject(RoomDetailData())
            .environmentObject(ChatData())
            .environmentObject(KeyboardManager())
            .environmentObject(Order())
            .environmentObject(OrderList())
            .onOpenURL(perform: { url in
              NaverThirdPartyLoginConnection
              .getSharedInstance()?
              .receiveAccessToken(url)
            })
        }
    }
}
