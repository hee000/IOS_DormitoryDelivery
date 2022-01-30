//
//  chat.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI
import RealmSwift
import Alamofire



struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}



struct Chat: View {
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var keyboardManager: KeyboardManager

//  @StateObject var model = ChatModel()
  @EnvironmentObject var dddatdata: ChatData
  @EnvironmentObject var naverLogin: NaverLogin
  @State var RoomChat : ChatDB?
  var roomid: String
  

  @FocusState private var rere: Bool
  @State var textHeight: CGFloat?

  @State var text = ""
  @State var showMenu = false
  @State var leave = false
  @State var oderview = false
  @State var oderlistview = false
  @State var odercheck = false
  @State var userodercheck = false
  
  @Namespace var bottomID
  @State private var offset = CGFloat.zero
  @State private var stacksize = CGFloat.zero
  @State private var scrollsize = CGFloat.zero
    
  @State var isAnimating = false

  var body: some View {
    let drag = DragGesture()
      .onEnded {
        if $0.translation.width > 100 {
          withAnimation {
            self.showMenu = false
          }
        }
      }

    GeometryReader { geo in
      ZStack {
      VStack(spacing: 0) {
            //MARK:- ScrollView
//        CustomScrollView(scrollToEnd: true) {
        GeometryReader { scrollgeo in
        ScrollViewReader { proxy in
          
        ScrollView {
          Spacer().frame(height: 10).id(bottomID)
          LazyVStack(spacing: 3) {
                  if let RoomDB = RoomChat{
//                    ForEach(Array(zip(RoomDB.messages.indices, RoomDB.messages)), id: \.1) { index, item in

//                    ForEach(0..<RoomDB.messages.count, id:\.self) { index in
                    ForEach(RoomDB.messages.indices, id: \.self) { index in

                      if RoomDB.messages[index].type == "chat" {
                        if let idvalue = UserDefaults.standard.string(forKey: "MyID") {
                          if RoomDB.messages[index].body!.userid == idvalue { // 내 매세지
                            ChatBubble(position: BubblePosition.right, color: Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1)) {
                              Text(RoomDB.messages[index].body!.message!)
                            }
                          } else { // 상대방 처음
                            if RoomDB.messages[index - 1].type == "system" || RoomDB.messages[index].body!.userid != RoomDB.messages[index - 1].body!.userid{
//                              ChatBubble(position: BubblePosition.left, color: .white) {
//                                Text(RoomDB.messages[index].body!.message!)
//                              }
                              if RoomDB.messages[index].body!.userid == RoomDB.superUser!.userId {
                                HStack(alignment: .top, spacing: 0) { // 방장인경우
                                  Image("ImageDefaultProfile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.5), radius: 1)
                                    .padding(.trailing, 5)
                                  VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0){
                                      Image("ImageSuperCrown")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 9, height: 8)
                                      Text("방장 | \(RoomDB.messages[index].body!.username!)")
                                        .font(.footnote)
                                        .padding(.leading, 3)
                                    }
                                      .padding([.top, .bottom], 3)
                                    Text(RoomDB.messages[index].body!.message!)
                                      .padding(10)
                                      .foregroundColor(Color.black)
                                      .background(.white)
                                      .clipShape(RoundedRectangle(cornerRadius: 10))
                                      .background(Color.white
                                          .frame(width: 30, height:30)
                                                    .position(x: 0, y: 0)
                                      )
                                      .clipped()
                                  }
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 60)
                                .frame(width: UIScreen.main.bounds.width, alignment:.leading)
                              } else {
                                HStack(alignment: .top, spacing: 0) {
                                  Image("ImageDefaultProfile")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                                    .cornerRadius(28)
                                    .shadow(color: Color.black.opacity(0.5), radius: 1)
                                    .padding(.trailing, 5)
                                  VStack(alignment: .leading, spacing: 0) {
                                    Text(RoomDB.messages[index].body!.username!)
                                      .font(.footnote)
                                      .padding([.top, .bottom], 3)
                                    Text(RoomDB.messages[index].body!.message!)
                                        .padding(10)
                                        .foregroundColor(Color.black)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .background(Color.white
                                            .frame(width: 30, height:30)
                                                      .position(x: 0, y: 0)
                                        )
                                        .clipped()
                                  }
                                }
                                .padding(.leading, 10)
                                .padding(.trailing, 60)
                                .frame(width: UIScreen.main.bounds.width, alignment:.leading)
                              }
                            } else { // 상대 처음 이후
                              ChatBubble(position: BubblePosition.left2, color: .white) {
                                Text(RoomDB.messages[index].body!.message!)
                              }
                            }
                            
                          }
                        }
                        
                      } else { // 시스템 메시지
                        if RoomDB.messages[index].body!.action! == "users-new" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(RoomDB.messages[index].body!.data!.name!)님이 참여했습니다.")
                              .font(.footnote)
                          }
                        } else if RoomDB.messages[index].body!.action! == "users-leave" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(RoomDB.messages[index].body!.data!.name!)님이 퇴장했습니다.")
                              .font(.footnote)
                          }
                        } else if RoomDB.messages[index].body!.action! == "order-fixed" {
                              HStack{
                                VStack(alignment: .leading){
                                  Text("방장이 메뉴를 확정했어요!")
                                    .bold()
                                  Text("이제 메뉴를 바꿀 수 없습니다.")
                                    .bold()
                                }
                                .padding()
                                Spacer()
                                Image("ImageOrderFix")
                                  .resizable()
                                  .scaledToFit()
                                  .frame(width: 97, height: 81)
                                  .padding()
                                }
                              .frame(width: geo.size.width * 9/10)
                              .background(.white)
                              .cornerRadius(5)
                              .shadow(color: Color.black.opacity(0.2), radius: 4)
                              .padding(10)
                        } else if RoomDB.messages[index].body!.action! == "order-checked" {
                          if RoomDB.superUser!.userId! != UserDefaults.standard.string(forKey: "MyID")! {
                            VStack(spacing: 0){
                                  HStack{
                                    VStack(alignment: .leading){
                                      Text("(이름)님의")
                                        .bold()
                                      Text("보낼 금액을 확인해보세요.")
                                        .bold()
                                    }
                                    Spacer()
                                    Image("ImageOrderCheck")
                                      .resizable()
                                      .scaledToFit()
                                      .frame(width: 135, height: 73)
                                    }
                                  .padding()
                                  .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
                                    Button{
                                      self.userodercheck.toggle()
                                    } label: {
                                      Text("주문내역 확인하기")
                                        .frame(height: 40)
                                        .frame(maxWidth: .infinity)
                                    }
                                    .background(Color(.sRGB, red: 225/255, green: 225/255, blue: 231/255, opacity: 1))
                                    .cornerRadius(5)
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 10)
                                  } //v
                                .frame(width: geo.size.width * 9/10)
                                .background(.white)
                                .cornerRadius(5)
                                .shadow(color: Color.black.opacity(0.2), radius: 4)
                                .padding(10)

                          } else {
                            Text("모두에게 정산 금액이 전해졌습니다")
                          }
                        } else {
                          ChatBubble(position: BubblePosition.center, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text(RoomDB.messages[index].body!.action!)
                          }
                        }
                    }
                    
                  } //for
                  
                  } //if
            
                } //lazyV
          .rotationEffect(Angle(degrees: 180))
          .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                      .background(GeometryReader {
                          Color.clear.preference(key: ViewOffsetKey.self,
                              value: -$0.frame(in: .named("scroll")).origin.y)
                      })
                      .onPreferenceChange(ViewOffsetKey.self) {
//                        print("offset >> \($0)")
                        self.offset = $0
                      }
          
                      .background(GeometryReader { geozz in
//                        Color.clear.preference(key: SizeKey.self, value: geozz.size.height)
                        Color.clear
                          .onAppear{
                            self.stacksize = geozz.size.height
                          }
                          .onChange(of: geozz.size.height) { V in
                          self.stacksize = V
                        }
                      })
