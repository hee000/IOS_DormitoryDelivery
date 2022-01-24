//
//  ChatSideMenu.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/23.
//

import SwiftUI

struct ChatSideMenu: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var chatdata: ChatData
  @ObservedObject var model: ChatModel
  var rid: String
  
    var body: some View {
      GeometryReader { geo in
        VStack(alignment: .leading) {
          VStack(alignment: .leading, spacing: 5) {
            Text("채팅방")
              .font(.title3)
              .bold()
              .padding(.bottom)
            
            Button("주문서 확인"){
              self.model.showMenu.toggle()
//              if let mytoken = naverLogin.loginInstance?.accessToken {
//                getMenuList(rid: rid, token: mytoken)
//              }
              self.model.oderlistview.toggle()
            }

            Button("투표하기"){
              print("투표하기")
            }

            Spacer()
          
            Text("참여상대")
              .font(.title3)
              .bold()
              .padding(.bottom)
            
            HStack{
              Text("이름")
              Button("강퇴하기"){
                print("강퇴하기")
              }
            }
            
          } // 나가기 위 vstack
          .padding()
          
          Button(action: {
            if let mytoken = naverLogin.loginInstance?.accessToken {
              getRoomLeave(rid: self.rid, token: mytoken, model: model)
            }
          }) {
            HStack {
              Image(systemName: "arrow.right.square")
              Text("채팅나가기")
            }
          }
          .padding(.leading)
          .frame(width: geo.size.width, height: 45, alignment: .leading)
          .background(Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1))

        } // vstack
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
      } // geo

    }
}
