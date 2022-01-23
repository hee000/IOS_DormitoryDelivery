//
//  oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

struct OderView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var oderdata: Oder = Oder()
  @EnvironmentObject var naverLogin: NaverLogin
  
  var roomid: String
  
    var body: some View {
      VStack{
        Button("Dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        
        
        Text("주문서 작성")
        Form{
          Section(header: Text("메뉴")){
            TextField("메뉴이름", text: $oderdata.name)
              .keyboardType(.default)
          }
          
          Section(header: Text("수량")){
            TextField("수량", text: $oderdata.quantity)
              .keyboardType(.phonePad)
          }
        
          Section(header: Text("설명")){
            TextField("설명", text: $oderdata.description)
              .keyboardType(.default)
          }
          
          Section(header: Text("가격")){
            TextField("가격", text: $oderdata.price)
              .keyboardType(.phonePad)
          }
          
          Button {
            if let mytoken = naverLogin.loginInstance?.accessToken {
              postAddMenu(oderdata: oderdata, rid: self.roomid, token: mytoken)
            }
          } label: {
            Text("대충 플러스버튼")
          }
          
        }

      }
        
    }
}

//struct Oder_Previews: PreviewProvider {
//    static var previews: some View {
//        Oder()
//    }
//}
