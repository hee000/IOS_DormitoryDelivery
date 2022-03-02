import SwiftUI


struct OrderView: View {
  @Environment(\.presentationMode) var presentationMode
    
  @EnvironmentObject var keyboardManager: KeyboardManager
  @EnvironmentObject var naverLogin: NaverLogin
  
  @StateObject var ordermodel: Order = Order()
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
      return formatter
  }()

    var body: some View {
      NavigationView {
        GeometryReader { geometry in
          ZStack {
          ScrollView(showsIndicators: false) {
            VStack(alignment: .center ,spacing: 0){
              GeometryReader { geo in
                Button{
                  self.addanimation.toggle()
                  let nonemenue = orderdata(id: UUID().uuidString, name: "", quantity: 1, description: "", price: nil)
//                    self.ordermodel.data.append(nonemenue)
                  withAnimation {
                    self.ordermodel.onanimation.toggle()
                    self.ordermodel.data.insert(nonemenue, at: 0)
                  }
//                  self.ordermodel.data.insert(nonemenue, at: 0)
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
                .frame(height:3)
//              ForEach(ordermodel.data.indices, id: \.self) { index in // 뒤집힌 상태
              ForEach(Array(zip(0..., ordermodel.data)), id: \.1.id) { index, datasaz in // 뒤집힌 상태
                  VStack(spacing: 30){
                    VStack {
                      Button {
//                        if ordermodel.data[index].id != nil {
                        if ordermodel.isMenu.contains((ordermodel.data[index].id)) {
                          postMenuDelete(model: ordermodel, index: index, oderdata: ordermodel.data[index], rid: self.roomid, token: naverLogin.sessionId, anima: $addanimation)
                        } else {
//                          self.ordermodel.onanimation.toggle()
                          withAnimation {
                            self.ordermodel.onanimation.toggle()
                            ordermodel.data.remove(at: index)
                          }
                        }
                      } label: {
                        Image(systemName: "xmark")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 15, height: 15)
                          .foregroundColor(.gray)
                      }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    HStack(spacing: 0){
                      Text("* ")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                      Text("메뉴")
                        .font(.system(size: 16, weight: .bold))
                      TextField("메뉴를 입력해주세요", text: $ordermodel.data[index].name)
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 16, weight: .regular))
                    }
                    Divider()
                    HStack(spacing: 0){
                      Text("* ")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                      Text("가격")
                        .font(.system(size: 16, weight: .bold))
                      TextField("가격을 입력해주세요", value: $ordermodel.data[index].price, formatter: formatter)
                          .keyboardType(.phonePad)
                          .multilineTextAlignment(.trailing)
                          .font(.system(size: 16, weight: .regular))
                    }
                    Divider()
                    HStack(spacing: 0){
                      Text("수량")
                        .font(.system(size: 16, weight: .bold))
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
                          .font(.system(size: 16, weight: .regular))
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
                        .font(.system(size: 16, weight: .bold))
                      ZStack(alignment: .trailing){
                        Text(self.ordermodel.data[index].description != "" ? self.ordermodel.data[index].description : "세부 정보를 입력해주세요.")
                          .font(.system(size: 16, weight: .regular))
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
                          .font(.system(size: 16, weight: .regular))
                        
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
//                  .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                  .transition(.asymmetric(insertion: AnyTransition.move(edge: .top),
                                          removal: AnyTransition.move(edge: .leading)))
                  .animation(Animation.easeIn, value: ordermodel.onanimation)
//                  .animation(.easeIn)

                  } // for문
            } // vstack
            .padding([.leading, .trailing])
            .frame(maxWidth: .infinity)
//            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
//            .animation(Animation.easeInOut, value:addanimation)
//            .animation(.default)
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
                    postMenuEdit(oderdata: ordermodel.data[i], rid: self.roomid, token: naverLogin.sessionId)
                  } else {
                    postAddMenu(oderdata: ordermodel.data[i], rid: self.roomid, token: naverLogin.sessionId)
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
          .overlay(self.postalertstate ? AlertOneButton(isActivity: $postalertstate) { Text("필수 항목을 모두 기입해주세요.").font(.system(size: 16, weight: .regular)) } : nil)
          .overlay(self.exitalertstate ? AlertTwoButton(YActivity: $exit, NActivity: $exitalertstate) { Text("수정된 메뉴가 존재 합니다.").font(.system(size: 16, weight: .regular))
            Text("주문을 취소하고 나가시겠어요?").font(.system(size: 16, weight: .regular))
          }: nil)

        .onChange(of: exit, perform: { _ in
          presentationMode.wrappedValue.dismiss()
        })
        
        .onAppear(perform: {
          getMenuListIndividual(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: self.roomid, token: naverLogin.sessionId, model: self.ordermodel)
          
//          self.ordermodel.data = []
//          self.ordermodel.forcompare = []
//          if self.chatdata.menu.count == 0 {
//            let nonemenue = orderdata(id: nil, name: "", quantity: 1, description: "", price: nil)
//            self.ordermodel.data.append(nonemenue)
//            self.ordermodel.forcompare = self.ordermodel.data
//          } else {
//
////            for i in chatdata.menu.indices {
//
//              getMenus(uid: UserDefaults.standard.string(forKey: "MyID")!, rid: self.roomid, mid: self.chatdata, token: naverLogin.sessionId, model: self.ordermodel)
//
////            }
//          }
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
