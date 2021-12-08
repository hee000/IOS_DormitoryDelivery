//
//  Home.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI

struct TabViews: View {
  
  @State var tabSelect = 0
  
  var body: some View {
    NavigationView{
      TabView(selection: $tabSelect) {
        
        DeliveryView().tabItem {
          if self.tabSelect == 0 {
            Label("홈", image: "a_홈")
          } else {
            Label("홈", image: "b_홈")
          }
        }
        .tag(0)
        
        CreateRoomView().tabItem {
          if self.tabSelect == 1 {
            Label("개설", image: "a_개설")
          } else {
            Label("개설", image: "b_개설")
          }
        }.tag(1)
        
        ChatView().tabItem {
          if self.tabSelect == 2 {
            Label("채팅", image: "a_채팅")
          } else {
            Label("채팅", image: "b_채팅")
          }
        }.tag(2)
        
        MyPage().tabItem {
          if self.tabSelect == 3 {
            Label("마이", image: "a_마이")
          } else {
            Label("마이", image: "b_마이")
          }
        }.tag(3)
        
      }
      .accentColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
    }
  }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
      TabViews()
    }
}
