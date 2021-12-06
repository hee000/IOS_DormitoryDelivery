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
  lazy var manager = SocketManager(socketURL: URL(string: serverurl)!, config: [.log(false), .compress,   .connectParams([
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
          let session = try JSONDecoder().decode(roomsdata.self, from: data2)
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
  
//  func newArriveOn(){
//    print("On 시작")
//    
//      socket.on("new-arrive") { (dataArray, ack) in
//        do {
//          var data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
////          let session = try JSONDecoder().decode(Ontest.self, from: data)
//          print(session)
//          print(session.tip)
//        }
//        catch {
//          print(error)
//        }
//      }
//  }
  
  
}
