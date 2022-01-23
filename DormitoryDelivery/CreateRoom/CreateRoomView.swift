//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI

struct CreateRoomView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @Binding var createRoomSelect: Bool
  @Binding var tabSelect: Int
  @ObservedObject var createRoomData: CreateRoom = CreateRoom()
  
    var body: some View {
      
      VStack{
        Form{
          Section(header: Text("가게이름")){
            TextField("가게이름", text: $createRoomData.shopName)
              .keyboardType(.default)
          }
          
          Section(header: Text("shopLink")){
            TextField("shopLink", text: $createRoomData.shopLink)
              .keyboardType(.default)
          }
        
          Section(header: Text("카테고리")){
            TextField("카테고리", text: $createRoomData.category)
              .keyboardType(.default)
          }

          Section(header: Text("배달지역")){
            Picker("배달존",selection: $createRoomData.section){
//                ForEach(self.deliveryZone, id: \.self) { index in
                  ForEach( 0  ..< sectionNameEng.count ){
                    
                    if let sectionh = sectionNameEng[$0] {
                      if let sectionNamekor = sectionNameToKor[sectionh] {
                        Text("\(sectionNamekor)")
                      }
                    }
                    
                  }
              }.pickerStyle(SegmentedPickerStyle())
          }
        
          Section(header: Text("가격22")){
            TextField("deliveryPriceAtLeast", text: $createRoomData.deliveryPriceAtLeast)
              .keyboardType(.phonePad)
          }
          
          
          ZStack{
              Button(action: {
                if let mytoken = naverLogin.loginInstance?.accessToken {
                  if let price = Int(createRoomData.deliveryPriceAtLeast) {
                    postCreateRoom(createRoomData: createRoomData, section: sectionNameEng[createRoomData.section], deliveryPriceAtLeast: price, token: mytoken)
                  }
                }
              }) {
                  Text("만들기")
              }
            NavigationLink(destination: ChattingView(RoomDB: roomidtodbconnect(rid: createRoomData.rid), Id_room: createRoomData.rid), isActive: $createRoomData.isActive) {EmptyView().hidden()}.hidden()
          }
        } //form
      } //vstack
      .onChange(of: createRoomData.rid, perform: { newValue in
        createRoomData.isActive = true
        self.createRoomSelect = false
        self.tabSelect = 2
      })
    } //body
}
