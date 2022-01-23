//
//  Delivery.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import SocketIO
import Foundation
import RealmSwift

struct DeliveryView: View {
  
  @EnvironmentObject var rooms: RoomData
  @EnvironmentObject var chatlist: ChatData
  @EnvironmentObject var naverLogin: NaverLogin
  @State var isRoomLinkActive = false
  @State var selectedTab = Tabs.FirstTab
  
  
  @State var flags = Array(repeating: false, count: category.count)
  @State var mysection = "전체"
  

    var body: some View {
        VStack{
          
          VStack(alignment: .leading){

          HStack{
            
            VStack(alignment: .center, spacing: 2) {
              Text("배달")
                .font(.system(size: 18))
                .bold()
  //              .fontWeight(selectedTab == .FirstTab ? .bold : .regular)
                .foregroundColor(selectedTab == .FirstTab ? Color.black : Color.gray)
                .onTapGesture {
                    self.selectedTab = .FirstTab
                }
            
              Rectangle()
                .fill(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                .frame(width: 20, height: 2)
                .opacity(selectedTab == .FirstTab ? 1 : 0)
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 20, leading: 25, bottom: 15, trailing: 0))
            
            
            
            VStack(alignment: .center, spacing: 2) {
              Text("공동구매")
                .font(.system(size: 18))
                .bold()
  //              .fontWeight(selectedTab == .SecondTab ? .bold : .regular)
                .foregroundColor(selectedTab == .SecondTab ? Color.black : Color.gray)
                .onTapGesture {
                    self.selectedTab = .SecondTab
                }
              Rectangle()
                .fill(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                .frame(width: 40, height: 2)
                .opacity(selectedTab == .SecondTab ? 1 : 0)
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 15, trailing: 0))

            
            Spacer()
          }
          .font(.title2)

          
          if selectedTab == .FirstTab {
              VStack(alignment: .leading){
                ScrollView(.horizontal){
                  HStack{ // 해시태그
                    ForEach(category.indices, id: \.self) { index in
                      HashTag(flag: $flags, tag: index)
                    }
                  }
                  .frame(maxHeight: .infinity)
                  .padding(.leading)
                }.frame(height: 50)
//                  .padding(.leading)
                
                if (rooms.data != nil) { // 매치목록
                  ScrollView(){
                    VStack(spacing: 2) {
                      ForEach(rooms.data!.data.indices, id: \.self) { index in
                        NavigationLink(destination: RoomDetailView(roomdata: rooms.data!.data[index])) {
                    RoomCard(deliveryTitle: rooms.data!.data[index].shopName,
                             deliveryZone: rooms.data!.data[index].section,
                                 deliveryPayTip: rooms.data!.data[index].priceAtLeast,
                                 deliveryPayTotal: rooms.data!.data[index].total,
                                 deliveryId: rooms.data!.data[index].id,
                                 purchaserName: rooms.data!.data[index].purchaserName,
                                 createdAt: rooms.data!.data[index].createdAt )
              }
                      
                    }
                    }
                  }
                }
                Spacer()
              }
          } else {
            VStack{
              Spacer()
              Text("공동구매를 준비중입니다 죄송합니다!")
              Spacer()
            }
          }
        
          

        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
          ToolbarItem(placement: .principal) {
              HStack {
                Menu(self.mysection) {
                                ForEach(0 ..< sections.count, id: \.self) { index in
                                  Button(action: {
                                    self.mysection = sections[index]
                                  }) {
                                    Text(sections[index])
                                  }
                
                                }
                              }
                Spacer()
                Button {
                  print("gkgk")
                } label: {
                  Text("버튼")
                }
              }}}

    
      
      
      .onChange(of: flags) { newValue in
        var categorydata = categoryMapping(flags: newValue)
        var categorykor : [String] = []
        for i in categorydata.indices{
          categorykor.append(categoryNameToEng[categorydata[i]]!)
        }
        SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: ["Bibong"], category: categorykor)
        
      }
      .onAppear {
        if let mytoken = naverLogin.loginInstance?.accessToken {
          SocketIOManager.shared.establishConnection(token: mytoken)
          SocketIOManager.shared.socket.on("connect") { data, ack in
            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: sections, category: category)
            SocketIOManager.shared.match_onArrive(rooms: rooms)
            SocketIOManager.shared.room_onChat()
          }
        }
        
      }
    }
}

func categoryMapping(flags: [Bool]) -> [String] {
  var mapping: [String] = []
  for index in flags.indices {
    if flags[index] {
      mapping.append(category[index])
    }
  }
  return mapping
}

struct Delivery_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        DeliveryView()
      }
    }
}


enum Tabs {
    case FirstTab
    case SecondTab
}
