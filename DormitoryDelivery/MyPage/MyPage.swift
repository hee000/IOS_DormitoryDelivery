//
//  MyPage.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import RealmSwift
import SocketIO
import Alamofire
//import PhotoLibraryPicker


struct MyPage: View {
    @EnvironmentObject var naverLogin: NaverLogin
    @EnvironmentObject var chatdata: ChatData
//    @ObservedResults(UserPrivacy.self) var userPrivacy
    @ObservedResults(ChatDB.self) var chatResult
    @StateObject var userPrivacy = UserData()

  @State var alram: Bool = (UserData().data?.alram ?? true)
//    @ObservedResults(ChatDB.self) var parents
//    print(parents.filter(NSPredicate(format: "rid == '5'")))
  //  @ObservedRealmObject var item: ChatDB
  //  @ObservedResults(MyEvent.self,filter:NSPredicate(format: "title  != 'L'"),sortDescriptor:SortDescriptor(keyPath: "start", ascending: false)) private var results
  
//  @State var test: [UIImage] = []
  @State var test = [Picture]()
  @State var isTest = false

    var body: some View {
      GeometryReader { geo in
          ScrollView{
            HStack (spacing: 20){ // 프로필부분
              Image("ImageDefaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .cornerRadius(100)
                .shadow(color: Color.black.opacity(0.5), radius: 1)
              VStack (alignment: .leading, spacing: 3) {
                Text(UserData().data?.name ?? "")
                  .font(.system(size: 16, weight: .bold))
                Text(String(userPrivacy.data?.belongStr ?? ""))
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(.gray)
//                Text(userPrivacy.data?.emailAddress ?? "")
//                  .font(.system(size: 16, weight: .regular))
//                  .foregroundColor(.gray)
                Text("\(userPrivacy.data?.provider?.uppercased() ?? "") 로그인")
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(.gray)
              }
              Spacer()
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))



            VStack(alignment: .leading ,spacing: 0) {
              Text("설정")
                .font(.system(size: 18, weight: .regular))
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
              
              Group{
                NavigationLink(destination: AccountView()) {
                  HStack{
                    Text("계좌 관리")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                      .font(.system(size: 18, weight: .regular))
                  }
                  .frame(height: 70)
                }

                Divider()
                
                Toggle(isOn: $alram) {
                  Text("알림")
                    .font(.system(size: 18, weight: .bold))
                    .frame(height: 70)
                }
                .toggleStyle(SwitchToggleStyle())
                .tint(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1)) // 물빠진색 뭐냐
                .disabled(true)
                .onTapGesture {
                    // 알람 Off, rest요청 응답 받으면
                  let after = !self.alram
                  guard let param = try? serverNotiToken(enabled: !self.alram).asDictionary() else { return }
                  print(param)
                  
                  let req = AF.request(urlalramonoff(), method: .patch, parameters: param, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
                  
//                    req.responseJSON { response in
//                        print(response)
//                    }
                  req.responseString { res in
//                    print(res.response)
//                    print(res.description)
//                    print(res.response?.statusCode)
//                    print(res.value)
//                    print(res.data)
                    if res.response?.statusCode == 200 {
                      withAnimation {
                        self.alram = after
                      }
                    }
                  }
                }
                .onChange(of: alram) { V in
                  print(V)
                  let realm = try! Realm()
                  guard let pri = realm.objects(UserPrivacy.self).first else { return }
                  try? realm.write {
                    pri.alram = V
                  }
                } // 혹은 rest요청 안에서 db 수정

              } // 그룹 계좌 알람
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))

              Text("정보")
                .font(.system(size: 18, weight: .regular))
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])

              Group{
//                NavigationLink(destination: HelpView()) {
//                  HStack{
//                    Text("도움말")
//                      .font(.system(size: 18, weight: .bold))
//                    Spacer()
//                    Image(systemName: "chevron.right")
//                      .font(.system(size: 18, weight: .regular))
//                  }
//                  .frame(height: 70)
//                }
//                Divider()

                NavigationLink(destination: TOSView()) {
                  HStack{
                    Text("이용약관")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                      .font(.system(size: 18, weight: .regular))
                  }
                  .frame(height: 70)
                }

                Divider()

                NavigationLink(destination: PrivacyPoliceView()) {
                  HStack{
                    Text("개인정보 처리방침")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                      .font(.system(size: 18, weight: .regular))
                  }
                  .frame(height: 70)
                }

                Divider()

                HStack{
                  Text("버전")
                    .font(.system(size: 18, weight: .bold))
                  Spacer()
                  Text("1.1.2")
                    .font(.system(size: 18, weight: .bold))
                }
                .frame(height: 70)
              } // 그룹 정보
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))

              Text("계정")
                .font(.system(size: 18, weight: .regular))
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])

              Group{
                Button(action: {
//                  naverLogin.logout()
//                  print(userPrivacy.data!.provider!)
                  if let provider = userPrivacy.data?.provider {
                    if (provider == LoginProviders.naver.rawValue) {
                      print("navsss")
                      naverLogin.logout()
//                      LoginSystem().testLogout()
                    } else if (provider == LoginProviders.apple.rawValue) {
                      print("sss")
                      LoginSystem().logout()
                    }
                  }
                }) {
                  HStack{
                    Text("로그아웃")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                      .font(.system(size: 18, weight: .regular))
                  }
                  .frame(height: 70)
                }


                Divider()

                NavigationLink(destination: WithdrawalView()) {
                  HStack{
                    Text("탈퇴하기")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                      .font(.system(size: 18, weight: .regular))
                  }
                  .frame(height: 70)
                }
              } // 그룹 로그아웃탈퇴
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))
              
              Text("문의 사항은 teamshallwe@gmail.com으로 부탁드립니다.")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
                .padding()
            } //V
          } //scroll
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(.black)
        .onAppear {
          if UserData().data?.belongStr == nil || UserData().data?.emailAddress == nil {
            
            guard let universityId = UserData().data?.belong else { return }
            let req = AF.request(urluniversityinfo(id: universityId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())

            req.responseJSON { response in
              
              guard let data = response.data,
                    let university = try? JSONDecoder().decode(university.self, from: data) else { return }
              
              let realm = try! Realm()
              guard let result = realm.objects(UserPrivacy.self).first else { return }
              
              try? realm.write {
                result.belongStr = university.korName
//                result.emailAddress = university.engName
              }
            }
          }
        }
      } //geo
      .clipped()
    }
}

