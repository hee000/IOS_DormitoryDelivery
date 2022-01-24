//
//  OderListCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import SwiftUI

struct OderListCard: View {
  var model: tetet2
  
    var body: some View {
      VStack(alignment: .leading) {
        HStack{
          Text("프사")
          Text(model.user.name)
          Spacer()
          if model.user.userId == UserDefaults.standard.string(forKey: "MyID")! {
            Button("주문 수정"){
              print("주문수정~")
            }
          }
        }
        Divider()
        
        ForEach(model.menus.indices, id:\.self) { index in
          HStack{
            VStack(alignment: .leading) {
              Text("\(model.menus[index].price)원")
                .bold()
              Text(model.menus[index].name)
              Text(model.menus[index].description)
            }
            Spacer()
            Text("수량 \(model.menus[index].quantity) 개")
          }
        }
        Divider()
        HStack{
          Text("총 주문금액")
          Spacer()
          Text("\(model.menus.map{$0.price * $0.quantity}.reduce(0, +))원")
        }
      }
      .padding()
    }
}
