//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI


struct SizeKey: PreferenceKey {
  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = nextValue()
  }
}

struct CreateRoomView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @ObservedObject var createRoomData: CreateRoom = CreateRoom()
  @Environment(\.presentationMode) var presentationMode
  @Binding var tabSelect: Int
  
  
  
    var body: some View {
      NavigationView {
        VStack {
          VStack(alignment: .leading, spacing: 0){
            Text("주문 받을 기숙사를 선택해주세요.")
              .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 20){
                  ForEach( 0  ..< sectionNameEng.count ) { index in
                    Button{
                      self.createRoomData.section = index
                    } label: {
                      HStack(spacing: 3) {
                        Image(systemName: self.createRoomData.section == index ? "largecircle.fill.circle" : "circle")
                        
                        if let sectionh = sectionNameEng[index] {
                          if let sectionNamekor = sectionNameToKor[sectionh] {
                            Text("\(sectionNamekor)관")
                          }
                        }
                      }
                    }
                    .foregroundColor(self.createRoomData.section == index ? Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1) : Color.gray)

                  }
              }
              .frame(maxHeight: .infinity)
            }
            .frame(height: 50)
          }
          .padding()

          VStack(alignment: .leading, spacing: 20) {
            Group{
              HStack{
                Text("방 이름")
                  .bold()
                TextField("방 이름", text: $createRoomData.shopName)
                  .keyboardType(.default)
                  .multilineTextAlignment(.trailing)
              }
            
              Divider()
              
              HStack{
                Text("카테고리")
                  .bold()
                TextField("카테고리", text: $createRoomData.category)
                  .multilineTextAlignment(.trailing)
                  .keyboardType(.default)
              }
              
              Divider()
            
              HStack{
                Text("매장 이름")
                  .bold()
                TextField("매장 이름", text: $createRoomData.shopName)
                  .keyboardType(.default)
                  .multilineTextAlignment(.trailing)
              }
              
              Divider()
            } //첫번쨰그룹
                
              VStack(alignment: .leading) {
                Text("주문 매장 공유하기")
                  .bold()
                ZStack(alignment: .leading){
                  Text(self.createRoomData.shopLink != "" ? self.createRoomData.shopLink : "주문할 매장 URL을 공유해주세요.")
                    .foregroundColor(self.createRoomData.shopLink != "" ? Color.clear : Color.gray)
                    .zIndex(self.createRoomData.shopLink != "" ? 0 : 1)
                    .padding(6)
                    .background(GeometryReader { geo in
                      Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                    }.frame(minHeight: 45))
                    .onPreferenceChange(SizeKey.self) { value in
                      self.createRoomData.height = value
                    }
                  TextEditor(text: $createRoomData.shopLink)
                    .frame(height: self.createRoomData.height)
                    .border(Color.gray.opacity(0.8))
                }
              }
                
              
              Divider()
              
              HStack{
                Text("최소 주문금액")
                  .bold()
                TextField("deliveryPriceAtLeast", text: $createRoomData.deliveryPriceAtLeast)
                  .multilineTextAlignment(.trailing)
                  .keyboardType(.phonePad)
              }
              
              Divider()
          } //v
          .textFieldStyle(PlainTextFieldStyle())
          .padding()
          
          
          Spacer()
          
          Button {
            if let mytoken = naverLogin.loginInstance?.accessToken {
              if let price = Int(createRoomData.deliveryPriceAtLeast) {
                postCreateRoom(createRoomData: createRoomData, section: sectionNameEng[createRoomData.section], deliveryPriceAtLeast: price, token: mytoken)
              }
            }
          } label: {
              Text("만들기")
          }
        } //외곽v
          

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("방 개설하기")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
      } //navi
      .onChange(of: createRoomData.rid, perform: { newValue in
        presentationMode.wrappedValue.dismiss()
        withAnimation {
          self.tabSelect = 2
        }
      })
    } //body
}
