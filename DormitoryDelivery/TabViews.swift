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
  @EnvironmentObject var noti: Noti
  @EnvironmentObject var dormis: dormitoryData
  
  @State var tabSelect = 0
  @State var createRoomSelect = false
  @State var tabSelectTmp = 0
  
  @State var DeliveryViewSection = -1

  var body: some View {
    TabView(selection: $tabSelect){
      DeliveryView(mysection: $DeliveryViewSection, tabSelect: $tabSelect)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
//        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
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

      ChatView()
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
        .tabItem {
        if self.tabSelect == 2 {
          Label("채팅", image: "대지 8")
        } else {
          Label("", image: "대지 8 사본 4")
        }
      }.tag(2)

      MyPage()
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .bottom)
        .tabItem {
        if self.tabSelect == 3 {
          Label("마이", image: "대지 8 사본 2")
        } else {
          Label("", image: "대지 8 사본 6")
        }
      }.tag(3)
    } //tabview
    
    .fullScreenCover(isPresented: $createRoomSelect) {
      CreateRoomView(tabSelect: $tabSelect)
    }
      
    .onChange(of: self.tabSelect, perform: { newValue in
      if newValue == 1 {
        withAnimation {
          self.createRoomSelect.toggle()
          self.tabSelect = self.tabSelectTmp
        }
      } else {
        self.tabSelectTmp = newValue
      }
    })
    
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        HStack(spacing: 0) {
          if self.tabSelect == 0 {
            Menu{
//              ForEach(0 ..< sections.count, id: \.self) { index in
              Button(action: {
                self.DeliveryViewSection = -1
              }) {
                Text("전체")
              }
              ForEach(dormis.data) { dormi in
                Button(action: {
                  self.DeliveryViewSection = dormi.id
                }) {
                  Text(dormi.name)
                }
              }
            } label: {
//              Text(sections[self.DeliveryViewSection])
              Text(self.DeliveryViewSection == -1 ? "전체" : dormis.data[dormis.data.map({ dormitory in
                dormitory.id
              }).index(of: self.DeliveryViewSection)!].name)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
            }
            Image(systemName: "arrowtriangle.down.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 13, height: 10)
              .foregroundColor(.gray)
              .padding(.leading, 2)
          } else if self.tabSelect == 2 {
          } else if self.tabSelect == 3 {
          }
        }
      }
      
      ToolbarItem(placement: .principal) {
          if self.tabSelect == 0 {
          } else if self.tabSelect == 2 {
            Text("채팅")
              .bold()
          } else if self.tabSelect == 3 {
            Text("마이페이지")
              .bold()
          }
      }
      
      
      ToolbarItem(placement: .navigationBarTrailing) {
        if self.tabSelect == 0 {
          HStack{
            NavigationLink(destination: NotificationView(tabSelect: $tabSelect)){
              Image(noti.systemNoti ? "ImageBellOn" : "ImageBellOff")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 22)
            }
          }
        } else if self.tabSelect == 2 {
        } else if self.tabSelect == 3 {
        }
      }
      
    } //toolbar

    .accentColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))

  }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
      TabViews()
    }
}
