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
  
    @ObservedResults(ChatDB.self) var parents
//    @ObservedRealmObject var item: ChatDB = ChatDB()



  
    var body: some View {
    
      VStack{
        Text("마이페이지")
          .font(.system(size: 21))
          .padding([.leading, .top])
          .foregroundColor(Color.black)
          .frame(width: UIScreen.main.bounds.size.width, height: 50, alignment: .leading)
          .onAppear {
            print(chatdata.chatlist.count)
            let realm = try! Realm()
            let users = realm.objects(ChatDB.self) // 기본키 사용
            let user = realm.object(ofType: ChatDB.self, forPrimaryKey: "1")
//            print(user?.messages.indices)
//            print(users)
            print(chatdata.chatlist)

//            print(parents.)
//            print(self.item)

              

//            }
                              
          }
        Divider()
        
//        Button(action: {
//          if let mytoken = naverLogin.loginInstance?.accessToken {
//            getRoomLeave(rid: "5", token: mytoken)
//          }
//        }) {
//            Label("채팅 나가기", image: "arrow.right.square")
//        }
        
        Spacer()
        
        Button(action: {
          naverLogin.logout()
        }) {
          Text("로그아웃")
        }
        
        Spacer()
      }
      .navigationTitle("마이페이지")
    }
}

//struct MyPage_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPage()
//    }
//}
