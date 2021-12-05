////
////  logintest.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/30.
////
//
//import SwiftUI
//import KakaoSDKCommon
//import KakaoSDKAuth
//import KakaoSDKUser
//
//struct logintest: View {
//  @State var kakaologin: Bool = false
//
//    var body: some View {
//
//      if !kakaologin{
//      VStack{
//        Spacer().frame(width: 1000)
//      Button(action : {
//          //카카오톡이 깔려있는지 확인하는 함수
//        if (UserApi.isKakaoTalkLoginAvailable()) {
//            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
//                if let error = error {
//                    print(error)
//                }
//                else {
//                    print("loginWithKakaoTalk() success.")
////                  self.kakaologin = true
//
//                    //do something
//                    _ = oauthToken
//
//
////                      UserApi.shared.me() {(user, error) in
////                          if let error = error {
////                              print(error)
////                          }
////                          else {
////                              print("me() success.")
////
////                              //do something
////                              let a = user!
////                            if a.id! == 2012842079 {
////                              self.kakaologin = true
////                            }
////                          }
////                      }
//
//
//                }
//            }
//        } else{
//          UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
//                  if let error = error {
//                      print(error)
//                  }
//                  else {
//                      print("loginWithKakaoAccount() success.")
//
//                      //do something
//                      _ = oauthToken
//                  }
//              }
//          }
//      }){
//          Image("kakao_login_medium_wide")
////          Text("카카오 로그인")
//      }
//      //ios가 버전이 올라감에 따라 sceneDelegate를 더이상 사용하지 않게되었다
//      //그래서 로그인을 한후 리턴값을 인식을 하여야하는데 해당 코드를 적어주지않으면 리턴값을 인식되지않는다
//      //swiftUI로 바뀌면서 가장큰 차이점이다.
//      .onOpenURL(perform: { url in
//          if (AuthApi.isKakaoTalkLoginUrl(url)) {
//              _ = AuthController.handleOpenUrl(url: url)
//          }
//      })
//
//        Button(action : {
//          UserApi.shared.me() {(user, error) in
//              if let error = error {
//                  print(error)
//              }
//              else {
//                  print("me() success.")
//
//                  //do something
//                  _ = user
//              }
//          }
//        }){
////            Image("kakao_login_medium_wide")
//            Text("카카오 로그인")
//        }
//
//
//      }
//      .padding(0)
//      .background(Color.red)
//      } else {
//        Text("이메일인증")
//      }
//
//    }
//}
//
//struct logintest_Previews: PreviewProvider {
//    static var previews: some View {
//        logintest()
//    }
//}
