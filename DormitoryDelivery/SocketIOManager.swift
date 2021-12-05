import Foundation
import SocketIO
import SwiftUI
import Combine
import Alamofire

class SocketIOManager:NSObject {
  static let shared = SocketIOManager()
  override init() {
        super.init()
  //      socket = self.manager.defaultSocket
    socket = self.manager.socket(forNamespace: "/match")
//    manager.connectSocket(socket, withPayload: ["auth": UserDefaults.standard.string(forKey: "sessionId")!])
    
    }
  
//    .forceNew(true)
  lazy var manager = SocketManager(socketURL: URL(string: "http://192.168.10.104:3000/")!, config: [.log(false), .compress,   .connectParams([
//    "EIO" : 3,
//    "auth": UserDefaults.standard.string(forKey: "sessionId")!,
//    "Authorization": "{auth : "+UserDefaults.standard.string(forKey: "sessionId")!+"}",
    "d": "D",
  ]) ])
  
    var socket : SocketIOClient!
  
    func establishConnection(){
      print("연결시작")
      let tokenvalue = UserDefaults.standard.string(forKey: "AccessToken")!
      
      let usertoken: [String: Any] = [
          "token": tokenvalue,
      ] as Dictionary
      
      socket.connect(withPayload: ["auth": usertoken])
      print("연결성공")
    }

    func closeConnection(){
      print("연결 해제")
        socket.disconnect()
    }
    
    func createEmit(){
      let deliveryTipsInterval: [String: Any] = [
          "price": 5000,
          "tip": 500,
      ] as Dictionary

      let createForm: [String: Any] = [
          "userId": "qwer",
          "shopName": "버거킹",
          "deliveryPriceAtLeast": 3000,
          "deliveryTipsInterval": [deliveryTipsInterval],
          "category": "korean",
          "section": "Narae",
      ] as Dictionary
      print("방 만듬")
      
      socket.emitWithAck("create", createForm).timingOut(after: 2, callback: { (data) in
//              print(data)
      })

    }
  
    func subscribeEmit(){
      let subscribeForm: [String: Any] = [
          "userId": "qwer",
          "category": "korean",
      ] as Dictionary
      
      
      print("구독시작")
      socket.emitWithAck("subscribe", subscribeForm).timingOut(after: 2, callback: { (data) in
//        print(data[0])
        do {
          let data2 = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
//          print(String(data: data2, encoding: .utf8)!)
          let session = try JSONDecoder().decode(TTest.self, from: data2)
//          print(session.data)
//          print(session.data[0])
//          print(session.data[1])
//          print(session.data[1].shopName)
//          print(Int("14")!)
        }
        catch {
          print(error)
        }
      })
//      socket.emit("subscribe", subscribeForm) {
//        print("구독성공")
//      }
      
    }
  
  func newArriveOn(){
    print("On 시작")
    
      socket.on("new-arrive") { (dataArray, ack) in
        do {
          var data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
          let session = try JSONDecoder().decode(Ontest.self, from: data)
          print(session)
          print(session.tip)
        }
        catch {
          print(error)
        }
      }
  }
  
}


  










//import Foundation
//import SocketIO
//import SwiftUI
//import Combine
//import Alamofire
//
//class SocketIOManager:NSObject {
//  static let shared = SocketIOManager()
//  override init() {
//        super.init()
//  //      socket = self.manager.defaultSocket
//    socket = self.manager.socket(forNamespace: "/match")
////    manager.connectSocket(socket, withPayload: ["auth": UserDefaults.standard.string(forKey: "sessionId")!])
//
//    }
//
////    .forceNew(true)
//  lazy var manager = SocketManager(socketURL: URL(string: "http://localhost:3010/")!, config: [.log(false), .compress,	 .connectParams([
////    "EIO" : 3,
////    "auth": UserDefaults.standard.string(forKey: "sessionId")!,
////    "Authorization": "{auth : "+UserDefaults.standard.string(forKey: "sessionId")!+"}",
//    "d": "D",
//  ]) ])
//
//    var socket : SocketIOClient!
//
//    func establishConnection(){
//      let tokenvalue = UserDefaults.standard.string(forKey: "sessionId2")!
////      var token = UserToken(token: tokenvalue)
//
//      let usertoken: [String: Any] = [
//          "token": tokenvalue,
//      ] as Dictionary
////      let encoder = JSONEncoder()
////      //      encoder.outputFormatting = .prettyPrinted //
////      do {
////        let data = try encoder.encode(token)
////        print(String(data: data, encoding: .utf8)!)
////        print(data)
////        socket.connect(withPayload: ["auth": token])
////      } catch {
////        print(error.localizedDescription)
////      }
//      socket.connect(withPayload: ["auth": usertoken])
////      print(data)
////      socket.connect(withPayload: ["auth": UserDefaults.standard.string(forKey: "sessionId")!])
////      print("========================")
////      print("========================")
////      print(UserDefaults.standard.string(forKey: "sessionId")!)
//    }
//
//    func closeConnection(){
//        socket.disconnect()
//    }
//
//    func test2(){
////      socket.on("subscribe") { dataArray, ack in
////        print("========================")
////        print(dataArray)
////        print("========================")
////      }
//
////      socket.on("subscribe") { (dataArray, ack) in
////        print(dataArray)
////      }
////      socket.on("subscribe") { (dataArray, ack) in
////          print("on test")
////      }
////
////      socket.emit("join", [["userId": "qwer"], ["matchIda": "asdd"]])
//
//      let deliveryTipsInterval: [String: Any] = [
//          "price": 5000,
//          "tip": 500,
//      ] as Dictionary
//
//      let createForm: [String: Any] = [
//          "userId": "qwer",
//          "shopName": "버거킹",
//          "deliveryPriceAtLeast": 3000,
//          "deliveryTipsInterval": [deliveryTipsInterval],
//          "category": "korean",
//          "section": "Narae",
//      ] as Dictionary
//
////      socket.emitWithAck("create", createForm) {data in
////        print(data)
////      }
//      socket.emitWithAck("create", createForm).timingOut(after: 2, callback: { (data) in
////              print(data)
//      })
//
//
////      let subscribeForm: [String: Any] = [
////          "userId": "qwer",
////          "category": "korean",
////      ] as Dictionary
////
//////      socket.emit("subscribe", subscribeForm)
////
////      socket.emitWithAck("subscribe", subscribeForm).timingOut(after: 2, callback: { (data) in
////
////              print(data)
////      })
//    }
//
//    func test3(){
////      socket.on("subscribe") { (dataArray, ack) in
////          print(dataArray)
////          print(ack)
////        print("ASD")
////      }
//
//      let subscribeForm: [String: Any] = [
//          "userId": "qwer",
//          "category": "korean",
//      ] as Dictionary
//
////      socket.emit("subscribe", subscribeForm)
//
//      socket.emitWithAck("subscribe", subscribeForm).timingOut(after: 2, callback: { (data) in
////              print(data)
//      })
//
//    }
//
//  func test4(){
//      socket.on("new-arrive") { (dataArray, ack) in
////          print(dataArray)
////          print(ack)
////        print(dataArray)
//        do {
////          print("Hhahahaha")
////          print(dataArray)
//          var data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
//
////          print("test")
//          let session = try JSONDecoder().decode(Ontest.self, from: data)
////                  session.sessionId
////          print(String(data: data, encoding: .utf8)!)
//          print(session)
//          print(session.tip)
////                  uersd.sessionId = session.sessionId
//        }
//        catch {
//          print(error)
//        }
//      }
//  }
//
//}
//
//
//
