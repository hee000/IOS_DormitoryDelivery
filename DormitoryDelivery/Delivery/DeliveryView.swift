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
  @EnvironmentObject var naverLogin: NaverLogin
  @State var isRoomLinkActive = false
  
    
  @State var flagAll = true
  @State var flags = Array(repeating: false, count: category.count)
  
  @Binding var mysection: Int
  

    var body: some View {
      GeometryReader { geo in
        VStack(alignment: .leading, spacing: 0) {
          ScrollView(.horizontal, showsIndicators: false){
            HStack{ // 해시태그
              Button {
                if !self.flagAll {
                  withAnimation(Animation.default.speed(5)) {
                    self.flagAll.toggle()
                  }
                }
              } label: {
                Text("전체")
                  .fontWeight(.black)
                  .foregroundColor(self.flagAll ? Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1) : Color.gray)
                  .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                  .overlay(RoundedRectangle(cornerRadius: 21).stroke(self.flagAll ? Color(.sRGB, red: 93/255, green: 95/255, blue: 235/255, opacity: 1) : Color.gray, lineWidth: 1.5))
              }
              ForEach(category.indices, id: \.self) { index in
                HashTag(flag: $flags, tag: index)
              }
            }
            .frame(maxHeight: .infinity)
            .padding(.leading)
          }.frame(height: 50)
            .padding(.bottom)
          
          if rooms.data == nil || rooms.data!.data.count == 0 {
            VStack{
              Spacer()
              Text("활성화된 배달방이 없어요.")
                .bold()
                .font(.title)
                .padding()
              Text("배달방을 개설 해보세요!")
              Spacer()
              Spacer()
            }
            .frame(width: geo.size.width)
            .transition(AnyTransition.opacity.animation(Animation.easeInOut.speed(5)))
          } else { // 매치목록
            ScrollView {
              VStack(alignment: .center, spacing:3) {
                ForEach(Array(zip(rooms.data!.data.indices, rooms.data!.data)), id: \.1) { index, item in
//                ForEach(rooms.data!.data.indices, id: \.self) { index in
                  NavigationLink(destination: RoomDetailView(roomdata: rooms.data!.data[index])) {
              RoomCard(deliveryTitle: rooms.data!.data[index].shopName,
                       deliveryZone: rooms.data!.data[index].section,
                           deliveryPayTip: rooms.data!.data[index].priceAtLeast,
                           deliveryPayTotal: rooms.data!.data[index].total,
                           deliveryId: rooms.data!.data[index].id,
                           purchaserName: rooms.data!.data[index].purchaserName,
                           createdAt: rooms.data!.data[index].createdAt )
                    }
                } //for
              } //v
            } //scroll
            .transition(AnyTransition.opacity.animation(Animation.easeInOut.speed(5)))

          } // if

    

        } // V
      }//geo
      .onChange(of: flagAll, perform: { V in
        if V {
          self.flags = flags.map { $0 && false }
        }
      })
      .onChange(of: flags) { newValue in
        if newValue.reduce(false, {$0 || $1}) {
          if self.flagAll {
            self.flagAll.toggle()
          }
          let categorydata = categoryMapping(flags: newValue)
          var categorykor : [String] = []
          for i in categorydata.indices{
            categorykor.append(categoryNameToEng[categorydata[i]]!)
          }
          SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: ["Bibong"], category: categorykor)
        } else {
          if !self.flagAll {
            self.flagAll.toggle()
          }
          SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: ["Bibong"], category: categoryNameEng)
        }
        print(flags)
      }
//      .onAppear {
//        if let mytoken = naverLogin.loginInstance?.accessToken {
//          SocketIOManager.shared.establishConnection(token: mytoken)
//          SocketIOManager.shared.matchSocket.on("connect") { data, ack in
//            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: sectionNameEng, category: categoryNameEng)
//            SocketIOManager.shared.match_onArrive(rooms: rooms)
//            SocketIOManager.shared.room_onChat()
//          }
//
//          matchSocket.on("connect") { data, ack in
//            SocketIOManager.shared.match_emitSubscribe(rooms: roomdata, section: sectionNameEng, category: categoryNameEng)
//            SocketIOManager.shared.match_onArrive(rooms: roomdata)
//          }
//          roomSocket.on("connect") { data, ack in
//            SocketIOManager.shared.room_onChat()
//          }
//        }
//      }
      
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
