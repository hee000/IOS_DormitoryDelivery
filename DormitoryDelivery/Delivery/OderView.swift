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
  
  @State var odteee22 = tete244()
  
  @EnvironmentObject var naverLogin: NaverLogin
  
  @State var chatdata: ChatDB
  @State var postalertstate = false
  @State var exitalertstate = false
  @State var exit = false
//  @State var exitalertstate = false
  var roomid: String
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
//      formatter.numberStyle = .decimal
      return formatter
  }()
  
    var body: some View {
      NavigationView {
        VStack(spacing: 0) {
          
          VStack(alignment: .center ,spacing: 0){
            GeometryReader { geo in
              Button{
                let nonemenue = tetemenussss(id: nil, name: "", quantity: 1, description: "", price: nil)
//                self.odteee.data.insert(nonemenue, at: 0)
                  self.odteee.data.append(nonemenue)
              } label: {
                Image(systemName: "plus")
                  .font(.title)
                  .foregroundColor(.gray)
                  .frame(width: geo.size.width, height: geo.size.height)
                  .background(.white)
                  .clipped()
                  .shadow(color: Color.black.opacity(0.2), radius: 8)
              }
            } //geo
            .padding([.leading, .trailing])
            .frame(height: 50)
          } // v
          .frame(width: UIScreen.main.bounds.width, height: 50)
          .padding(.bottom, 3)
          
          
        ScrollView(showsIndicators: false) {
          VStack(spacing: 20){ // 뒤집힌 상태
            ForEach(odteee.data.indices, id: \.self) { index in // 뒤집힌 상태
                VStack(spacing: 30){
                  HStack{
                    Text("*메뉴")
                      .bold()
                    TextField("메뉴를 입력해주세요", text: $odteee.data[index].name)
                      .multilineTextAlignment(.trailing)
                  }
                  Divider()
                  HStack{
                    Text("*가격")
                      .bold()
                    TextField("가격을 입력해주세요", value: $odteee.data[index].price, formatter: formatter)
                        .keyboardType(.phonePad)
                        .multilineTextAlignment(.trailing)
                  }
                  Divider()
                  HStack{
                    Text("수량")
                      .bold()
                    Spacer()
                    HStack(spacing: 20) {
                      Button {
                        if self.odteee.data[index].quantity > 1 {
                          self.odteee.data[index].quantity -= 1
                        }
                      } label: {
                        Image(systemName: "minus")
                          .foregroundColor(self.odteee.data[index].quantity > 1 ? Color.black : Color.gray.opacity(0.5))
                      }
                      .disabled(self.odteee.data[index].quantity > 1 ? false : true)
                      Text("\(self.odteee.data[index].quantity)개")
                        .frame(width: 40)
                      Button {
                        self.odteee.data[index].quantity += 1
                      } label: {
                        Image(systemName: "plus")
                          .foregroundColor(.black)
                      }
                    }
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 10)
                    .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                  }
                
                  Divider()
                  HStack{
                    Text("상세설명")
                      .bold()
                    TextField("세부 정보를 입력해주세요", text: $odteee.data[index].description)
                      .multilineTextAlignment(.trailing)
                  }
                }
                .padding([.top, .bottom], 30)
                .padding([.leading, .trailing])
                .padding([.leading, .trailing], 10)
                .background(Color.white)
                .clipped()
                .shadow(color: Color.black.opacity(0.2), radius: 8)
                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                .transition(AnyTransition.opacity.animation(Animation.easeOut))
//                .animation(odteee.data.count > 1 ? .easeIn : nil)

                
              
                } // for문
            
            Spacer()
              .frame(height:3)
          } // vstack
          .padding([.leading, .trailing])
          
          .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
          .animation(odteee.data.count > 1 ? .easeIn : nil)
          
        } // scroll
          
        Button {
          var valid = true
          for i in odteee.data.indices {
            if odteee.data[i].name == "" || odteee.data[i].price == nil || Int(odteee.data[i].price!) == nil {
              valid = false
              print("오류검출됨")
              self.postalertstate.toggle()
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
        } label: {
          Text("작성 완료")
            .bold()
            .font(.title3)
            .foregroundColor(.black)
            .padding(.top, 15)
        }//button
        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .top)
        .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 1))
      } // v
        .padding(.top, 40)
        .overlay(self.postalertstate ? AlertOneButton(isActivity: $postalertstate, text: "필수 항목을 모두 기입해주세요") : nil)
        .overlay(self.exitalertstate ? AlertTwoButton(yesButton: $exit, noButton: $exitalertstate, text1: "수정된 메뉴가 존재 합니다.", text2: "정말로 나가시겠습니까?") : nil)

        .onChange(of: exit, perform: { _ in
          presentationMode.wrappedValue.dismiss()
        })
        
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
        self.odteee22.data = self.odteee.data
      })
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarTitle("주문서 작성")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            var vaild = true
            if self.odteee22.data.count == self.odteee.data.count {
              for i in self.odteee22.data.indices{
                if self.odteee22.data[i].id != self.odteee.data[i].id {
                  vaild = false
                  break
                } else if self.odteee22.data[i].name != self.odteee.data[i].name {
                  vaild = false
                  break
                } else if self.odteee22.data[i].description != self.odteee.data[i].description {
                  vaild = false
                  break
                } else if self.odteee22.data[i].quantity != self.odteee.data[i].quantity {
                  vaild = false
                  break
                }
              }
            } else {
              vaild = false
            }
            
            if vaild {
              presentationMode.wrappedValue.dismiss()
            } else {
              hideKeyboard()
              self.exitalertstate.toggle()
            }
          } label: {
            Image(systemName: "xmark")
          }
          .foregroundColor(.black)
          .disabled(self.postalertstate ? true : false)
            .disabled(self.exitalertstate ? true : false)
        }
      }
    } //navi
        
  }
}
