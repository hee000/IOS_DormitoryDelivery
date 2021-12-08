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
  @EnvironmentObject var chatdata: ChatData

  
  
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
                    postCreateRoom2(shopName: self.shopName, shopLink: self.shopLink, category: self.category, section: sectionNameEng[self.section], deliveryPriceAtLeast: price, token: mytoken)
                  }
                }
//                print("네비 바꾸기전")
//                print(self.rid)
//                self.isActive = true
//                print(self.rid)
//                print("네비 바꾼 이후")
              }) {
                  Text("만들기")
              }
            NavigationLink(destination: ChattingView(RoomDB: roomidtodbconnect(rid: self.rid), Id_room: self.rid), isActive: $isActive) {EmptyView().hidden()}.hidden()
          }
        }

        Spacer()
      }
      .onChange(of: rid, perform: { newValue in
        print("=====================================")
        print(self.rid)
        self.isActive = true
        isActive = true
        print(newValue)
        print("=====================================")
      })
//      .onTapGesture {
//            self.endTextEditing()
//      }
//      .navigationBarTitle(Text("방 만들기 폼")) //this must be empty
////        .navigationBarHidden(true)
      ///
      .navigationTitle("")
      .navigationBarHidden(true)
    }
  
  
  func postCreateRoom2(shopName: String, shopLink: String, category: String, section: String, deliveryPriceAtLeast: Int, token: String){
    print("방만들기 시도")
    let createkey = createroomdata(shopName: shopName, shopLink: shopLink, category: category, section: section, deliveryPriceAtLeast: deliveryPriceAtLeast)
    let url = createroomposturl
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = (["Authorization": token])
    
    do {
        try request.httpBody = JSONEncoder().encode(createkey)
    } catch {
        print("http Body Error")
    }
    
    AF.request(request).responseJSON { (response) in
      switch response.result {
      case .success(let value):
  //      print("방 생성 성공")
  //      print(value)
  //      print("=======")
        if let id = value as? [String: Any] {
          if let idvalue = id["id"] {
            let chatroomopen = ChatDB()
            if let rid = idvalue as? String {
              chatroomopen.rid = rid
              chatroomopen.title = shopName
              addChatting(chatroomopen)
              self.rid = rid
            }
          }
        }

      case .failure(let error):
          print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
      }
    }
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
