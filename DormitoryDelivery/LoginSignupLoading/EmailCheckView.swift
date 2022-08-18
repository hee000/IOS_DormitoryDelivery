//
//  EmailCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/14.
//

import SwiftUI
import Alamofire

struct EmailCheckView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @StateObject var universitys = universityList()
  
  @State var emailstr: String = ""
  @State private var selection: university? = nil
  @State var navi = false
  @State var doublestop = false
  
    var body: some View {
      NavigationView{
        ZStack{
          ScrollView{
            VStack(alignment: .leading) {
              if let domain = selection?.emailDomain{
                NavigationLink(destination: EmailCertificationNumberView(email: emailstr + "@" + domain), isActive: $navi) {}
              }
              Group{
                Image("ImageSplashLogo_H")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 99.63, height: 135.25)
              }
              .frame(maxWidth: .infinity)
              .padding(.bottom)
              .padding(.bottom)
             
              Text("대학교")
                .font(.system(size: 16, weight: .bold))
              Menu {
                  ForEach(universitys.data, id: \.self) { data in
                    Button{
                      self.selection = data
                    } label: {
                      Text("\(data.korName)")
                        .font(.system(size: 14, weight: .regular))
                    }
                  }
              } label: {
                HStack{
                  Text(self.selection != nil ? "\(self.selection!.korName)" : "소속 대학교를 선택해주세요.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.black)
                  Spacer()
                  Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 13, height: 10)
                    .foregroundColor(.purple)
                }
                  .frame(maxWidth: .infinity)
                  .padding()
                  .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
              }
              .padding(.bottom)

              Text("Email")
                .font(.system(size: 16, weight: .bold))
              HStack(spacing: 0) {
                TextField("이메일을 입력해주세요.", text: $emailstr)
                  .font(.system(size: 14, weight: .regular))
                  .padding()
                Text(self.selection != nil ? "@\(self.selection!.emailDomain)" : "@대학교를 선택해주세요.")
                  .font(.system(size: 14, weight: .regular))
                  .padding(.trailing)
              }
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
              
              Button {
                self.doublestop = true
                //이메일 형식이 올바르다면 rest 쏘고, navi active
                let url = urlemailsend()

                guard let token = naverLogin.loginInstance?.accessToken,
                      let createkey = try? emailsend(universityId: self.selection!.id, email: self.emailstr, oauthAccessToken: token).asDictionary()
                else { return }
                
                AF.request(url, method: .post, parameters: createkey, encoding: JSONEncoding.default, headers: ["Client-Version" : "ios \(AppVersion)"]).responseJSON { response in
                  print(response)
                  if response.response?.statusCode == 201 {
                    self.navi = true
                    self.doublestop = false
                  } else {
                    self.doublestop = false
                  }
                }
              } label: {
                  Text("인증번호 받기")
                  .font(.system(size: 18, weight: .bold))
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
              }
              .disabled(emailstr != "" && selection != nil ? false : true)
              .frame(height: 47, alignment: .center)
              .background(emailstr != "" && selection != nil ? Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1) : Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1).opacity(0.5))
              .cornerRadius(5)
              .padding(.top)
              
              
              HStack(spacing: 0) {
                Text("인증 진행 시 ")
                  .font(.system(size: 14, weight: .regular))
                NavigationLink(destination: TOSView()) {
                  Text("이용약관")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .underline()
                }
                Text(" 및 ")
                  .font(.system(size: 14, weight: .regular))
                NavigationLink(destination: PrivacyPoliceView()) {
                  Text("개인정보 처리방침")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .underline()
                }
                Text("에")
                  .font(.system(size: 14, weight: .regular))
              }
              .padding(.top)
              Text("동의하는 것으로 간주합니다.")
                .font(.system(size: 14, weight: .regular))
              
            } //V
            .padding()
          } //scroll
//          .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
            
          VStack(alignment: .leading, spacing: 0){
            Spacer()
            Text("학교 이메일 계정이 필요한 이유 ?")
              .font(.system(size: 14, weight: .regular))
              .underline()
              .foregroundColor(.gray)
              .padding(.bottom, 5)
            
            Text("문의 사항은 teamshallwe@gmail.com으로 부탁드립니다.")
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .ignoresSafeArea(.keyboard)
        } //z
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("회원가입")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              naverLogin.logout()
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.black)
            }
          }
        }
      }//navi
      .disabled(self.doublestop ? true : false)
      .onTapGesture {
          hideKeyboard()
      }
      .onAppear {
        let url = urluniversity()
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Client-Version" : "ios \(AppVersion)"])
        req.responseJSON { response in
//          print(response)
          guard let data = response.data,
                let restdata = try? JSONDecoder().decode([university].self, from: data) else { return }
          self.universitys.data = restdata
          
        }
      }
    }
}

struct EmailCheckView_Previews: PreviewProvider {
    static var previews: some View {
        EmailCheckView()
    }
}
