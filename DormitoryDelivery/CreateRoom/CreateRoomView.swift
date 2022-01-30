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
  @EnvironmentObject var keyboardManager: KeyboardManager
  @Environment(\.presentationMode) var presentationMode
  @Binding var tabSelect: Int
  
  @FocusState private var focusShopLink: Bool
  
  
  
    var body: some View {
      NavigationView {
        GeometryReader { geo in
          ZStack{

          ScrollView{
        VStack {
          VStack(alignment: .leading, spacing: 0){
            Text("주문 받을 기숙사를 선택해주세요.")
              .bold()
              .font(.title3)
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 20){
                  ForEach( 0  ..< sectionNameEng.count ) { index in
                    Button{
                      self.createRoomData.section = index
                    } label: {
                      HStack(spacing: 3) {
                        Image(systemName: self.createRoomData.section == index ? "largecircle.fill.circle" : "circle")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 19, height: 19)
                        
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
          .padding([.top, .bottom], 30)

          VStack(alignment: .leading, spacing: 35) {
            Group{
              HStack{
                HStack(spacing: 0){
                  Text("* ")
                    .bold()
                    .font(.title3)
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                  Text("방 이름")
                    .bold()
                    .font(.title3)
                }
                TextField("방 이름을 정해주세요", text: $createRoomData.shopName)
                  .keyboardType(.default)
                  .multilineTextAlignment(.trailing)
              }
            
              Divider()
              

                HStack{
                  HStack(spacing: 0){
                    Text("* ")
                      .bold()
                      .font(.title3)
                      .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                    Text("카테고리")
                      .bold()
                      .font(.title3)
                  }
                  Spacer()
                  NavigationLink(destination: CategoryView(createRoomData: createRoomData)){
                    Text(self.createRoomData.category != nil ? category[self.createRoomData.category!] : "카테고리를 선택해주세요")
                      .foregroundColor(self.createRoomData.category != nil ? Color.black : Color.gray)

                    Image(systemName: "chevron.right")
                  }
                }
                .foregroundColor(.black)
              
              Divider()
            
              HStack{
                HStack(spacing: 0){
                  Text("* ")
                    .bold()
                    .font(.title3)
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                  Text("메뉴")
                    .bold()
                    .font(.title3)
                }
                TextField("메뉴를 작성해주세요.", text: $createRoomData.shopName)
                  .keyboardType(.default)
                  .multilineTextAlignment(.trailing)
              }
              
              Divider()
            } //첫번쨰그룹
                
              VStack(alignment: .leading) {
                HStack(spacing: 0){
                  Text("* ")
                    .bold()
                    .font(.title3)
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                  Text("주문 매장 공유하기")
                    .bold()
                    .font(.title3)
                }
                ZStack(alignment: .leading){
                  Text(self.createRoomData.shopLink != "" ? self.createRoomData.shopLink : "주문할 매장 URL을 공유해주세요.")
                    .padding([.top, .leading])
                    .frame(maxWidth: .infinity, minHeight: 45, alignment: .topLeading)
                    .onTapGesture {
                      self.focusShopLink.toggle()
                    }
                    .foregroundColor(self.createRoomData.shopLink != "" ? Color.clear : Color.gray)
                    .zIndex(self.createRoomData.shopLink != "" ? 0 : 1)
                    .background(GeometryReader { geo in
                      Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                    }.frame(minHeight: 45))
                    .onPreferenceChange(SizeKey.self) { value in
                      self.createRoomData.height = value
                    }
                  TextEditor(text: $createRoomData.shopLink)
                    .focused($focusShopLink)
                    .frame(height: self.createRoomData.height)
                    .padding([.top, .leading])
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1))
                }.frame(maxHeight: 200)
                
                HStack{
                  HStack(spacing: 0){
                    Text("* ")
                      .bold()
                      .font(.title3)
                      .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                    Text("최소 주문금액")
                      .bold()
                      .font(.title3)
                  }
                  TextField("금액", text: $createRoomData.deliveryPriceAtLeast)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.phonePad)
                  Text("원")
                    .bold()
                }
                .padding(.top, 30)
              }
                
              Divider()
          } //v
          .textFieldStyle(PlainTextFieldStyle())
          
        } //외곽v
        .padding()
        .padding([.leading, .trailing])

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("방 개설하기")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.black)
            }
          }
        }
          } //scroll
          .onTapGesture {
              hideKeyboard()
          }


            VStack{
              Spacer()
              Button {
                if let mytoken = naverLogin.loginInstance?.accessToken {
                  if let price = Int(createRoomData.deliveryPriceAtLeast) {
                    postCreateRoom(createRoomData: createRoomData, section: sectionNameEng[createRoomData.section], deliveryPriceAtLeast: price, token: mytoken)
                  }
                }
              } label: {
                  Text("등록 완료")
                  .foregroundColor(.white)
                  .bold()
                  .font(.title3)
                  .frame(maxWidth: .infinity)
              }
              .frame(height: 60, alignment: .center)
              .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
              .cornerRadius(5)
              .padding([.bottom,  .leading, .trailing])
              .padding([.leading, .trailing])
            }
            .ignoresSafeArea(.keyboard)
          }//z
        } //geo
        .clipped()
      } //navi
      .onChange(of: createRoomData.rid, perform: { newValue in
        presentationMode.wrappedValue.dismiss()
        withAnimation {
          self.tabSelect = 2
        }
      })
    } //body
}
