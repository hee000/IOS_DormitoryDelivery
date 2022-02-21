//
//  AppDelegate.swift
//  ukittest
//
//  Created by cch on 2021/11/04.
//

import UIKit
import NaverThirdPartyLogin


//@main
class AppDelegate: NSObject, UIApplicationDelegate {
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
      let instance = NaverThirdPartyLoginConnection.getSharedInstance()
      
      // 네이버 앱으로 인증하는 방식 활성화
      instance?.isNaverAppOauthEnable = true
      
      // SafariViewController에서 인증하는 방식 활성화
      instance?.isInAppOauthEnable = true
      
      // 인증 화면을 아이폰의 세로모드에서만 적용
      instance?.isOnlyPortraitSupportedInIphone()
      
      instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
      instance?.consumerKey = kConsumerKey // 상수 - client id
      instance?.consumerSecret = kConsumerSecret // pw
      instance?.appName = kServiceAppName // app name
      
      registerForRemoteNotifications()

        return true
    }
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      // 네이버
      NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
      
        return false
    }
  

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
  
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

  
  private func registerForRemoteNotifications() {

         // 1. 푸시 center (유저에게 권한 요청 용도)
         let center = UNUserNotificationCenter.current()
         center.delegate = self // push처리에 대한 delegate - UNUserNotificationCenterDelegate
         let options: UNAuthorizationOptions = [.alert, .sound, .badge]
         center.requestAuthorization(options: options) { (granted, error) in

           guard granted else {
                 return
             }

             DispatchQueue.main.async {
                 // 2. APNs에 디바이스 토큰 등록
                 UIApplication.shared.registerForRemoteNotifications()
             }
         }
     }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
      print(deviceTokenString)
  }
}



extension AppDelegate: UNUserNotificationCenterDelegate {

    // 앱이 foreground상태 일 때, 알림이 온 경우 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // 푸시가 오면 alert, badge, sound표시를 하라는 의미
      completionHandler([.banner, .list, .badge, .sound])
    }

    // push가 온 경우 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // deep link처리 시 아래 url값 가지고 처리
        let url = response.notification.request.content.userInfo
        print("url = \(url)")

        // if url.containts("receipt")...
    }
}

