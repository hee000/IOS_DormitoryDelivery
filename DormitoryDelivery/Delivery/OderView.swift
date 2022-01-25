//
//  oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

class tete244: ObservableObject {
  @Published var data: [tetemenussss] = []
}

struct tetemenussss: Codable{
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int;
}


struct OderView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var oderdata: Oder = Oder()
  
  @ObservedObject var odteee: tete244 = tete244()
  
  
  @EnvironmentObject var naverLogin: NaverLogin
  
  @State var chatdata: ChatDB
  var roomid: String
  
    var body: some View {
      NavigationView {
        VStack{
          
//          if odteee.data.count != 0 {
            ForEach(odteee.data.indices, id: \.self) { index in
//              OrderCard(model: $odteee.data[index])
              VStack{
                HStack{
                  Text("메뉴")
                  TextField("메뉴를 입력해주세요", text: $odteee.data[index].name)
                    .border(.red)
                    .multilineTextAlignment(.trailing)

                }
                Divider()
                HStack{
                  Text("가격")
                }
                Divider()
                HStack{
                  Text("수령")
                }
                Divider()
                HStack{
                  Text("상세설명")
                  TextField("세부 정보를 입력해주세요", text: $odteee.data[index].description)
                    .multilineTextAlignment(.trailing)

                  
                }
              }
            }
//            .onChange(of: odteee.data) { newValue in
//            print(newValue)
//          }
//          }
          
          
          Form{
            Section(header: Text("메뉴")){
              TextField("메뉴이름", text: $oderdata.name)
                .keyboardType(.default)
            }
            
            Section(header: Text("수량")){
              TextField("수량", text: $oderdata.quantity)
                .keyboardType(.numberPad)
            }
          
            Section(header: Text("설명")){
              TextField("설명", text: $oderdata.description)
                .keyboardType(.default)
            }
            
            Section(header: Text("가격")){
              TextField("가격", text: $oderdata.price)
                .keyboardType(.numberPad)
            }
            
            Button {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                if self.oderdata.name != "" && self.oderdata.quantity != "" && self.oderdata.description != "" && self.oderdata.price != "" {
                  postAddMenu(oderdata: oderdata, rid: self.roomid, token: mytoken)
                }
              }
            } label: {
              Text("대충 플러스버튼")
            }
            
          }

        } // vstack
        .onAppear(perform: {
          print(self.chatdata.menu.count)
          if self.chatdata.menu.count == 0 {
            let nonemenue = tetemenussss(name: "", quantity: 0, description: "", price: 0)
            self.odteee.data.append(nonemenue)
            print(self.odteee.data)
          } else {
            for i in chatdata.menu.indices {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getMenus(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: self.roomid, mid: self.chatdata.menu[i], token: mytoken, model: self.odteee)
              }
            }
            print(self.odteee.data)
          }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("주문서 작성")
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
