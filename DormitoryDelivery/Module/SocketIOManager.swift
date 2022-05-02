import Foundation
import SocketIO
import SwiftUI
import Combine
import Alamofire
import RealmSwift

class SocketIOManager:NSObject {
  static let shared = SocketIOManager()
  override init() {
      super.init()
      socket = self.manager.defaultSocket
      matchSocket = self.manager.socket(forNamespace: "/match")
      roomSocket = self.manager.socket(forNamespace: "/room")
    }

  lazy var manager = SocketManager(socketURL: URL(string: serverurl)!, config: [.log(false), .compress, .reconnectAttempts(-1)])
  var socket : SocketIOClient!
  var matchSocket : SocketIOClient!
  var roomSocket : SocketIOClient!
  
  func tokenChangeReconnect() {
    let tk = TokenUtils()
    guard let token = tk.read() else { return }
    matchSocket.connect(withPayload: ["token":"Bearer \(token)"])
    roomSocket.connect(withPayload: ["token":"Bearer \(token)"])
  }
  
  func leave() {
    matchSocket.leaveNamespace()
    roomSocket.leaveNamespace()
  }
  
  func establishConnection(token: String, roomdata: RoomData, dormis: dormitoryData) {
    matchSocket.off("connect")
    matchSocket.on("connect") { data, ack in
      SocketIOManager.shared.match_emitSubscribe(rooms: roomdata, section: dormis.data.map({ dormitory in
        dormitory.id
      }), category: categoryNameEng)

      SocketIOManager.shared.match_onArrive(rooms: roomdata)
    }
    roomSocket.off("connect")
    roomSocket.on("connect") { data, ack in
      SocketIOManager.shared.room_onChat()
    }
    
//    matchSocket.off(clientEvent: .ping)
//    matchSocket.on(clientEvent: .ping, callback: { (data, ack) in
//      print("ping  :", data, ack)
//    })
//
//    matchSocket.off(clientEvent: .pong)
//    matchSocket.on(clientEvent: .pong, callback: { (data, ack) in
//      print("pong :", data, ack)
//    })
    
    matchSocket.off(clientEvent: .error)
    matchSocket.on(clientEvent: .error, callback: { (data, ack) in
//      print("socket :", data, ack)
      guard let error = data as? Array<Dictionary<String, String>>,
            let message = error.first?["message"]
      else { return }
      
      if message == "Authentication failed" {
        self.tokenChangeReconnect()
      }
    })
    
    roomSocket.off(clientEvent: .error)
    roomSocket.on(clientEvent: .error, callback: { (data, ack) in
//      print("socket :", data, ack)
      guard let error = data as? Array<Dictionary<String, String>>,
            let message = error.first?["message"]
      else { return }
      
      if message == "Authentication failed" {
        self.tokenChangeReconnect()
      }
    })
    
//    matchSocket.off(clientEvent: .statusChange)
//    matchSocket.on(clientEvent: .statusChange, callback: { (data, ack) in
//      print("statusChange :", data, ack)
//    })
//
//    matchSocket.off(clientEvent: .reconnect)
//    matchSocket.on(clientEvent: .reconnect, callback: { (data, ack) in
//      print("reconnect :", data, ack)
//    })
//
//    matchSocket.off(clientEvent: .reconnectAttempt)
//    matchSocket.on(clientEvent: .reconnectAttempt, callback: { (data, ack) in
//      print("reconnectAttempt :", data, ack)
//    })
    
    
    matchSocket.connect(withPayload: ["token": token])
    roomSocket.connect(withPayload: ["token": token])
  }

    func closeConnection(){
      print("연결 해제")
//        socket.disconnect()
        matchSocket.disconnect()
        roomSocket.disconnect()
    }
    
