//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import RealmSwift

struct SizeKey: PreferenceKey {
  static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
    value = nextValue()
  }
}

struct CreateRoomView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @ObservedResults(UserPrivacy.self) var userPrivacy
  @ObservedObject var createRoomData: CreateRoom = CreateRoom()
  @EnvironmentObject var keyboardManager: KeyboardManager
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var chatnavi: ChatNavi
  @EnvironmentObject var dormis: dormitoryData
  @Binding var tabSelect: Int
  
  @FocusState private var focusShopLink: Bool
  
  @State var asdasd = ""
  
    var body: some View {
      NavigationView {
        GeometryReader { geo in
          ZStack{
          ScrollView{
        VStack {
          VStack(alignment: .leading, spacing: 0){
            Text("주문 받을 기숙사를 선택해주세요.")
              .font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 20){
                ForEach(dormis.data) { dormi in
                    Button{
                      self.createRoomData.section = dormi.id
                    } label: {
                      HStack(spacing: 3) {
                        Image(systemName: self.createRoomData.section == dormi.id ? "largecircle.fill.circle" : "circle")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 19, height: 19)
                        
                        Text(dormi.name)
                          .font(.system(size: 14, weight: .regular))
//                        if let sectionh = sectionNameEng[index] {
//                          if let sectionNamekor = sectionNameToKor[sectionh] {
//                            Text("\(sectionNamekor)관")
//                              .font(.system(size: 14, weight: .regular))
//                          }
//                        }
                      }
                    }
                    .foregroundColor(self.createRoomData.section == dormi.id ? Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1) : Color.gray)

                  }
              }
              .frame(maxHeight: .infinity)
            }
            .frame(height: 50)
          }
          .padding(.bottom, 30)

          VStack(alignment: .leading, spacing: 35) {
            Group{
              HStack{
                HStack(spacing: 0){
                  Text("* ")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                  Text("방 이름")
                    .font(.system(size: 16, weight: .bold))
                  
                }
                TextField("방 이름을 정해주세요", text: $createRoomData.shopName)
                  .font(.system(size: 16, weight: .regular))
                  .keyboardType(.default)
                  .multilineTextAlignment(.trailing)
                  .disableAutocorrection(true)
                  .autocapitalization(UITextAutocapitalizationType.none)
              }
            
              Divider()
              

                HStack{
                  HStack(spacing: 0){
                    Text("* ")
                      .font(.system(size: 16, weight: .bold))
                      .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                    Text("카테고리")
                      .font(.system(size: 16, weight: .bold))
                  }
                  Spacer()
                  NavigationLink(destination: CategoryView(createRoomData: createRoomData)){
                    Text(self.createRoomData.category != nil ? category[self.createRoomData.category!] : "카테고리를 선택해주세요")
                      .font(.system(size: 16, weight: .regular))
                      .foregroundColor(self.createRoomData.category != nil ? Color.black : Color.gray.opacity(0.5))

                    Image(systemName: "chevron.right")
                      .font(.system(size: 16, weight: .regular))

                  }
                }
                .foregroundColor(.black)
              
              Divider()
            
//              HStack{
//                HStack(spacing: 0){
//                  Text("* ")
//                    .font(.system(size: 16, weight: .bold))
//                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
//                  Text("메뉴")
//                    .font(.system(size: 16, weight: .bold))
//                }
//                TextField("메뉴를 작성해주세요.", text: $createRoomData.shopName)
//                  .font(.system(size: 16, weight: .regular))
//                  .keyboardType(.default)
//                  .multilineTextAlignment(.trailing)
//              }
//              
//              Divider()
            } //첫번쨰그룹
                
              VStack(alignment: .leading) {
                HStack(spacing: 0){
                  Text("* ")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                  Text("주문 매장 공유하기")
                    .font(.system(size: 16, weight: .bold))
                }
//                ZStack(alignment: .leading){
//                  Text(self.createRoomData.shopLink != "" ? self.createRoomData.shopLink : "주문할 매장 URL을 공유해주세요. 외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요.")
//                    .font(.system(size: 16, weight: .regular))
//                    .padding([.top, .leading])
//                    .frame(maxWidth: .infinity, minHeight: 45, alignment: .topLeading)
//                    .onTapGesture {
//                      self.focusShopLink.toggle()
//                    }
//                    .foregroundColor(self.createRoomData.shopLink != "" ? Color.clear : Color.gray)
//                    .zIndex(self.createRoomData.shopLink != "" ? 0 : 1)
//                    .background(GeometryReader { geo in
//                      Color.clear.preference(key: SizeKey.self, value: geo.size.height)
//                    }.frame(minHeight: 45))
//                    .onPreferenceChange(SizeKey.self) { value in
//                      self.createRoomData.height = value
//                    }
//                  TextEditor(text: $createRoomData.shopLink)
//                    .font(.system(size: 16, weight: .regular))
//                    .focused($focusShopLink)
//                    .frame(height: self.createRoomData.height)
//                    .padding([.top, .leading])
//                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1))
//                }.frame(maxHeight: 200)
                

                TextEditor(text: $createRoomData.shopLink)
                  .font(.system(size: 16, weight: .regular))
                  .focused($focusShopLink)
                  .frame(height: 85)
                  .foregroundColor(focusShopLink == false && createRoomData.shopLink == "주문할 매장 URL을 공유해주세요. \n외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요." ? Color.gray : Color.black)
                  .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1))
                  .onChange(of: focusShopLink) { V in
                    if V {
                      if createRoomData.shopLink == "주문할 매장 URL을 공유해주세요. \n외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요." {
                        createRoomData.shopLink = ""
                      }
                    } else {
                      if createRoomData.shopLink == "" {
                        createRoomData.shopLink = "주문할 매장 URL을 공유해주세요. \n외부 배달앱에서 매장 링크 공유하기를 눌러 클립보드로 복사해주세요."
                      }
                    }
                  }

                HStack{
                  HStack(spacing: 0){
                    Text("* ")
                      .font(.system(size: 16, weight: .bold))
                      .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                    Text("최소 주문금액")
                      .font(.system(size: 16, weight: .bold))
                  }
                  TextField("금액", text: $createRoomData.deliveryPriceAtLeast)
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                  Text("원")
                    .font(.system(size: 16, weight: .bold))
                }
                .padding(.top, 30)
              }
                
              Divider()
            
            Spacer()
              .frame(height: 60)
          } //v
          .textFieldStyle(PlainTextFieldStyle())
          
        } //외곽v
        .padding()
        .padding([.leading, .trailing])

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("방 개설하기")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
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
                if createRoomData.validcheck() {
                  if let price = Int(createRoomData.deliveryPriceAtLeast) {
                    postCreateRoom(createRoomData: createRoomData, section: self.createRoomData.section!, deliveryPriceAtLeast: price, navi: chatnavi)
                  }
                } else {
                  withAnimation {
                    self.createRoomData.postalertstate = true
                  }
                }
              } label: {
                  Text("등록 완료")
                  .foregroundColor(.white)
                  .font(.system(size: 16, weight: .bold))
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
      
      .overlay(self.userPrivacy.first!.mainAccount == nil ? AlertOneButton(isActivity: $createRoomData.isAccount) { Text("마이 페이지에서").font(.system(size: 16, weight: .regular))
        Text("계좌 등록을 먼저 진행해주세요").font(.system(size: 16, weight: .regular)) } : nil)
      
      .overlay(self.createRoomData.postalertstate ? AlertOneButton(isActivity: $createRoomData.postalertstate) { Text("항목을 올바르게 기입해주세요").font(.system(size: 16, weight: .regular)) } : nil)
      
      .overlay(self.createRoomData.isInvalidCreateRoom ? AlertOneButton(isActivity: $createRoomData.isInvalidCreateRoom) { Text(self.createRoomData.invalidCreateRoomText).font(.system(size: 16, weight: .regular)) } : nil)
      
      .onChange(of: createRoomData.isAccount, perform: { newValue in
        presentationMode.wrappedValue.dismiss()
      })
      
      .onChange(of: createRoomData.rid, perform: { newValue in
        presentationMode.wrappedValue.dismiss()
        self.tabSelect = 2
      })
    } //body
}