//                      .onPreferenceChange(SizeKey.self) { value in // --- 2
//                            print("VStack >> \(value)")
//                          print("VStack - offset >> \((value ?? 0) - self.offset)")
//                      }
          
          
          
          Spacer().frame(height: 10).id(bottomID)
            } //scrollview
        .rotationEffect(Angle(degrees: 180))
        .scaleEffect(x: -1.0, y: 1.0, anchor: .center)

          .coordinateSpace(name: "scroll")
//          ------------
//          .onAppear{
//            proxy.scrollTo(bottomID)
//            self.scrollsize = scrollgeo.size.height
//          }
//          .onChange(of: RoomChat?.messages.count) { _ in
//            if (self.stacksize - self.offset) - 10 <= self.scrollsize {
//              proxy.scrollTo(bottomID)
//            }
//          }
//          .onChange(of: scrollgeo.size.height) { V in
//            self.scrollsize = V
//          }
//          ------------
        }//reader
        }//geo
          .clipped()
          .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
          .onTapGesture {
            hideKeyboard()
          }
            //MARK:- text editor
        // 주문서 작성 & 준비완료
        if RoomChat?.state?.orderFix == false {
          if RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! || (RoomChat?.menu.count) == 0{
            Button("주문서 작성") {
              self.oderview.toggle()
//              self.testbool.toggle()
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 45, alignment: .center)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          } else {
              HStack(alignment: .center, spacing: 0){
                Button("주문서 작성") {
                  self.oderview.toggle()
//                  self.testbool.toggle()
                }
                .frame(width: geo.size.width/2)
                Divider()
                Button(RoomChat!.ready ? "준비해제" : "준비완료") {
                  if let mytoken = naverLogin.loginInstance?.accessToken {
                    getReady(rid: self.roomid, token: mytoken, model: RoomChat!)
                  }
                }
                .frame(width: geo.size.width/2)

              }
              .frame(width: geo.size.width, height: 45, alignment: .center)
              .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
          }
        }// 주문서 작성 & 준비완료 닫기
        
        
            HStack { // 채팅샌더
              HStack(spacing: 0) {
                GeometryReader { geosender in
                  ZStack {
                    Text(self.text)
                      .lineLimit(1)
                      .frame(width: geosender.size.width, alignment: .leading)
                      .background(Color.white)
                      .opacity(self.rere ? 0 : 1)
                      .onTapGesture {
                        self.rere.toggle()
                      }
                    
                    Text("") // 에디터 줄 확인
                      .frame(width: geosender.size.width, height: 70, alignment: .leading)
                      .frame(maxHeight: .infinity)
                      .background(
                        Text(self.text)
                          .opacity(0)
                          .background(
                            GeometryReader { geo in
                              Color.clear.preference(key: SizeKey.self, value: geo.size.height)
                            }.frame(minHeight: 18))
                          .onPreferenceChange(SizeKey.self) { value in // --- 2
                                self.textHeight = value
                          }
                      )

                    TextEditor(text: $text)
                      .focused($rere)
                      .frame(width: geosender.size.width, height: 18.0 + (self.textHeight ?? 18.0))
                      .opacity(self.rere ? 1 : 0)
                  }
                  .frame(height: self.rere ? 18.0 + (self.textHeight ?? 18.0) : 36)
                } //geo sender

                Button {
                  if self.text != "" {
                    SocketIOManager.shared.room_emitChat(rid: self.roomid, text: self.text)
                    self.text = ""
                    }
                } label: {
                  Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:30, height: 30)
                    .foregroundColor(Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 3))
              }
              .background(.white)
              .frame(height: self.rere ? 18.0 + (self.textHeight ?? 18.0) : 36)
              .cornerRadius(20)

            } // 채팅샌더 닫기
            .padding([.leading, .trailing])
            .frame(width: geo.size.width ,height: self.rere ? 18.0 + (self.textHeight ?? 18.0) + 10 : 46)
            .background(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1))
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 210/255, green: 210/255, blue: 210/255, opacity: 1)), alignment: .top)
        
        }//vstack
      .frame(width: geo.size.width, height: geo.size.height)
      .disabled(self.showMenu ? true : false)
      .overlay(self.showMenu ? Rectangle()
                .fill(Color.black.opacity(0.7))
                .edgesIgnoringSafeArea(.bottom)
                .frame(width: geo.size.width,
                       height: geo.size.height)
                .onTapGesture(perform: {
        withAnimation {
          self.showMenu.toggle()
        }
      }) : nil)
