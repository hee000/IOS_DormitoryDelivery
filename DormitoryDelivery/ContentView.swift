//
//  ContentView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import Alamofire
import JWTDecode

struct ContentView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var datecheck: DateCheck
  @EnvironmentObject var roomdata: RoomData
  @EnvironmentObject var dormis: dormitoryData
  
  init() {
//    UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    UITabBar.appearance().barTintColor = .white
    UITabBar.appearance().backgroundColor = .white
//    UINavigationBar.appearance().backgroundColor = .white
  }

    var body: some View {


      if !naverLogin.oauthLogin {
        LoginView()
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
      } else if !naverLogin.Login {
        EmailCheckView()
          .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                naverLogin.login()
                  }
          .onAppear {
            naverLogin.login()
          }
      } else {
        NavigationView{
            TabViews()
                .onAppear{
              print(SocketIOManager.shared.socket.status)
            }

          }//navi
        .onAppear(perform: {
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: {_, _ in })
        })
        .environmentObject(UserData())
          .onChange(of: SocketIOManager.shared.socket.status, perform: { newValue in
            print(newValue)
          })
          .onAppear {
            
            datecheck.startAction()
            let tk = TokenUtils()
            guard let token = tk.read(),
                  let jwt = try? decode(jwt: token),
                  let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
                  let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
            
            let req = AF.request(urluniversitydormitory(id: String(jwtdata.univId)), method: .get, parameters: nil, encoding: JSONEncoding.default)

            req.responseJSON { response in
              guard let json = response.data else { return }
              guard let restdata = try? JSONDecoder().decode([dormitory].self, from: json)
              else {
                getUniversityDormitory(dormitoryId: String(jwtdata.univId), model: dormis)
                return
              }
              dormis.data = restdata
              SocketIOManager.shared.establishConnection(token: "Bearer \(token)", roomdata: roomdata, dormis: dormis)
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
