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
import RealmSwift

struct TabViews: View {
  @EnvironmentObject var chatdata: ChatData

  @State var tabSelect = 0
  @State var createRoomSelect = false
  @State var tabSelectTmp = 0

  var body: some View {
//    NavigationView {
      ZStack{
        TabView(selection: $tabSelect) {
          DeliveryView()
            .tabItem {
            if self.tabSelect == 0 {
              Label("", image: "23424")
            } else {
              Label("", image: "대지 8 사본 5")
            }
          }
          .tag(0)

          Text("").tabItem {
            if self.tabSelect == 1 {
              Label("개설", image: "대지 8 사본 3")
            } else {
              Label("", image: "대지 8 사본 7")
            }
          }.tag(1)

          ChatView().tabItem {
            if self.tabSelect == 2 {
              Label("채팅", image: "대지 8")
            } else {
              Label("", image: "대지 8 사본 4")
            }
          }.tag(2)

          MyPage().tabItem {
            if self.tabSelect == 3 {
              Label("마이", image: "대지 8 사본 2")
            } else {
              Label("", image: "대지 8 사본 6")
            }
          }.tag(3)
        } //tabview
        if self.createRoomSelect {
          CreateRoomView(createRoomSelect: $createRoomSelect, tabSelect: $tabSelect)
            .transition(.move(edge: .bottom))
        }
      } // zstack
      
      .onChange(of: self.tabSelect, perform: { newValue in
        if newValue == 1 {
          withAnimation {
            self.createRoomSelect.toggle()
          }
        } else {
          self.tabSelectTmp = newValue
        }
      })
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          if self.tabSelect == 0 {
            Text("전체")
              .bold()
              .font(.title)
          }
        }
        
        ToolbarItem(placement: .principal) {
          if self.tabSelect == 1 {
            Text("방 만들기")
              .bold()
          } else if self.tabSelect == 2 {
            Text("채팅")
              .bold()
          } else if self.tabSelect == 3 {
          Text("마이 페이지")
              .bold()
          }
        }
        
        
        ToolbarItem(placement: .navigationBarTrailing) {
          if self.tabSelect == 1{
            Button(action: {
              withAnimation {
                self.createRoomSelect.toggle()
              }
              self.tabSelect = self.tabSelectTmp
            }) {
              Text("X")
            }
          }
          else if self.tabSelect == 2 {
            Button("삭제"){
              let realm = try! Realm()
              try! realm.write({
                let a = realm.objects(ChatDB.self)
                realm.delete(a[0])
              })

            }
          }
        }
        
      } //toolbar
      
//    } //navigationview
    .accentColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))

  }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
      TabViews()
    }
}
