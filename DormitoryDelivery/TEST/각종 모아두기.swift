//
//  각종 모아두기.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

//import Foundation



//        Image("LaunchScreenImage")
//          .resizable()
//          .aspectRatio(contentMode: .fill)
//          .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        




//if self.isAnimating && RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.allReady == true && self.showMenu == false {
//  Button {
//    if let mytoken = naverLogin.loginInstance?.accessToken {
//    postOderFix(rid: self.roomid, token: mytoken)
//    }
//  } label: {
//    VStack{
//      Text("모두가 준비했습니다.")
//      Text("주문을 진행하시겠습니까?")
//    }
//    .frame(width: geo.size.width * 9/10, height: 60)
//    .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 0.9))
//    .cornerRadius(5)
//  }
////          .offset(y: -geo.size.height/2 + 45)
//  .transition(AnyTransition.opacity.animation(.easeInOut(duration: 3).repeatForever()))
//} // 방장 메뉴 오더 픽스 이벤트
//
//
//if self.isAnimating && RoomChat?.superUser!.userId! == UserDefaults.standard.string(forKey: "MyID")! && RoomChat?.state?.orderFix != false && RoomChat?.state?.orderChecked != true && self.showMenu == false {
//  Button {
//    self.odercheck.toggle()
//  } label: {
//    Text("주문 사진과 배달 금액을 입력해주세요.")
//      .frame(width: geo.size.width * 9/10, height: 60)
//      .background(Color(.sRGB, red: 165/255, green: 166/255, blue: 246/255, opacity: 0.9))
//      .cornerRadius(5)
//  }
////          .offset(y: -geo.size.height/2 + 45)
//  .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1).repeatForever()))
//} // 방장 메뉴 확인 이벤트











//
//
//class User: ObservableObject{
//    @Published var isLoggedIn: Bool {
//        didSet {
//            UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
//        }
//    }
//
//    init() {
//      self.isLoggedIn = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false
//    }
//}
//
//
//
//struct UserSession : Codable {
//  var sessionId : String
//}
//
//struct UserToken : Codable {
//  var token : String
//}
//
//final class UserSessions: NSObject, ObservableObject  {
//  @Published var sessionIds: String
//
//  override init() {
//    self.sessionIds = "haha"
//  }
//}
//
//
//struct Ontest : Codable {
//  var id : String
//  var shopName : String
//  var section : String
//  var total : Int
//  var tip : Int
//
//}
//
//
//class _UserSession: ObservableObject{
//    @Published var sessionId: String {
//        didSet {
//            UserDefaults.standard.set(sessionId, forKey: "sessionId")
//        }
//    }
//  @Published var sessionId2: String {
//      didSet {
//          UserDefaults.standard.set(sessionId2, forKey: "sessionId2")
//      }
//  }
//
//    init() {
//      self.sessionId = UserDefaults.standard.object(forKey: "sessionId") as? String ?? ""
//      self.sessionId2 = UserDefaults.standard.object(forKey: "sessionId2") as? String ?? ""
//    }
//}
//
////
////struct TTTest: Codable {
//////    var id: String
//////    var section: String
//////    var shopName: String
//////    var tip: Int
//////    var total: Int
////
////  var id: String;
////  var shopName: String;
////  var section: String;
////  var total: Int;
////  var priceAtLeast: Int;
////  var purchaserName: String;
////  var createdAt: Int;
////}
////
////struct TTest: Codable {
////    var data: Array<TTTest>
////    var status: Int
////}
//
//
////final class ModelData: ObservableObject {
////    @Published var landmarks: [Landmark] = load("landmarkData.json")
////}
//
//
//
//class StateLogin: ObservableObject{
//    @Published var login: String {
//        didSet {
//            UserDefaults.standard.set(login, forKey: "StateLogin")
//        }
//    }
//
//  @Published var token: String {
//      didSet {
//          UserDefaults.standard.set(token, forKey: "Token")
//      }
//  }
//
//    init() {
//      self.login = UserDefaults.standard.object(forKey: "StateLogin") as? String ?? ""
//      self.token = UserDefaults.standard.object(forKey: "Token") as? String ?? ""
//
//    }
//}






//class NaverToken: ObservableObject{
//  @Published var RToken: String {
//    didSet {
//        UserDefaults.standard.set(RToken, forKey: "RefreshToken")
//    }
//  }
//
//
//  init() {
//    self.RToken = UserDefaults.standard.object(forKey: "RefreshToken") as? String ?? ""
//  }
//}
