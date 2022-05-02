//
//  EmailCertificationNumberView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/14.
//

import SwiftUI
import Combine
import Alamofire
import RealmSwift
import JWTDecode

class Store: ObservableObject {

  @Published var CertificationNumber = Array(repeating: "", count: 5)
//  @Published var focusedField: Field?

  
  func limitText(_ index: Int) {
//    if CertificationNumber[index].count > 1 {
      CertificationNumber[index] = String(CertificationNumber[index].prefix(1))

  }
}

struct EmailCertificationNumberView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var naverLogin: NaverLogin

  @FocusState private var focusedField: Int?
  @StateObject var store = Store()
  
  var email: String

    var body: some View {
      VStack(alignment: .leading) {
        VStack(alignment: .leading){
          Text("인증번호를 입력해주세요.")
            .font(.system(size: 28, weight: .bold))
            .padding(.bottom)
          HStack(spacing: 0) {
            Text(email)
              .font(.system(size: 15, weight: .bold))
              .foregroundColor(.black)
            Text("으로")
              .font(.system(size: 15, weight: .regular))
              .foregroundColor(.gray)
          }
          Text("인증 메일을 발송했습니다.")
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.gray)
          Text("메일에 있는 인증번호를 아래 빈칸에 입력해주세요.")
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.gray)
        }
        .padding([.top, .bottom])
        
        
        HStack {
          ForEach(0..<5, id:\.self) { index in
            TextField(self.store.CertificationNumber[index], text:$store.CertificationNumber[index])
              .font(.system(size: 36, weight: .heavy, design: .default))
              .keyboardType(.numberPad)
              .onChange(of: self.store.CertificationNumber[index], perform: { newValue in
                store.limitText(index)
                if store.CertificationNumber[index] != "" && index != 4 {
                  self.focusedField = index + 1
                }
                if newValue == "" {
                  self.focusedField = index - 1
                }
              })
              .focused($focusedField, equals: index)
              .frame(width: UIScreen.main.bounds.width * (8/50), height: UIScreen.main.bounds.width * (8/50))
              .multilineTextAlignment(.center)
              .background(Color(.sRGB, red: 211/255, green: 211/255, blue: 211/255, opacity: 1))
              .cornerRadius(5)
          }//for
        }
        .padding([.top, .bottom])
        
        HStack{
          Text("메일을 받지 못하셨나요?")
            .font(.system(size: 12, weight: .regular))
          Button{
            print(store.CertificationNumber)
          } label: {
            Text("재발급 요청")
            .font(.system(size: 12, weight: .regular))
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        
        Button {
          //이메일 형식이 올바르다면 rest 쏘고, navi active
          var code = ""
          for num in store.CertificationNumber {
            code = code + num
          }
          if code.count == 5 {
            let url = urlemailverify()
            let createkey = emailverify(authCode: code, oauthAccessToken: naverLogin.loginInstance!.accessToken!)

            guard let param = try? createkey.asDictionary() else { return }
            AF.request(url, method: .post,
                       parameters: param,
                       encoding: JSONEncoding.default).responseJSON { response in
              
              print("re1", response)
              
              if response.response?.statusCode == 201 {
                let url2 = urlsession()
                let token2 = naverLogin.loginInstance!.accessToken!
                let createkey2 = authsession(type: "naver", accessToken: naverLogin.loginInstance!.accessToken!, deviceToken: "")

                guard let param2 = try? createkey2.asDictionary() else { return }
                
                AF.request(url2, method: .post,
                           parameters: param2,
                           encoding: JSONEncoding.default
                ).responseJSON { response2 in
                  
                  print("re2", response2)
                  print("re2 status", response2.response?.statusCode)
                  if response2.response?.statusCode == 201 {
                    guard let restdata = try? JSONDecoder().decode(tokenvalue.self, from: response2.data!) else { return }
                    
                    let tk = TokenUtils()
                    tk.create(token: restdata)
                    guard let token = tk.read(),
                          let jwt = try? decode(jwt: token),
                          let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
                          let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
                    
                    let user = UserPrivacy()
                    user.id = jwtdata.id
                    user.name = jwtdata.name
                    user.belong = jwtdata.univId
                    user.emailAddress = "네이버 로그인"
                    
                    let realm = try! Realm()
                    try? realm.write {
                        realm.add(user)
                    }
                    LoginSystem().setLogin(true)
//                    naverLogin.Login = true
                  }
                }

                
              }//상태 201
            }
          }
//          naverLogin.Login = true
//          print("d")
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
      .padding()
      .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("인증번호 확인")
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

//struct EmailCertificationNumberView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmailCertificationNumberView()
//    }
//}
