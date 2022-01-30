//
//  oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

class Order: ObservableObject {
  @Published var data: [orderdata] = []
  @Published var forcompare: [orderdata] = []
}

struct orderdata: Codable{
  var id: String?;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int?;
}


struct OderView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var keyboardManager: KeyboardManager

  @EnvironmentObject var ordermodel: Order
  @EnvironmentObject var naverLogin: NaverLogin
  
  @State var chatdata: ChatDB
  @State var postalertstate = false
  @State var exitalertstate = false
  @State var exit = false
  @State var addanimation = false

  @State var height: CGFloat? = .zero
  @FocusState private var focusDescription: Bool
  
  var roomid: String
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
//      formatter.numberStyle = .decimal
      return formatter
  }()
  
//    .frame(height: keyboardManager.isVisible ? dasd.size.height - keyboardManager.keyboardHeight : dasd.size.height)
//    .offset(y: keyboardManager.isVisible ? -keyboardManager.keyboardHeight + geometry.safeAreaInsets.bottom + 60 : 0)
//
    var body: some View {
      NavigationView {
        GeometryReader { geometry in
          ZStack {
          ScrollView(showsIndicators: false) {
            VStack(alignment: .center ,spacing: 0){
              GeometryReader { geo in
                Button{
                  self.addanimation.toggle()
                  let nonemenue = orderdata(id: nil, name: "", quantity: 1, description: "", price: nil)
                    self.ordermodel.data.append(nonemenue)
                } label: {
                  Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.gray)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(.white)
                    .cornerRadius(5)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.2), radius: 8)
                }
              } //geo
              .padding([.leading, .trailing])
              .frame(height: 50)
            } // v
            .frame(width: UIScreen.main.bounds.width, height: 50)
            .padding(.top, 20)
            .padding(.bottom, 3)
            
            
            VStack(spacing: 20){ // 뒤집힌 상태
              Spacer()
                .frame(height: 80)
              ForEach(ordermodel.data.indices, id: \.self) { index in // 뒤집힌 상태
                  VStack(spacing: 30){
                    HStack(spacing: 0){
                      Text("* ")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                      Text("메뉴")
                        .bold()
                      TextField("메뉴를 입력해주세요", text: $ordermodel.data[index].name)
                        .multilineTextAlignment(.trailing)
                    }
                    Divider()
                    HStack(spacing: 0){
                      Text("* ")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                      Text("가격")
                        .bold()
                      TextField("가격을 입력해주세요", value: $ordermodel.data[index].price, formatter: formatter)
                          .keyboardType(.phonePad)
                          .multilineTextAlignment(.trailing)
                    }
                    Divider()
                    HStack(spacing: 0){
                      Text("수량")
                        .bold()
                      Spacer()
                      HStack(spacing: 10) {
                        Button {
                          if self.ordermodel.data[index].quantity > 1 {
                            self.ordermodel.data[index].quantity -= 1
                          }
                        } label: {
                          ZStack{
                            Color.clear
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                            Image(systemName: "minus")
                              .foregroundColor(self.ordermodel.data[index].quantity > 1 ? Color.black : Color.gray.opacity(0.5))
                          }
                        }
                          .disabled(self.ordermodel.data[index].quantity > 1 ? false : true)
                          .frame(width: 20)

                        Text("\(self.ordermodel.data[index].quantity)개")
                          .frame(width: 40)
                        Button {
                          self.ordermodel.data[index].quantity += 1
                        } label: {
                          ZStack{
                            Color.clear
                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                            Image(systemName: "plus")
                              .foregroundColor(.black)
                          }
                        }
                        .frame(width: 20)
                      }
                      .padding([.leading, .trailing], 10)
                      .padding([.top, .bottom], 10)
                      .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    }
                  
                    Divider()
                    HStack(spacing: 15){
                      Text("상세설명")
                        .bold()
                      ZStack(alignment: .trailing){
                        Text(self.ordermodel.data[index].description != "" ? self.ordermodel.data[index].description : "세부 정보를 입력해주세요.")
                          .padding([.top, .leading])
                          .frame(maxWidth: .infinity, minHeight: 45, alignment: .topTrailing)
                          .onTapGesture {
                            self.focusDescription.toggle()
                          }
                          .foregroundColor(self.ordermodel.data[index].description != "" ? Color.clear : Color.gray)
                          .zIndex(self.ordermodel.data[index].description != "" ? 0 : 1)
                          .background(GeometryReader { geo in
                            Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                          }.frame(minHeight: 45))
                          .onPreferenceChange(SizeKey.self) { value in
                            self.height = value
                          }
                        TextEditor(text: $ordermodel.data[index].description)
                          .focused($focusDescription)

                          .frame(height: self.height)
                          .multilineTextAlignment(.trailing)
                          .padding([.top, .leading])

                        
                      }
                    }.frame(maxHeight: 200)
                  }
                  .padding([.top, .bottom], 30)
                  .padding([.leading, .trailing])
                  .padding([.leading, .trailing], 10)
                  .background(Color.white)
                  .cornerRadius(5)
                  .clipped()
                  .shadow(color: Color.black.opacity(0.2), radius: 8)
                  .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                  .transition(.slide)


                  } // for문
              
              Spacer()
                .frame(height:3)
            } // vstack
            .padding([.leading, .trailing])
            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            .animation(Animation.easeInOut, value:addanimation)
          } // scroll
          .onTapGesture {
              hideKeyboard()
          }
            
            
          VStack{
            Spacer()
            Button {
              var valid = true
              for i in ordermodel.data.indices {
                if ordermodel.data[i].name == "" || ordermodel.data[i].price == nil {
                  valid = false
                  withAnimation {
                    self.postalertstate.toggle()
                  }
                  break
                }
              }
              if valid {
                for i in ordermodel.data.indices {
                  if ordermodel.data[i].id != nil {
                    if let mytoken = naverLogin.loginInstance?.accessToken {
                      postMenuEdit(oderdata: ordermodel.data[i], rid: self.roomid, token: mytoken)
                    }
                  } else {
                    if let mytoken = naverLogin.loginInstance?.accessToken {
                      postAddMenu(oderdata: ordermodel.data[i], rid: self.roomid, token: mytoken)
                    }
                  }
                }
                presentationMode.wrappedValue.dismiss()
              }
            } label: {
              Text("작성 완료")
                .bold()
                .font(.title3)
                .foregroundColor(.black)
                .padding(.top, 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }//button
            .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .top)
            .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 1))
            .transition(AnyTransition.opacity.animation(.easeInOut))
          } //버튼 V
          .ignoresSafeArea(.keyboard)
        } // Z
        .overlay(self.postalertstate ? AlertOneButton(isActivity: $postalertstate, text: "필수 항목을 모두 기입해주세요") : nil)
        .overlay(self.exitalertstate ? AlertTwoButton(yesButton: $exit, noButton: $exitalertstate, text1: "수정된 메뉴가 존재 합니다.", text2: "정말로 나가시겠습니까?") : nil)

        .onChange(of: exit, perform: { _ in
          presentationMode.wrappedValue.dismiss()
        })
        
        .onAppear(perform: {
          self.ordermodel.data = []
          self.ordermodel.forcompare = []
          if self.chatdata.menu.count == 0 {
            let nonemenue = orderdata(id: nil, name: "", quantity: 1, description: "", price: nil)
            self.ordermodel.data.append(nonemenue)
            self.ordermodel.forcompare = self.ordermodel.data
          } else {
            for i in chatdata.menu.indices {
              if let mytoken = naverLogin.loginInstance?.accessToken {
                getMenus(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: self.roomid, mid: self.chatdata.menu[i], token: mytoken, model: self.ordermodel)
              }
            }
          }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("주문서 작성")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              var same = true
              if self.ordermodel.forcompare.count == self.ordermodel.data.count {
                for i in self.ordermodel.forcompare.indices{
                  if self.ordermodel.forcompare[i].id != self.ordermodel.data[i].id {
                    same = false
                    break
                  } else if self.ordermodel.forcompare[i].name != self.ordermodel.data[i].name {
                    same = false
                    break
                  } else if self.ordermodel.forcompare[i].description != self.ordermodel.data[i].description {
                    same = false
                    break
                  } else if self.ordermodel.forcompare[i].quantity != self.ordermodel.data[i].quantity {
                    same = false
                    break
                  }
                }
              } else {
                same = false
              }
              
              if same {
                presentationMode.wrappedValue.dismiss()
              } else {
                hideKeyboard()
                withAnimation {
                  self.exitalertstate.toggle()
                }
              }
            } label: {
              Image(systemName: "xmark")
            }
            .foregroundColor(.black)
            .disabled(self.postalertstate ? true : false)
              .disabled(self.exitalertstate ? true : false)
          }
        } //toolbar
      } //geo
            .ignoresSafeArea(.keyboard)


    } //navi
        
  }
}