//      .transition(AnyTransition.move(edge: .bottom))

        
        if self.isAnimating && RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.allReady == true && self.showMenu == false {
          Button {
            if let mytoken = naverLogin.loginInstance?.accessToken {
            postOderFix(rid: self.roomid, token: mytoken)
            }
          } label: {
            VStack{
              Text("모두가 준비했습니다.")
              Text("주문을 진행하시겠습니까?")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 0.9))
            .cornerRadius(5)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1).repeatForever()))
        } // 방장 메뉴 오더 픽스 이벤트
        
        
        if self.isAnimating && RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.orderFix == true && RoomChat?.state?.orderChecked == false && self.showMenu == false {
          Button{
            self.odercheck.toggle()
          } label: {
            Text("주문 사진과 배달 금액을 입력해주세요")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 0.9))
              .cornerRadius(5)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1).repeatForever()))
        } // 방장 메뉴 확인 이벤트
        
        if self.isAnimating && RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.orderFix == true && RoomChat?.state?.orderChecked == false && self.showMenu == false {
          Button{
            self.odercheck.toggle()
          } label: {
            Text("주문 사진과 배달 금액을 입력해주세요")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 0.9))
              .cornerRadius(5)
          }
          .frame(width: geo.size.width * 9/10, height: 60)
          .offset(y: -geo.size.height/2 + 45)
          .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1).repeatForever()))
        } // 방장 주문 확인 이벤트
        
        if self.showMenu {
          ChatSideMenu(RoomChat: $RoomChat, leave: $leave, showMenu: $showMenu, oderlistview: $oderlistview, rid: self.roomid)
          .frame(width: geo.size.width * (9/10), height: geo.size.height)
          .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(.sRGB, red: 221/255, green: 221/255, blue: 221/255, opacity: 1)), alignment: .top)
          .transition(.move(edge: .trailing))
          .offset(x: geo.size.width/10)
      } //showmenu
      
        NavigationLink(destination: OderListView(RoomChat: RoomChat, rid: self.roomid), isActive: $oderlistview) {}
        
    } //Zstack
      .gesture(drag)
      .onAppear{
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
          self.isAnimating = true
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle(RoomChat != nil ? RoomChat!.title! : "채팅방")
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
              }
            }
          }
          ToolbarItem(placement: .navigationBarTrailing) {
            HStack{
              Button {
                withAnimation {
                  self.showMenu.toggle()
                }
              } label: {
                Image(systemName: "line.horizontal.3")
              }
            }
          }
      }
    } //geo
