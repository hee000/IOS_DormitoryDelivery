//
//  AppDelegate.swift
//  ukittest
//
//  Created by cch on 2021/11/04.
//

import UIKit
import NaverThirdPartyLogin
import Firebase
import UserNotifications
import FirebaseAnalytics
//#import <FirebaseCore/FIRApp.h>
//#import <Firebase.h>




//@main
class AppDelegate: NSObject, UIApplicationDelegate {
      let gcmMessageIDKey = "gcm.message_id"
      let aps = "aps"
      let data1Key = "DATA1"
      let data2Key = "DATA2"
  
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
      
//      registerForRemoteNotifications()
      
      FirebaseApp.configure()
      Messaging.messaging().delegate = self // MessagingDelegate
      UNUserNotificationCenter.current().delegate = self
//      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//      UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions,
//          completionHandler: {_, _ in })
      application.registerForRemoteNotifications()
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
//         Called when the user discards a scene session.
//         If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//         Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print("가져올 데이터가 있음을 나타내는 원격 알림이 도착했음을 앱에 알림")

      if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
      }
      print("userInfo : ", userInfo)
      completionHandler(UIBackgroundFetchResult.newData)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {  // UNUserNotificationCenterDelegate: 수신 알림 및 알림 관련 작업을 처리하기 위한 protocol(interface)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("앱이 포그라운드에서 실행되는 동안 도착한 알림을 처리하는 방법")
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let data1 = userInfo[data1Key] {
            print("data1: \(data1)")
        }
        
        if let data2 = userInfo[data2Key] {
            print("data2: \(data2)")
        }

        if let apsData = userInfo[aps] {
            print("apsData : \(apsData)")
        }
        // Change this to your preferred presentation option
//        completionHandler([[.banner, .badge, .sound]])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("앱이 APNS에 성공적으로 등록되었음을 대리자에게 알림")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS가 등록 프로세스를 성공적으로 완료할 수 없어서 대리인에게 전송되었음")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("전달된 알림에 대한 사용자의 응답을 처리하도록 대리인에게 요청합니다.")
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID from userNotificationCenter didReceive: \(messageID)")
        }
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("messaging")
//        let deviceToken:[String: String] = ["token": fcmToken ?? ""]
      TokenUtils().createDevice(token: fcmToken ?? "")
//        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
//      print("이건 키체인 토큰: ", TokenUtils().readDevice())
    }
}
