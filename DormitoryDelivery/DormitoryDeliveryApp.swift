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
//            .environmentObject(User())
//            .environmentObject(StateLogin())
            .environmentObject(NaverLoginF())
//            .environmentObject(NaverToken())
            .onOpenURL(perform: { url in
              NaverThirdPartyLoginConnection
              .getSharedInstance()?
              .receiveAccessToken(url)
            })
        }
    }
}