  func match_emitSubscribe(rooms:RoomData, section: [Int], category: [String]){
//    rooms.data = nil
    print("구독시작")
    if SocketIOManager.shared.matchSocket.status.active {
      let subscribeform = homeViewOption(category: category, section: section)
      SocketIOManager.shared.matchSocket.off("subscribe")
      SocketIOManager.shared.matchSocket.emitWithAck("subscribe",     subscribeform).timingOut(after: 2, callback: { (data) in
  //        if data[0] as? String != "NO ACK" {
        guard let data = try? JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted),
              let sessions = try? JSONDecoder().decode(roomsdata.self, from: data)
        else { return }
        rooms.data = sessions
      })
    } else {// 소켓 상태 이프
      rooms.data = nil
    }
  
  }
  
  func match_onArrive(rooms:RoomData) {
    print("On 시작")
    SocketIOManager.shared.matchSocket.off("new-arrive")
    SocketIOManager.shared.matchSocket.on("new-arrive") { (dataArray, ack) in
      print(dataArray, ack)
      guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted),
            let session = try? JSONDecoder().decode(roomdata.self, from: data)
      else { return }
      print(session)
      rooms.data!.data.append(session)
    }
    
    SocketIOManager.shared.matchSocket.off("update")
    SocketIOManager.shared.matchSocket.on("update") { (dataArray, ack) in
      guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted),
            let session = try? JSONDecoder().decode(roomdata.self, from: data)
      else { return }
      
      var updateNil = true
      for (idx, room) in rooms.data!.data.enumerated() {
        if session.id == room.id {
          rooms.data!.data[idx].total = session.total
          updateNil = false
          break
//              rooms.data!.data[idx] = session
        }
      }
      if updateNil {
        rooms.data!.data.append(session)
      }
    }
    
    SocketIOManager.shared.matchSocket.off("closed")
    SocketIOManager.shared.matchSocket.on("closed") { (dataArray, ack) in
      print(dataArray, ack)
      guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted),
            let session = try? JSONDecoder().decode(roomdata.self, from: data)
      else { return }
      
      for (idx, room) in rooms.data!.data.enumerated() {
        if session.id == room.id {
          rooms.data!.data.remove(at: idx)
          break
        }
      }
    }
  }
  
  func room_onChat(){
    print("룸온")
    SocketIOManager.shared.roomSocket.off("chat")
    SocketIOManager.shared.roomSocket.on("chat") { (dataArray, ack) in
      guard let json = dataArray[0] as? Dictionary<String, AnyObject>,
            let jsonMessagesArray = json["messages"] as? NSArray,
            let rid = json["rid"] as? String,
            let jsonMessagesObject = jsonMessagesArray.firstObject,
            let dataMessages = try? JSONSerialization.data(withJSONObject: jsonMessagesObject, options: .prettyPrinted),
            let messages = try? JSONDecoder().decode(ChatMessageDetail.self, from: dataMessages)
      else { return }
      
      let realm = try! Realm()
      let user = realm.objects(UserPrivacy.self)[0]
      let chatroom = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
      
      try! realm.write {
        realm.add(messages, update: .modified)
        
        chatroom?.messages.append(messages)
        if messages.body?.action == "order-fixed" {
          getRoomUpdate(rid: rid)
        } else if messages.body?.action == "users-new" {
          getParticipantsUpdate(rid: rid)
        } else if messages.body?.action == "users-leave" {
          getParticipantsUpdate(rid: rid)
        } else if messages.body?.action == "users-leave-kick" {
          if messages.body!.data!.userId == user.id {
            chatroom?.Kicked = true
          } else{
//            let leaveuser = chatroom?.member.filter("userId == '\(messages.body!.data!.userId!)'")
//            realm.delete(leaveuser!)
          }
          getParticipantsUpdate(rid: rid)
        } else if messages.body?.action == "users-leave-vote" {
          if messages.body!.data!.userId == user.id {
            chatroom?.Kicked = true
          } else{
//            let leaveuser = chatroom?.member.filter("userId == '\(messages.body!.data!.userId!)'")
//            realm.delete(leaveuser!)
          }
          getParticipantsUpdate(rid: rid)
        } else if messages.body?.action == "all-ready" {
          getRoomUpdate(rid: rid)
        } else if messages.body?.action == "all-ready-canceled" {
          getRoomUpdate(rid: rid)
        } else if messages.body?.action == "order-checked" {
          getRoomUpdate(rid: rid)
        } else if messages.body?.action == "order-finished" {
          getRoomUpdate(rid: rid)
        } else if messages.type == "chat" {
          chatroom?.sortforat = Int(messages.at!)!
        }
        
      }
      



      
      
//      do {
//        print("뭐가 오긴함")
//        var jsonResult = dataArray[0] as? Dictionary<String, AnyObject>
////        print(jsonResult)
//
//        if let messages = jsonResult?["messages"] as? NSArray {
//          let message = try! JSONSerialization.data(withJSONObject: messages.firstObject!, options: .prettyPrinted)
//  //          print(messages)
//  //          print(String(data: messages, encoding: .utf8)!)
//          let json = try JSONDecoder().decode(ChatMessageDetail.self, from: message)
//
//          let realm = try! Realm()
//          let user = realm.objects(UserPrivacy.self)[0]
////           print(type(of: jsonResult!["rid"]!))
//          let chatroom = realm.object(ofType: ChatDB.self, forPrimaryKey: jsonResult!["rid"]!)    /// 수정 필요
//          try! realm.write {
//            realm.add(json, update: .modified)
////            getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
////            getParticipantsUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//
//            chatroom?.messages.append(json)
//            if json.body?.action == "order-fixed" {
////              chatroom?.state?.allReady = false
////              chatroom?.state?.orderFix = true
//              getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//            } else if json.body?.action == "users-new" {
//              getParticipantsUpdate(rid: jsonResult!["rid"] as! String)
////              if json.body?.data?.userId != user.id {
////                let userinfo = ChatUsersInfo()
////                userinfo.userId = json.body?.data?.userId
////                userinfo.name = json.body?.data?.name
////                chatroom?.member.append(userinfo)
////              }
//            } else if json.body?.action == "users-leave" {
//              let leaveuser = chatroom?.member.filter("userId == '\(json.body!.data!.userId!)'")
//              realm.delete(leaveuser!)
//            } else if json.body?.action == "users-leave-kick" {
//              if json.body!.data!.userId == user.id {
//                chatroom?.Kicked = true
//              } else{
//                let leaveuser = chatroom?.member.filter("userId == '\(json.body!.data!.userId!)'")
//                realm.delete(leaveuser!)
//              }
//            } else if json.body?.action == "users-leave-vote" {
//              if json.body!.data!.userId == user.id {
//                chatroom?.Kicked = true
//              } else{
//                let leaveuser = chatroom?.member.filter("userId == '\(json.body!.data!.userId!)'")
//                realm.delete(leaveuser!)
//              }
//            } else if json.body?.action == "all-ready" {
////              chatroom?.state?.allReady = true
//              getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//            } else if json.body?.action == "all-ready-canceled" {
////              chatroom?.state?.allReady = false
//              getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//            } else if json.body?.action == "order-checked" {
////              chatroom?.state?.orderChecked = true
//              getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//            } else if json.body?.action == "order-finished" {
////              chatroom?.state?.orderDone = true
//              getRoomUpdate(rid: jsonResult!["rid"] as! String) ////////////
//
//            } else if json.type == "chat" {
//              chatroom?.index += 1
//              chatroom?.sortforat = Int(json.at!)!
//            }
//          }
//
//        }
//
////        let data = try! JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
////        print("파싱결과")
//  //        print(String(data: data, encoding: .utf8)!)
//  //        let json = try JSONDecoder().decode(ChatDB.self, from: data)
//  //        addChatting(json)
//
////        print("암것도아님")
//      } catch {
//        print(error)
//      }
      }
  }
  
  func room_emitChat(rid: String, text: String) {
    print("채팅전송")
    let chatEmitData = chatEmitData(roomId: rid, message: text)
    SocketIOManager.shared.roomSocket.emitWithAck("chat", chatEmitData).timingOut(after: 2, callback: { (data) in
      print(data)
    })
  }
  
  
}
