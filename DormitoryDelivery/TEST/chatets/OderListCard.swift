//
//  OderListCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import SwiftUI

struct OderListCard: View {
  var model: orderlistdata
  var roomid: String
  @State var order = false
  
    var body: some View {
      VStack(alignment: .leading) {
        HStack{
          Text("프사")
          Text(model.user.name)
          Spacer()
          if model.user.userId == UserDefaults.standard.string(forKey: "MyID")! {
            Button("주문 수정"){
              self.order.toggle()
            }
          }
        }
        .padding(.top)
        
        ForEach(model.menus.indices, id:\.self) { index in
          Divider()
            .padding([.top, .bottom])
          
          HStack{
            VStack(alignment: .leading, spacing: 10) {
              Text("\(model.menus[index].price)원")
                .bold()
                .font(.title3)
              Text(model.menus[index].name)
                .bold()
              Text(model.menus[index].description)
                .foregroundColor(.gray)
            }
            Spacer()
            Text("수량 \(model.menus[index].quantity) 개")
          }
        }
        Divider()
          .padding([.top, .bottom])
        HStack{
          Text("총 주문금액")
          Spacer()
          Text("\(model.menus.map{$0.price * $0.quantity}.reduce(0, +))원")
            .font(.title3)
            .bold()
            .foregroundColor(Color(.sRGB, red: 91/255, green: 66/255, blue: 212/255, opacity: 1))
        }
        .padding(.bottom)
      }
      .padding()
      .fullScreenCover(isPresented: $order) {
        OderView(chatdata: roomidtodbconnect(rid: self.roomid)!, roomid: self.roomid)
      }
    }
}
