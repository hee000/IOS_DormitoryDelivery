//
//  oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

class tete244: ObservableObject {
  @Published var data: [tetemenussss] = []
  @Published var new: Int = 0
}

struct tetemenussss: Codable{
  var id: String?;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int?;
}


struct OderView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var oderdata: Oder = Oder()
  
  @ObservedObject var odteee: tete244 = tete244()
  
  
  @EnvironmentObject var naverLogin: NaverLogin
  
  @State var chatdata: ChatDB
  var roomid: String
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
//      formatter.numberStyle = .decimal
      return formatter
  }()
  
    var body: some View {
      NavigationView {
        GeometryReader { geo in
          ScrollView {
            
            Button{
              let nonemenue = tetemenussss(id: nil, name: "", quantity: 1, description: "", price: nil)
              self.odteee.data.insert(nonemenue, at: 0)
            } label: {
              Text("하나 더 추가")
            }
            
            VStack(spacing: 20){
                ForEach(odteee.data.indices, id: \.self) { index in
                  VStack(spacing: 20){
                    HStack{
                      Text("메뉴")
                      TextField("메뉴를 입력해주세요", text: $odteee.data[index].name)
                        .multilineTextAlignment(.trailing)
                    }
                    Divider()
                    HStack{
                      Text("가격")
                      ZStack{
//                        Text("가격을 입력해주세요.")
//                          .foregroundColor(self.odteee.data[index].price != 0 ? Color.clear : Color.gray)
                        TextField("가격을 입력해주세요", value: $odteee.data[index].price, formatter: formatter)
//                          .foregroundColor(self.odteee.data[index].price != 0 ? Color.black : Color.clear)
                          .multilineTextAlignment(.trailing)
                      }
                    }
                    Divider()
                    HStack{
                      Text("수량")
                      Spacer()
                      Button("-") {
                        self.odteee.data[index].quantity -= 1
                      }
                      Text("\(self.odteee.data[index].quantity)개")
                      Button("+"){
                        self.odteee.data[index].quantity += 1
                      }
                    }
                  
                    Divider()
                    HStack{
                      Text("상세설명")
                      TextField("세부 정보를 입력해주세요", text: $odteee.data[index].description)
                        .multilineTextAlignment(.trailing)
                    }
                  }
                  .padding()
                  .border(.gray)
                  } // for문
              Button("전송"){
                var valid = true
                for i in odteee.data.indices {
                  if odteee.data[i].name == "" || odteee.data[i].description == "" || odteee.data[i].price == nil || Int(odteee.data[i].price!) == nil {
                    valid = false
                    print("오류검출됨")
                    break
                  }
                }
                if valid {
                  for i in odteee.data.indices {
                    if odteee.data[i].id != nil {
                      if let mytoken = naverLogin.loginInstance?.accessToken {
                        postMenuEdit(oderdata: odteee.data[i], rid: self.roomid, token: mytoken)
                      }
                    } else {
                      if let mytoken = naverLogin.loginInstance?.accessToken {
                        postAddMenu(oderdata: odteee.data[i], rid: self.roomid, token: mytoken)
                      }
                    }
                  }
                }
              }


            } // vstack
          } // scroll
        }//geo
        .padding()
        
        .onAppear(perform: {
          if self.chatdata.menu.count == 0 {
            let nonemenue = tetemenussss(id: nil, name: "", quantity: 1, description: "", price: nil)
            self.odteee.data.append(nonemenue)
          } else {
            for i in chatdata.menu.indices {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getMenus(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: self.roomid, mid: self.chatdata.menu[i], token: mytoken, model: self.odteee)
              }
            }
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
