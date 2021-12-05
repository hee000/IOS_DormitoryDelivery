//
//  Delivery.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import SocketIO

struct Delivery: View {
  @State var isRoomLinkActive = false
  @State var selectedTab = Tabs.FirstTab
  var socket: SocketIOClient! = SocketIOManager.shared.socket
  @State var test: TTest!
  
  let category = ["한식", "중식", "일식", "양식", "돼지고기", "치킨", "피자", "떡", "페스트푸드"]
  
  func subscribeEmit(){
    
    let subscribeForm: [String: Any] = [
        "userId": "qwer",
        "category": "korean",
    ] as Dictionary
    
    
    print("구독시작")
    socket.emitWithAck("subscribe", subscribeForm).timingOut(after: 2, callback: { (data) in
//        print(data[0])
      do {
        let data2 = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
//          print(String(data: data2, encoding: .utf8)!)
        let session = try JSONDecoder().decode(TTest.self, from: data2)
        self.test = session
//        print(session.data[0])
//        print(session.data[1])
      }
      catch {
        print(error)
      }
    })
    
  }

func newArriveOn(){
  print("On 시작")
  
    socket.on("new-arrive") { (dataArray, ack) in
      do {
        var data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
        let session = try JSONDecoder().decode(TTTest.self, from: data)
        self.test.data.append(session)
      }
      catch {
        print(error)
      }
    }
}
  
  let sections = ["전체", "창조", "나래", "호연", "비봉"]
  @State var mysection = "전체"
  
    var body: some View {
      NavigationView{
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
                
              
              
//              Text("전체")
//                .frame(height: 50)
//                .padding(.leading)
//              Label("Toggle Favorite", systemImage: "star.fill")
//                  .labelStyle(.iconOnly)
//                  .foregroundColor(Color.yellow)
              
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
//            HStack{
//              Spacer()
              
//              NavigationLink(destination: CreateRoom(), isActive: $isRoomLinkActive) {
//                  Button(action: {
//                      self.isRoomLinkActive = true
//                  }) {
//                      Text("방만들기")
//                  }
//              }
//              .padding(.trailing)
//            }
          }
          
          Divider()
          Spacer()
//            .frame(height: 20)
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
                
                if (test != nil) {
                  ScrollView(){
                    VStack(spacing: 2) {
                  ForEach(test.data.indices, id: \.self) { index in
                    DeliveryList(deliveryTitle: test.data[index].shopName, deliveryZone: test.data[index].section,
                                 deliveryPayTip: test.data[index].priceAtLeast,
                                 deliveryPayTotal: test.data[index].total,
                                 deliveryId: test.data[index].id,
                                 purchaserName: test.data[index].purchaserName,
                                 createdAt: test.data[index].createdAt
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
        
          
//        .navigationBarTitle("") //this must be empty
//        .navigationBarHidden(true)
      
        }
        .navigationBarTitle("") //this must be empty
        .navigationBarHidden(true)
      }.onAppear {
        
        let tokenvalue = UserDefaults.standard.string(forKey: "AccessToken")!
        
        let usertoken: [String: Any] = [
            "token": tokenvalue,
        ] as Dictionary
        
        socket.connect(withPayload: ["auth": usertoken])
        newArriveOn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          subscribeEmit()
        }
        
      }
      }
  
}

struct Delivery_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Delivery()
      }
    }
}


enum Tabs {
    case FirstTab
    case SecondTab
    case ThirdTab
}










































////
////  Delivery.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/16.
////
//
//import SwiftUI
//
//struct Delivery: View {
//  @State var isRoomLinkActive = false
//
//
//    var body: some View {
//      NavigationView{
//        VStack{
//          VStack(alignment: .leading){
//            HStack() {
//              Text("나래생활관")
//                .frame(height: 50)
//                .padding(.leading)
//              Label("Toggle Favorite", systemImage: "star.fill")
//                  .labelStyle(.iconOnly)
//                  .foregroundColor(Color.yellow)
//
//              Spacer()
//
//              Label("돋보기", systemImage: "magnifyingglass")
//                  .labelStyle(.iconOnly)
//                  .foregroundColor(Color.gray)
//              Label("종", systemImage: "bell")
//                  .labelStyle(.iconOnly)
//                  .foregroundColor(Color.gray)
//                  .padding(.trailing)
//            }
////            HStack{
////              Spacer()
//
////              NavigationLink(destination: CreateRoom(), isActive: $isRoomLinkActive) {
////                  Button(action: {
////                      self.isRoomLinkActive = true
////                  }) {
////                      Text("방만들기")
////                  }
////              }
////              .padding(.trailing)
////            }
//          }
//
//          Divider()
//
//
////            .font(35)
//
//          List {
//            Text("바로 배달방")
//            DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPay: "8000원/4000원", deliveryId: 14)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "버거킹", deliveryZone: "나래", deliveryPay: "12000원/9000원", deliveryId: 3)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "피자", deliveryZone: "창조", deliveryPay: "16000원/7000원", deliveryId: 6)
//              .listRowSeparator(.hidden)
//
//
//          }.listStyle(PlainListStyle())
//
//          List {
//            Text("전체 배달방")
//            DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPay: "8000원/4000원", deliveryId: 14)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "버거킹", deliveryZone: "나래", deliveryPay: "12000원/9000원", deliveryId: 3)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "피자", deliveryZone: "창조", deliveryPay: "16000원/7000원", deliveryId: 6)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPay: "8000원/4000원", deliveryId: 14)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "버거킹", deliveryZone: "나래", deliveryPay: "12000원/9000원", deliveryId: 3)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "피자", deliveryZone: "창조", deliveryPay: "16000원/7000원", deliveryId: 6)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "맥날", deliveryZone: "비봉", deliveryPay: "8000원/4000원", deliveryId: 14)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "버거킹", deliveryZone: "나래", deliveryPay: "12000원/9000원", deliveryId: 3)
//              .listRowSeparator(.hidden)
//            DeliveryList(deliveryTitle: "피자", deliveryZone: "창조", deliveryPay: "16000원/7000원", deliveryId: 6)
//              .listRowSeparator(.hidden)
//
//
//          }.listStyle(PlainListStyle())
//
//        }
//        .navigationBarTitle("") //this must be empty
//        .navigationBarHidden(true)
//      }
//      }
//
//}
//
//struct Delivery_Previews: PreviewProvider {
//    static var previews: some View {
//      Group {
//        Delivery()
//      }
//    }
//}
