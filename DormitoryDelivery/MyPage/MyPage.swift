//
//  MyPage.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import RealmSwift

func remove(realmURL: URL) {
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management"),
            ]
        for URL in realmURLs {
            try? FileManager.default.removeItem(at: URL)
        }}



struct MyPage: View {
    @EnvironmentObject var naverLogin: NaverLogin
    @EnvironmentObject var chatdata: ChatData
  

  
    var body: some View {
    
      
      VStack{
        Button {
          remove(realmURL: Realm.Configuration.defaultConfiguration.fileURL!)
//          print(state.chatlist)
          
          
        } label: {
          Text("버튼")
        }
        Text("마이페이지").frame(height: 50)
          .onAppear {
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
    }
}

//struct MyPage_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPage()
//    }
//}
