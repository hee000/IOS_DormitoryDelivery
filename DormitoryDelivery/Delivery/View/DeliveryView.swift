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
import JWTDecode

struct DeliveryView: View {
  
  @EnvironmentObject var rooms: RoomData
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var dormis: dormitoryData
//  @EnvironmentObject var noti: Noti
  @State var isRoomLinkActive = false
  
    
  @State var flagAll = true
  @State var flags = Array(repeating: false, count: category.count)
  
  @Binding var mysection: Int
  @Binding var tabSelect: Int
  

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
                  .font(.system(size: 12, weight: .bold))
                  .foregroundColor(self.flagAll ? Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1) : Color.gray)
                  .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                  .overlay(RoundedRectangle(cornerRadius: 21).stroke(self.flagAll ? Color(.sRGB, red: 93/255, green: 95/255, blue: 235/255, opacity: 1) : Color.gray, lineWidth: 1.5))
              }
              ForEach(category.indices, id: \.self) { index in
                HashTag(flag: $flags, tag: index)
              }
            }
            .frame(maxHeight: .infinity)
          }
          .frame(height: 50)
          .padding([.leading, .trailing], 5)
          
          if rooms.data == nil || rooms.data!.data.count == 0 {
            VStack{
              Spacer()
              Image("ImageNil")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
              Text("등록된 배달방이 없습니다.")
                .font(.system(size: 22, weight: .bold))
                .padding()
              Text("새로운 배달방을 만들어보세요!")
                .font(.system(size: 15, weight: .regular))
              Spacer()
            }
            .frame(width: geo.size.width)
            .transition(AnyTransition.opacity.animation(Animation.easeInOut.speed(5)))
          } else { // 매치목록
            ScrollView {
              VStack(alignment: .center, spacing:3) {
//                ForEach(Array(zip(rooms.data!.data.indices, rooms.data!.data)), id: \.1) { index, item in
//                ForEach(rooms.data!.data.indices, id: \.self) { index in
                ForEach(rooms.data!.data, id:\.id) { room in
                  NavigationLink(destination: RoomDetailView(detaildata: RoomDetailData(room: room), tabSelect: $tabSelect)) {
              RoomCard(deliveryTitle: room.shopName,
                       deliveryZone: room.section,
                           deliveryPayTip: room.priceAtLeast,
                           deliveryPayTotal: room.total,
                           deliveryId: room.id,
                           purchaserName: room.purchaserName,
                           createdAt: room.createdAt )
                    }
                  .transition(AnyTransition.opacity.animation(Animation.easeInOut))
                } //for
              } //v
            } //scroll
            .clipped()
            .transition(AnyTransition.opacity.animation(Animation.easeInOut.speed(5)))

          } // if

    

        } // V
      }//geo
      .clipped()
      .onAppear{
        let tk = TokenUtils()
        guard let token = tk.read(),
              let jwt = try? decode(jwt: token),
              let json = try? JSONSerialization.data(withJSONObject: jwt.body, options: .prettyPrinted),
              let jwtdata = try? JSONDecoder().decode(jwtdata.self, from:  json) else { return }
          
//        getUniversityDormitory(dormitoryId: String(jwtdata.univId), model: dormis)
      }
      .onChange(of: mysection, perform: { newValue in
        flagAll = true
        if newValue == -1 {
          SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: dormis.data.map({ dormitory in
            dormitory.id
          }), category: categoryNameEng)
        } else {
          SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: [mysection], category: categoryNameEng)
        }
      })
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
          if mysection == -1 {
            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: dormis.data.map({ dormitory in
              dormitory.id
            }), category: categorykor)
          } else {
            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: [mysection], category: categorykor)
          }
        } else {
          if !self.flagAll {
            self.flagAll.toggle()
          }
          if mysection == -1 {
            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: dormis.data.map({ dormitory in
              dormitory.id
            }), category: categoryNameEng)
          } else {
            SocketIOManager.shared.match_emitSubscribe(rooms: rooms, section: [mysection], category: categoryNameEng)
          }
        }
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
