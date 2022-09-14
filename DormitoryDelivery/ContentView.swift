//
//  ContentView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import Alamofire
import JWTDecode
import SocketIO


struct ContentView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var datecheck: DateCheck
  @EnvironmentObject var roomdata: RoomData
  @EnvironmentObject var dormis: dormitoryData
  
  @AppStorage("Login") var Login: Bool = UserDefaults.standard.bool(forKey: "Login")
  
  static let defaultOauth = "None"
  @AppStorage("OauthProvider") var OauthProvider: String = Self.defaultOauth
  

  init() {
//    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    UITabBar.appearance().barTintColor = .white
    UITabBar.appearance().backgroundColor = .white
//    UINavigationBar.appearance().backgroundColor = .white
  }

    var body: some View {

      ZStack{
        if (!Login && OauthProvider == "None") {
          LoginView()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        } else if (!Login && (OauthProvider == LoginProviders.naver.rawValue || OauthProvider == LoginProviders.apple.rawValue)) {
          EmailCheckView()
//            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
//                  naverLogin.login()
//                    }
        } else {
          NavigationView{
            TabViews()
          }
          .navigationViewStyle(.stack) //navi
          .onAppear(perform: {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
          })
            
          .onAppear {
            datecheck.startAction()
            
            restApiQueue.async {

              let tk = TokenUtils()
              guard let token = tk.read(),
                    let jwt = try? decode(jwt: token),
                    let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
                    let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
              
              let req = AF.request(urluniversitydormitory(id: String(jwtdata.univId)), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())

              req.responseJSON { response in
                guard let code = response.response?.statusCode else { return }
                appVaildCheck(res: response)
    //            print(response)
                guard let json = response.data else { return }
                guard let restdata = try? JSONDecoder().decode([dormitory].self, from: json)
                else {
                  getUniversityDormitory(dormitoryId: String(jwtdata.univId), model: dormis)
                  return
                }
                print("asdasdsad")
                DispatchQueue.main.async {
                  dormis.data = restdata
                }
                SocketIOManager.shared.establishConnection(token: "Bearer \(token)", roomdata: roomdata, dormis: dormis)
              } // req
            }
            
          } //onappear
        } // main
        
      } // Z
      .overlay(ErrorAlertView())

      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
