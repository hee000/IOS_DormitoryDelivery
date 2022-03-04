//
//  OderListCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import SwiftUI

struct OrderListCard: View {
  var model: orderlistdata
  var roomid: String
  @State var order = false
  @State var RoomChat: ChatDB?

  
    var body: some View {
      VStack(alignment: .leading) {
        HStack{
          Image("ImageDefaultProfile")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .cornerRadius(28)
            .shadow(color: Color.black.opacity(0.5), radius: 1)
          Text(model.user.name)
            .font(.system(size: 18, weight: .bold))
          Spacer()
          if model.user.userId == UserData().data.id && RoomChat != nil && RoomChat!.state?.orderFix == false {
            Button {
              self.order.toggle()
            } label: {
              Text("주문 수정")
                .font(.system(size: 12, weight: .regular))
                .padding(7)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
            }
            .foregroundColor(.black)
          }
        }
        
        ForEach(model.menus.indices, id:\.self) { index in
          Divider()
            .padding(.bottom, 8)
          
          HStack{
            VStack(alignment: .leading, spacing: 10) {
              Text("\(model.menus[index].price)원")
                .font(.system(size: 18, weight: .bold))
              HStack{
                Text(model.menus[index].name)
                  .font(.system(size: 14, weight: .bold))
                Spacer()
                Text("수량 \(model.menus[index].quantity) 개")
                  .font(.system(size: 14, weight: .regular))
              }
              if model.menus[index].description != ""{
                Text(model.menus[index].description)
                  .foregroundColor(.gray)
                  .font(.system(size: 14, weight: .regular))
              }
            }
          }
        }
        Divider()
          .padding([.top, .bottom], 8)
        HStack{
          Text("총 주문금액")
            .font(.system(size: 14, weight: .regular))
          Spacer()
          Text("\(model.menus.map{$0.price * $0.quantity}.reduce(0, +))원")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(.sRGB, red: 91/255, green: 66/255, blue: 212/255, opacity: 1))
        }
      }
      .padding()
      .fullScreenCover(isPresented: $order) {
        OrderView(chatdata: roomidtodbconnect(rid: self.roomid)!, roomid: self.roomid)
      }
    }
}
