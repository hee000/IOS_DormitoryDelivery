//
//  OderListView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI
import Network

struct OderListView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var naverLogin: NaverLogin
//  @ObservedObject var orderlistmodel: OrderList = OrderList()
  @EnvironmentObject var orderlistmodel: OrderList
  var rid: String

    var body: some View {
      NavigationView {
        GeometryReader { geo in
          VStack(alignment: .center) {
            if orderlistmodel.data != nil{
              ForEach(orderlistmodel.data!.indices, id:\.self) { index in
                OderListCard(model: orderlistmodel.data![index])
              }
              .frame(width: geo.size.width * (9/10))
              .border(.gray)
            }
            
          } //vstack
          .frame(width: geo.size.width)
          .onAppear {
            orderlistmodel.data = nil
            if let mytoken = naverLogin.loginInstance?.accessToken {
              getMenuList(rid: self.rid, token: mytoken, model: orderlistmodel)
            }
          }
        } //geo
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("주문 리스트")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
      } //navi
    }
  
}
