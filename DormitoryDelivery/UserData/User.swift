import Foundation
import Combine

//class UserSettings: ObservableObject {
//    @Published var username: String {
//        didSet {
//            UserDefaults.standard.set(username, forKey: "username")
//        }
//    }
//
//    init() {
//        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
//    }
//}


class User: ObservableObject{
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
        }
    }
    
    init() {
      self.isLoggedIn = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false
    }
}



struct UserSession : Codable {
  var sessionId : String
}

struct UserToken : Codable {
  var token : String
}

final class UserSessions: NSObject, ObservableObject  {
  @Published var sessionIds: String
  
  override init() {
    self.sessionIds = "haha"
  }
}


struct Ontest : Codable {
  var id : String
  var shopName : String
  var section : String
  var total : Int
  var tip : Int

}


class _UserSession: ObservableObject{
    @Published var sessionId: String {
        didSet {
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
        }
    }
  @Published var sessionId2: String {
      didSet {
          UserDefaults.standard.set(sessionId2, forKey: "sessionId2")
      }
  }
    
    init() {
      self.sessionId = UserDefaults.standard.object(forKey: "sessionId") as? String ?? ""
      self.sessionId2 = UserDefaults.standard.object(forKey: "sessionId2") as? String ?? ""
    }
}


struct TTTest: Codable {
//    var id: String
//    var section: String
//    var shopName: String
//    var tip: Int
//    var total: Int
  
  var id: String;
  var shopName: String;
  var section: String;
  var total: Int;
  var priceAtLeast: Int;
  var purchaserName: String;
  var createdAt: Int;
}

struct TTest: Codable {
    var data: Array<TTTest>
    var status: Int
}


//final class ModelData: ObservableObject {
//    @Published var landmarks: [Landmark] = load("landmarkData.json")
//}



class StateLogin: ObservableObject{
    @Published var login: String {
        didSet {
            UserDefaults.standard.set(login, forKey: "StateLogin")
        }
    }
  
  @Published var token: String {
      didSet {
          UserDefaults.standard.set(token, forKey: "Token")
      }
  }
    
    init() {
      self.login = UserDefaults.standard.object(forKey: "StateLogin") as? String ?? ""
      self.token = UserDefaults.standard.object(forKey: "Token") as? String ?? ""

    }
}
