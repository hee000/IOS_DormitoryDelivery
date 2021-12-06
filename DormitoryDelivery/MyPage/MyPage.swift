//
//  MyPage.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI

struct MyPage: View {
//  @ObservedObject var user: User
  
    var body: some View {
      
      VStack{
        Text("마이페이지").frame(height: 50)
        Divider()
        
        Spacer()
        
        Button(action: {
//          self.user.isLoggedIn = false
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
