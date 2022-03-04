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
              VStack (alignment: .leading, spacing: 3) {
                Text(privacy.name!)
                  .font(.system(size: 16, weight: .bold))
                Text(String(privacy.belong))
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(.gray)
                Text("email_ID")
                  .font(.system(size: 16, weight: .regular))
                  .foregroundColor(.gray)
              }
              Spacer()
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
            
            Button("방 정보"){
              let realm = try! Realm()
              try! realm.write {
                var a = realm.objects(ChatDB.self).last
                var net = ChatUsersInfo()
                net.userId = "Asdsad"
                net.name = "하하"
                a!.member.append(net)
              }
            }
            
            Button("방 정보"){
              getRooms(uid: privacy.id!)
            }
            
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
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                Button(action: {
                  print(chatResult)
                }) {
                  HStack{
                    Text("알람 설정 // chatdb")
                      .font(.system(size: 18, weight: .bold))
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
                .font(.system(size: 18, weight: .regular))
                .frame(height: 50)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing])
              
              Group{
                Button(action: {
                  print(userPrivacy)
                }) {
                  HStack{
                    Text("도움말 // 유저db")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                Divider()
                
                NavigationLink(destination: TOSView()) {
                  HStack{
                    Text("이용약관")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                Button(action: {
                  let realm = try! Realm()
                  guard let chatrids = realm.objects(ChatDB.self).value(forKey: "rid") as? Array<Any> else { return }
                  for rid in chatrids {
                    let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
                    guard let idx = db?.messages.last?.idx else {
                      getChatLog(rid: rid as! String, idx: 0)
                      return
                      
                    }
//                    print(idx.value)
//                    getChatLog(rid: rid as! String, idx: 0)
                    getChatLog(rid: rid as! String, idx: idx.value!)
                  }
                }) {
                  HStack{
                    Text("개인정보 취급방침 // 쳇로그 rest")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                  }
                  .frame(height: 70)
                }
                
                Divider()
                
                HStack{
                  Text("버전")
                    .font(.system(size: 18, weight: .bold))
                  Spacer()
                  Text("1.0")
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
                  naverLogin.logout()
                }) {
                  HStack{
                    Text("로그아웃")
                      .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Image(systemName: "chevron.right")
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
