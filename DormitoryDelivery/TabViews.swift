//
//  Home.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/15.
//

import SwiftUI
import RealmSwift

class Tab: ObservableObject {
  @Published var tabSelect = 0
  @Published var createRoomSelect = false
  @Published var tabSelectTmp = 0
  @Published var DeliveryViewSection = -1
}

struct TabViews: View {
//  @EnvironmentObject var chatdata: ChatData
//  @EnvironmentObject var noti: Noti
//  @EnvironmentObject var dormis: dormitoryData
  
  @StateObject var model = Tab()
//  @State var tabSelect = 0
//  @State var createRoomSelect = false
//  @State var tabSelectTmp = 0
//
//  @State var DeliveryViewSection = -1

  var body: some View {
    TabView(selection: $model.tabSelect){
      DeliveryView(mysection: $model.DeliveryViewSection, tabSelect: $model.tabSelect)

        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
//        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
//      }
        .tabItem {
          if self.model.tabSelect == 0 {
          Label("홈", image: "Tab_home")
        } else {
          Label("홈", image: "Tabn_home")
        }
      }
      .tag(0)
      
      Text("").tabItem {
        if self.model.tabSelect == 1 {
          Label("개설", image: "Tab_create")
        } else {
          Label("개설", image: "Tabn_create")
        }
      }.tag(1)

      ChatView()
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
        .tabItem {
          if self.model.tabSelect == 2 {
          Label("채팅", image: "Tab_chat")
        } else {
          Label("채팅", image: "Tabn_chat")
        }
      }.tag(2)

      MyPage()
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
        .tabItem {
          if self.model.tabSelect == 3 {
          Label("마이페이지", image: "Tab_my")
        } else {
          Label("마이페이지", image: "Tabn_my")
        }
      }.tag(3)
    } //tabview
    
    .fullScreenCover(isPresented: $model.createRoomSelect) {
      CreateRoomView(tabSelect: $model.tabSelect)
    }
      
    .onChange(of: self.model.tabSelect, perform: { newValue in
      if newValue == 1 {
        withAnimation {
          self.model.createRoomSelect.toggle()
          self.model.tabSelect = self.model.tabSelectTmp
        }
      } else {
        self.model.tabSelectTmp = newValue
      }
    })
    
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        HStack(spacing: 0) {
          if self.model.tabSelect == 0 {
//            Menu{
////              ForEach(0 ..< sections.count, id: \.self) { index in
//              Button(action: {
//                self.model.DeliveryViewSection = -1
//              }) {
//                Text("전체")
//              }
//              ForEach(dormis.data) { dormi in
//                Button(action: {
//                  self.model.DeliveryViewSection = dormi.id
//                }) {
//                  Text(dormi.name)
//                }
//              }
//            } label: {
////              Text(sections[self.DeliveryViewSection])
//              Text(self.model.DeliveryViewSection == -1 ? "전체" : dormis.data[dormis.data.map({ dormitory in
//                dormitory.id
//              }).index(of: self.model.DeliveryViewSection)!].name)
//                .font(.title2)
//                .bold()
//                .foregroundColor(.black)
//            }
//            Image(systemName: "arrowtriangle.down.fill")
//              .resizable()
//              .scaledToFit()
//              .frame(width: 13, height: 10)
//              .foregroundColor(.gray)
//              .padding(.leading, 2)
          } else if self.model.tabSelect == 2 {
          } else if self.model.tabSelect == 3 {
          }
        }
      }

      ToolbarItem(placement: .principal) {
        if self.model.tabSelect == 0 {
        } else if self.model.tabSelect == 2 {
            Text("채팅")
              .bold()
        } else if self.model.tabSelect == 3 {
            Text("마이페이지")
              .bold()
          }
      }


      ToolbarItem(placement: .navigationBarTrailing) {
        if self.model.tabSelect == 0 {
//          HStack{
//            NavigationLink(destination: NotificationView(tabSelect: $model.tabSelect)){
//              Image(noti.systemNoti ? "ImageBellOn" : "ImageBellOff")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 21, height: 22)
//            }
//          }
        } else if self.model.tabSelect == 2 {
        } else if self.model.tabSelect == 3 {
        }
      }

    } //toolbar
  }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
      TabViews()
    }
}
