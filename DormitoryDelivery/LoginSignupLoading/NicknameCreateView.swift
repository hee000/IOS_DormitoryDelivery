//
//  NicknameCreateView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/09/07.
//

import SwiftUI
import Alamofire
import AuthenticationServices

struct NicknameCreateView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var appleToken: AppleToken
  @AppStorage("OauthProvider") var OauthProvider: String = UserDefaults.standard.string(forKey: "OauthProvider") ?? "None"
  
  
  @State var nickname = ""
  var sid: String
  
    var body: some View {
      VStack(alignment: .leading) {
        Text("같이하실에서 사용할 닉네임을 설정해주세요.")
          .font(.system(size: 16, weight: .bold))
          .padding()
          .padding(.top)
          .padding(.top)
        TextField("닉네임을 입력해주세요.", text: $nickname)
          .font(.system(size: 14, weight: .regular))
          .padding()
        
        Button {
          //이메일 형식이 올바르다면 rest 쏘고, navi active
          if nickname != "" {
            let url = urlemailuserinfo(sid: self.sid)
            let param = ["nickname" : "\(nickname)"] as Dictionary
            
            AF.request(url, method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default, headers: ["Client-Version" : "ios \(AppVersion)", "sId" : "\(self.sid)"]).responseJSON { response in
              
              print("re2", response)
              print("re2", response.response?.statusCode)
              appVaildCheck(res: response)
              if response.response?.statusCode == 201 {
                if OauthProvider == LoginProviders.naver.rawValue {
                  naverLogin.oauth20ConnectionDidFinishRequestACTokenWithAuthCode()
                } else if OauthProvider == LoginProviders.apple.rawValue {
                  guard let authResults = appleToken.authResults,
                        let credentials = authResults.credential as? ASAuthorizationAppleIDCredential,
                        let identityToken = credentials.identityToken,
                        let identityTokenString = String(data: identityToken, encoding: .utf8),
                        let authorizationCode = credentials.authorizationCode,
                        let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
                  else { return }
                  
                  let payload = "{\"identityToken\": \"\(identityTokenString)\", \"authorizationCode\": \"\(authorizationCodeString)\", \"state\": \"\(credentials.state ?? "")\", \"user\": \"\(credentials.user)\"}"
                  
//                  let oauth = oauthInfo(provider: OauthProvider, payload: payload)
                  LoginSystem().login(provider: OauthProvider, payload: payload)
                }
              }//상태 201
            } //rest
          } // if nickname
        } label: {
            Text("확인")
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity)
        }
        .frame(height: 60, alignment: .center)
        .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
        .cornerRadius(5)
        .padding([.leading, .trailing])
        .padding([.leading, .trailing])
        .padding([.top, .bottom])
        
        Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarTitle("닉네임 설정")
      .navigationBarBackButtonHidden(true)
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
                  .foregroundColor(Color.black)
              }
            }
          }
      }
    }
}
