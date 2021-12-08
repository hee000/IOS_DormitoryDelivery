//
//  CreateRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import SocketIO
import Alamofire

struct CreateRoomView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  
  
  var socket: SocketIOClient! = SocketIOManager.shared.socket

  @State var isActive = false
  @State var userId: String = "sadasd"
  @State var shopName: String = "asdasd"
  @State var deliveryPriceAtLeast: String = "133"
  @State var shopLink: String = "123123"
  @State var category: String = "korean"
  @State var section = 0
  
  @State var rid = ""
  

    var body: some View {
      
      VStack{
//        Text("방 만들기 폼").frame(height: 50)
//        Divider()
        Spacer()
        
        Form{
          Section(header: Text("가게이름")){
            TextField("가게이름", text: $shopName)
              .keyboardType(.default)
          }
          
          Section(header: Text("shopLink")){
            TextField("shopLink", text: $shopLink)
              .keyboardType(.default)
          }
        
          Section(header: Text("카테고리")){
            TextField("카테고리", text: $category)
              .keyboardType(.default)
          }

          Section(header: Text("배달지역")){
              Picker("배달존",selection: $section){
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
            TextField("deliveryPriceAtLeast", text: $deliveryPriceAtLeast)
              .keyboardType(.phonePad)
          }
          
          ZStack{
              Button(action: {
                if let mytoken = naverLogin.loginInstance?.accessToken {
                  if let price = Int(self.deliveryPriceAtLeast) {
                    self.rid = postCreateRoom(shopName: self.shopName, shopLink: self.shopLink, category: self.category, section: sectionNameEng[self.section], deliveryPriceAtLeast: price, token: mytoken)
                  }
                }
                self.isActive = true
    
              }) {
                  Text("만들기")
              }
            NavigationLink(destination: ChattingView(Id_room: self.rid), isActive: $isActive) {EmptyView().hidden()}.hidden()
          }
        }

        Spacer()
      }
//      .onTapGesture {
//            self.endTextEditing()
//      }
//      .navigationBarTitle(Text("방 만들기 폼")) //this must be empty
////        .navigationBarHidden(true)
      ///
      .navigationTitle("")
      .navigationBarHidden(true)
    }
}

//extension CreateRoom {
//  func endTextEditing() {
//    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
//                                    to: nil, from: nil, for: nil)
//  }
//}

struct CreateRoom_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
    }
}
