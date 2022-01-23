//
//  ChatSideMenu.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/23.
//

import SwiftUI

struct ChatSideMenu: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @ObservedObject var model: ChatModel
  var rid: String
  
    var body: some View {
      VStack(alignment: .leading) {
        Text("메뉴")
        
        Button("주문서"){
          self.model.showMenu.toggle()
          if let mytoken = naverLogin.loginInstance?.accessToken {
            getMenuList(rid: rid, token: mytoken)
          }
          self.model.oderlistview.toggle()
        }

        Button("투표하기"){
          print("투표하기")
        }
        
        
        Spacer()
        
        Text("참여상대")
        
        HStack{
//          Label("이름", image: "person.circle.fill")
          Text("이름")
          Button("강퇴하기"){
            print("강퇴하기")
          }
        }
        
        Button(action: {
          if let mytoken = naverLogin.loginInstance?.accessToken {
            getRoomLeave(rid: self.rid, token: mytoken, model: model)
          }
        }) {
          Text("채팅나가기")
//            Label("채팅 나가기", image: "arrow.right.square")
        }
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading)
//      .background(Color(red: 32/255, green: 32/255, blue: 32/255))
      .background(.white)
//      .edgesIgnoringSafeArea(.all)

    }
}

//struct ChatSideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatSideMenu()
//    }
//}
