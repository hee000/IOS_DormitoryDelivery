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
  @StateObject var orderlistmodel: OrderList = OrderList()
//  @EnvironmentObject var orderlistmodel: OrderList
  var rid: String
//  @Binding var isActivity: Bool

    var body: some View {
      GeometryReader { geo in
        ScrollView {
          VStack(alignment: .center) {
            if orderlistmodel.data != nil{
              ForEach(orderlistmodel.data!.indices, id:\.self) { index in
                OderListCard(model: orderlistmodel.data![index], roomid: rid)
              }
              .frame(width: geo.size.width * (9/10))
              .background(.white)
              .cornerRadius(5)
              .clipped()
              .shadow(color: Color.black.opacity(0.2), radius: 8)
            }
            
          } //vstack
          .frame(width: geo.size.width)
          .onAppear {
            orderlistmodel.data = nil
            if let mytoken = naverLogin.loginInstance?.accessToken {
              getMenuList(rid: self.rid, token: mytoken, model: orderlistmodel)
            }
          }
          .padding(.top)
        }//scroll
      } //geo
      .clipped()
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("주문 리스트")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(.black)
          }
        }
      }
    }
  
}
