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
  var socket: SocketIOClient! = SocketIOManager.shared.socket
  var deliveryZone = ["Narae", "Hoyoen", "Changzo", "Bibong"]
  
  @State var userId: String = ""
  @State var shopName: String = ""
  @State var deliveryPriceAtLeast: String = ""
  @State var shopLink: String = ""
  @State var category: String = ""
  @State var section = 0
  

  func subscribeEmit(){
    
//    var createForm: [String: Any] = [
//        "shopName": self.shopName,
//        "deliveryPriceAtLeast": Int(self.deliveryPriceAtLeast),
//        "shopLink": self.shopLink,
//        "category": self.category,
//        "section": self.deliveryZone[self.section],
//    ] as Dictionary
    
    var createform = createroomdata(shopName: self.shopName,
                                    shopLink: self.shopLink,
                                    category: self.category,
                                    section: self.deliveryZone[self.section],
                                    deliveryPriceAtLeast: Int(self.deliveryPriceAtLeast) ?? 0
                      )
//    socket.emitWithAck("create", createForm).timingOut(after: 2, callback: { (data) in
////              print(data)
//    })
    
  
            let url = createroomposturl
            let headers : [String: String] = [
              "Authorization": UserDefaults.standard.string(forKey: "AccessToken")!
            ] as Dictionary
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 10
//            request.headers = JSONSerialization.data(withJSONObject: headers, options: [])
            // POST 로 보낼 정보
//            let params = ["userId":"qwer", "password":"qwer"] as Dictionary

            // httpBody 에 parameters 추가
     
            do {
              print("인코딩 시작")
                try request.httpBody = JSONEncoder().encode(createform)
                try request.allHTTPHeaderFields = headers
              print("인코딩 성공")
            } catch {
                print("http Body Error")
            }
      
            AF.request(request).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print("POST 성공")
                  print(value)
                  print("=======")
      
//                  do {
//                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//
//                    let session = try JSONDecoder().decode(UserSession.self, from: data)
//  //                  session.sessionId
//
//  //                  uersd.sessionId = session.sessionId
//                  }
//                  catch {
//
//                  }
//                  print(uersd.sessionId)
                
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                }
            }
      
    
    }

  
  
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
                  ForEach( 0  ..< deliveryZone.count ){
                    Text("\(self.deliveryZone[$0])관")
                  }
              }.pickerStyle(SegmentedPickerStyle())
          }
        
          
          Section(header: Text("가격22")){
            TextField("deliveryPriceAtLeast", text: $deliveryPriceAtLeast)
              .keyboardType(.phonePad)
          }
          
          Button(action: {
            subscribeEmit()
          }) {
              Text("만들기")
          }
        }

        Spacer()
      }
//      .onTapGesture {
//            self.endTextEditing()
//      }
      .navigationBarTitle(Text("방 만들기 폼")) //this must be empty
//        .navigationBarHidden(true)
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
