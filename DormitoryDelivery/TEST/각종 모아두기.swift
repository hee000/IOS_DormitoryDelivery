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