//    .adaptsToKeyboard()
//    .ignoresSafeArea(.keyboard)
//    .edgesIgnoringSafeArea(.bottom)
//    .ignoresSafeArea(keyboardManager.isVisible ? .bottom : nil)
    .fullScreenCover(isPresented: $oderview) {
      if self.RoomChat != nil{
        OderView(chatdata: self.RoomChat!, roomid: self.roomid)
      }
    }
//    .fullScreenCover(isPresented: $oderlistview) {
//      OderListView(rid: self.roomid)
//    }
    .fullScreenCover(isPresented: $odercheck) {
      OderCheckView(roomid: self.roomid)
    }
    .fullScreenCover(isPresented: $userodercheck) {
      UserOrderCheckView(roomid: self.roomid)
    }
    .accentColor(.black)
    .onChange(of: leave) { newValue in
      presentationMode.wrappedValue.dismiss()
    }

    .onAppear {
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
        }
      })
    }
    .onChange(of: RoomChat?.index, perform: { V in
      try! realm.write({
        if RoomChat != nil {
          RoomChat!.confirmation = RoomChat!.index
        }
      })
    })
    .onDisappear {
      let realm = try! Realm()
      if self.leave {
        self.RoomChat = nil
        try! realm.write({
          realm.delete(roomidtodbconnect(rid: self.roomid)!)
        })
      } else{
          try! realm.write({
            if RoomChat != nil {
              RoomChat!.confirmation = RoomChat!.index
            }
          })
      }
      
    }
  }
  
}
