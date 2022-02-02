//
//  MyPage.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import RealmSwift


struct MyPage: View {
    @EnvironmentObject var naverLogin: NaverLogin
    @EnvironmentObject var chatdata: ChatData
    @ObservedResults(UserPrivacy.self) var userPrivacy
    @ObservedResults(ChatDB.self) var chatResult

//    @ObservedResults(ChatDB.self) var parents
//    print(parents.filter(NSPredicate(format: "rid == '5'")))
  //  @ObservedRealmObject var item: ChatDB
  //  @ObservedResults(MyEvent.self,filter:NSPredicate(format: "title != 'L'"),sortDescriptor:SortDescriptor(keyPath: "start", ascending: false)) private var results

    var body: some View {
      let privacy = userPrivacy.first!
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
              Button(action: {
              }) {
                HStack{
                  VStack (alignment: .leading, spacing: 5) {
                    Text(privacy.name!)
                      .bold()
                      .font(.title3)
                    Text(privacy.belong!)
                      .foregroundColor(.gray)
                  }
                  Spacer()
                  Image(systemName: "chevron.right")
                }
              }
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .padding([.leading, .trailing])
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
            
            VStack(alignment: .leading ,spacing: 0) {
              Text("설정")
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
              
              Group{
                Button(action: {
                  print(userPrivacy)
                }) {
                  HStack{
                    Text("계좌 관리")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                Button(action: {
                  print(chatResult)
                }) {
                  HStack{
                    Text("알람 설정")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
              } // 그룹 계좌 알람
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))
              
              Text("정보")
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
              
              Group{
                Button(action: {
                  if let mytoken = naverLogin.loginInstance?.accessToken {
                    getRooms(uid: privacy._id!, token: mytoken)
                  }
                }) {
                  HStack{
                    Text("도움말 // 방목록")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                Divider()
                
                Button(action: {
                  if let mytoken = naverLogin.loginInstance?.accessToken {
                    let chatdb = roomidtodbconnect(rid: "2")
                    let idx = chatdb?.messages.last?.idx
                    
                    getChatLog(rid: "2", idx: idx!, token: mytoken)
                  }
                }) {
                  HStack{
                    Text("이용약관  // 쳇로그")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                Button(action: {
                }) {
                  HStack{
                    Text("개인정보 취급방침")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                Button(action: {
                }) {
                  HStack{
                    Text("버전")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
              } // 그룹 정보
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))
              
              Text("계정")
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
              
              Group{
                Button(action: {
                  naverLogin.logout()
                }) {
                  HStack{
                    Text("로그아웃")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }

                
                Divider()
                
                Button(action: {
                }) {
                  HStack{
                    Text("탈퇴하기")
                      .bold()
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
              } // 그룹 로그아웃탈퇴
              .padding([.leading, .trailing])
              .padding([.leading, .trailing])
              .background(Color(.sRGB, red: 243/255, green: 243/255, blue: 244/255, opacity: 1).frame(width:geo.size.width))
            } //V
          } //scroll
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tint(.black)
      } //geo
      .clipped()
    }
}
