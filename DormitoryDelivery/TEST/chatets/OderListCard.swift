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
            .font(.title3)
            .bold()
          Spacer()
          if model.user.userId == UserDefaults.standard.string(forKey: "MyID")! && RoomChat != nil && RoomChat!.state?.orderFix == false {
            Button {
              self.order.toggle()
            } label: {
              Text("주문 수정")
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
                .bold()
                .font(.title3)
              HStack{
                Text(model.menus[index].name)
                  .bold()
                Spacer()
                Text("수량 \(model.menus[index].quantity) 개")
                  .font(.subheadline)
              }
              if model.menus[index].description != ""{
                Text(model.menus[index].description)
                  .foregroundColor(.gray)
                  .font(.subheadline)
              }
            }
          }
        }
        Divider()
          .padding([.top, .bottom], 8)
        HStack{
          Text("총 주문금액")
          Spacer()
          Text("\(model.menus.map{$0.price * $0.quantity}.reduce(0, +))원")
            .font(.title3)
            .bold()
            .foregroundColor(Color(.sRGB, red: 91/255, green: 66/255, blue: 212/255, opacity: 1))
        }
      }
      .padding()
      .fullScreenCover(isPresented: $order) {
        OderView(chatdata: roomidtodbconnect(rid: self.roomid)!, roomid: self.roomid)
      }
    }
}
