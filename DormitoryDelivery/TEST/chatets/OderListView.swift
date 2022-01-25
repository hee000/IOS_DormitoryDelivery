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
  @ObservedObject var tetemodel: tete2 = tete2()
  var rid: String

    var body: some View {
      NavigationView {
        GeometryReader { geo in
          VStack(alignment: .center) {
            if tetemodel.data != nil{
              ForEach(tetemodel.data!.indices, id:\.self) { index in
                OderListCard(model: tetemodel.data![index])
              }
              .frame(width: geo.size.width * (9/10))
              .border(.gray)
            }
            
          } //vstack
          .frame(width: geo.size.width)
          .onAppear {
            if let mytoken = naverLogin.loginInstance?.accessToken {
              getMenuList(rid: self.rid, token: mytoken, model: tetemodel)
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
