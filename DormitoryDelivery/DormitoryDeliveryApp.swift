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
            .onAppear {
              NetworkMonitor.shared.startMonitoring()
            }
        }
    }
}


extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
