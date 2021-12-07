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
  

  
    var body: some View {
    
      VStack{
        Text("마이페이지")
          .frame(height: 50)
          .onAppear {
            print(chatdata.chatlist.count)
            print(chatdata.chatlist)
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
