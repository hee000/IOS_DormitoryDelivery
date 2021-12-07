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
  
  
  
  let category = ["한식", "중식", "일식", "양식", "돼지고기", "치킨", "피자", "떡", "페스트푸드"]
  let sections = ["전체", "창조", "나래", "호연", "비봉"]
  
  @State var mysection = "전체"
  
    var body: some View {
        VStack{
          VStack(alignment: .leading){
            HStack() {

              Menu(self.mysection) {
                ForEach(0 ..< sections.count, id: \.self) { index in
                  Button(action: {
                    self.mysection = sections[index]
                  }) {
                    Text(sections[index])
                  }

                }
              }
              .font(.system(size: 21))
              .foregroundColor(Color.black)
              .padding(.leading)
              .padding(.top)
                
              
              
              Spacer()
              
              Label("돋보기", systemImage: "magnifyingglass")
                  .labelStyle(.iconOnly)
                  .foregroundColor(Color.gray)
                  .font(.title)
              Label("종", systemImage: "bell")
                  .font(.title)
                  .labelStyle(.iconOnly)
                  .foregroundColor(Color.gray)
                  .padding(.trailing)
            }.frame(height: 60)

          }
          
          Divider()
          Spacer()

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
//            NavigationLink(destination: CreateRoom(), isActive: $isRoomLinkActive) {
//                Button(action: {
//                    self.isRoomLinkActive = true
//                }) {
//                    Text("방만들기")
//                }
//            }
//            .padding(.trailing)
          }
          .font(.title2)
//          .padding(.leading)
//
//          Spacer()
//            .frame(height: 15)
          
          if selectedTab == .FirstTab {
              VStack(alignment: .leading){
                ScrollView(.horizontal){
                  HStack{
                    ForEach(category.indices, id: \.self) { index in
                      Text(category[index])
//                        .padding(8)
                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                        .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color(.sRGB, red: 93/255, green: 95/255, blue: 235/255, opacity: 1), lineWidth: 1.5))
                      
    //                Text("해시 태그 위치")
    //                  .bold()
    //                  .padding(.leading)
                    }
                  }
                  .frame(maxHeight: .infinity)
                  .padding(.leading)
                }.frame(height: 50)
//                  .padding(.leading)
                
                if (rooms.data != nil) {
                  ScrollView(){
                    VStack(spacing: 2) {
                      ForEach(rooms.data!.data.indices, id: \.self) { index in
                    RoomCard(deliveryTitle: rooms.data!.data[index].shopName,
                             deliveryZone: rooms.data!.data[index].section,
                                 deliveryPayTip: rooms.data!.data[index].priceAtLeast,
                                 deliveryPayTotal: rooms.data!.data[index].total,
                                 deliveryId: rooms.data!.data[index].id,
                                 purchaserName: rooms.data!.data[index].purchaserName,
                                 createdAt: rooms.data!.data[index].createdAt
                    )
                  }
                    }
                    
                  }
                  
                }
                Spacer()
              }
          
          } else if selectedTab == .SecondTab {
            VStack{
              Spacer()
              Text("공동구매")
              Spacer()
            }
          } else {
            VStack{
              Spacer()
              Text("공동구매")
              Spacer()
            }
          }
        
          

        
      }
      .navigationBarTitle("") //this must be empty
      .navigationBarHidden(true)
      
      .onAppear {
        if let mytoken = naverLogin.loginInstance?.accessToken {
          SocketIOManager.shared.establishConnection(token: mytoken)
        }
                

        DispatchQueue.global(qos: .default).async {
           while true {
              DispatchQueue.main.async {
                if SocketIOManager.shared.socket.status == SocketIOStatus.connected {
                  print(SocketIOStatus.connected)
                  SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: ["Nare", "Bibong"], category: ["korean"])
                  SocketIOManager.shared.match_onArrive(rooms: rooms)
                  SocketIOManager.shared.room_onChat()
                  
                }
              }
             if SocketIOManager.shared.socket.status == SocketIOStatus.connected {
                break
              }
              sleep(1)
           }
        }
        
      }
     
      //뷰끝
    }
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
    case ThirdTab
}
