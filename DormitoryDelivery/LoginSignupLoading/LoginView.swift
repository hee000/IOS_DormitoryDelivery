//
//  NaverLogin.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/04.
//


import SwiftUI
import AuthenticationServices
import JWTDecode
import Alamofire
import RealmSwift

class AppleToken: ObservableObject {
  @Published var authResults: ASAuthorization?
}

struct LoginView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var appleToken: AppleToken
  
    var body: some View {

      ZStack{
        VStack(alignment: .center) {

          Image("ImageSplashLogo_V")
            .resizable()
            .scaledToFit()
            .frame(width: 66, height: 264)

          
          VStack{
            Text("간편하게 로그인하고")
              .bold()
            Text("필요한 것들을 1/n하세요!")
              .bold()
          }
          .foregroundColor(Color(.sRGB, red: 197/255, green: 197/255, blue: 197/255, opacity: 1))
          .font(.system(size: 16))
          .padding(.top, 20)
        }
        
        VStack{
          Spacer()

          
        } //v
        
        VStack {
          Button {
            naverLogin.login()
          } label: {
           Image("naverloginbutton")
              .resizable()
              .scaledToFill()
              .frame(height: 50)
              .frame(width: UIScreen.main.bounds.width * 8/10)
              .cornerRadius(5)
          }
//          .frame(height: 50)
//          .frame(width: UIScreen.main.bounds.width * 8/10)
          .padding([.leading, .trailing])
          
          SignInWithAppleButton(.signIn) { request in
//            request.requestedScopes = [.fullName, .email]
          } onCompletion: { result in
            switch result {
              case .success(let authResults):
                print("Authorisation successful")
              
              appleToken.authResults = authResults
              
              guard let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
                    let identityToken = credentials.identityToken,
                    let identityTokenString = String(data: identityToken, encoding: .utf8),
                    let authorizationCode = credentials.authorizationCode,
                    let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
              else { return }

              
              
//              let url2 = urlsession()

              let payload = "{\"identityToken\": \"\(identityTokenString)\", \"authorizationCode\": \"\(authorizationCodeString)\", \"state\": \"\(credentials.state ?? "")\", \"user\": \"\(credentials.user)\"}"
              
//              let oauth = oauthInfo(provider: "apple", payload: payload)
//
//              let loginToken = loginToken(oauthInfo: oauth, deviceToken: TokenUtils().readDevice() ?? "")
//
//              guard let param2 = try? loginToken.asDictionary() else { return }
//
//
//              print(param2)
              
              LoginSystem().login(provider: LoginProviders.apple.rawValue, payload: payload)
          
              
              case .failure(let error):
                print("Authorisation failed: \(error.localizedDescription)")
            }
          }
          .signInWithAppleButtonStyle(.whiteOutline)
          .frame(height: 50)
          .frame(width: UIScreen.main.bounds.width * 8/10)
          .padding([.leading, .trailing])
        }
        .offset(y: UIScreen.main.bounds.height * 8/10 / 2)

      } //z

  
    }
}


struct NaverLogin_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



struct loginToken: Codable {
  var oauthInfo: oauthInfo;
  var deviceToken: String;
}

struct oauthInfo: Codable {
  var provider: String;
  var payload: String;
}

