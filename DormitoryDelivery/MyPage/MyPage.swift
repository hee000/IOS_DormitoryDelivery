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
            print(users)

//            print(parents.)
//            print(self.item)

              

//            }
                              
          }
        Divider()
        
        Spacer()
        
        Button(action: {
          naverLogin.logout()
        }) {
          Text("로그아웃")
        }
        
        Spacer()
      }
      .navigationTitle("")
      .navigationBarHidden(true)
    }
}

//struct MyPage_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPage()
//    }
//}
