////
////  Home.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/15.
////
//
//import SwiftUI
//
//struct TabViews: View {
//
//  @State var tabSelect = 0
//
//  var body: some View {
//
//      TabView(selection: $tabSelect) {
//        NavigationView {DeliveryView()} .tabItem {
//          if self.tabSelect == 0 {
////            Label("홈", image: "대지 8 사본")
//            Label("", image: "23424")
//          } else {
////            Label("홈", image: "대지 8 사본 5")
//            Label("", image: "대지 8 사본 5")
//          }
//        }
//        .tag(0)
//
//        NavigationView {CreateRoomView()}.tabItem {
//          if self.tabSelect == 1 {
//            Label("개설", image: "대지 8 사본 3")
//          } else {
////            Label("개설", image: "대지 8 사본 7")
//            Label("", image: "대지 8 사본 7")
//          }
//        }.tag(1)
//
//        NavigationView {ChatView()}.tabItem {
//          if self.tabSelect == 2 {
//            Label("채팅", image: "대지 8")
//          } else {
////            Label("채팅", image: "대지 8 사본 4")
//            Label("", image: "대지 8 사본 4")
//          }
//        }.tag(2)
//
//        MyPage().tabItem {
//          if self.tabSelect == 3 {
//            Label("마이", image: "대지 8 사본 2")
//          } else {
////            Label("마이", image: "대지 8 사본 6")
//            Label("", image: "대지 8 사본 6")
//          }
//        }.tag(3)
//
//      }
//      .accentColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
//
//
//  }
//}
//
//struct TabViews_Previews: PreviewProvider {
//    static var previews: some View {
//      TabViews()
//    }
//}






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
    NavigationView {
      TabView(selection: $tabSelect) {
        DeliveryView()
          .tabItem {
          if self.tabSelect == 0 {
//            Label("홈", image: "대지 8 사본")
            Label("", image: "23424")
          } else {
//            Label("홈", image: "대지 8 사본 5")
            Label("", image: "대지 8 사본 5")
          }
        }
        .tag(0)

        CreateRoomView().tabItem {
          if self.tabSelect == 1 {
            Label("개설", image: "대지 8 사본 3")
          } else {
//            Label("개설", image: "대지 8 사본 7")
            Label("", image: "대지 8 사본 7")
          }
        }.tag(1)

        ChatView().tabItem {
          if self.tabSelect == 2 {
            Label("채팅", image: "대지 8")
          } else {
//            Label("채팅", image: "대지 8 사본 4")
            Label("", image: "대지 8 사본 4")
          }
        }.tag(2)

        MyPage().tabItem {
          if self.tabSelect == 3 {
            Label("마이", image: "대지 8 사본 2")
          } else {
//            Label("마이", image: "대지 8 사본 6")
            Label("", image: "대지 8 사본 6")
          }
        }.tag(3)
      }
      
      
      
//      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          HStack {
              if self.tabSelect == 0 {
                Text("전체")
                  .bold()
                  .font(.title)
                Spacer()
              } else if self.tabSelect == 1 {
                Text("방 개설")
                  .bold()
              } else if self.tabSelect == 2 {
                Text("채팅")
                  .bold()
              } else {
              Text("마이 페이지")
                  .bold()
              }
          }
        }
      }
      
  }
      .accentColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))

  }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
      TabViews()
    }
}
