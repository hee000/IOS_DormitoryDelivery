import Foundation
import SocketIO
import Combine
import Alamofire
import RealmSwift

struct chatEmitData: Codable, SocketData {
  var roomId: String
  var message: String

  func socketRepresentation() -> SocketData {
      return ["roomId": roomId, "message": message]
  }
}

struct chatIdxEmitData: Codable, SocketData {
  var roomId: String
  var messageId: Int

  func socketRepresentation() -> SocketData {
      return ["roomId": roomId, "messageId": messageId]
  }
}

struct messageIds: Codable {
  var roomId: String
  var messageIds: List<ChatRead>
}

class SocketIOManager:NSObject {
  static let shared = SocketIOManager()
  override init() {
      super.init()
      socket = self.manager.defaultSocket
      matchSocket = self.manager.socket(forNamespace: "/match")
      roomSocket = self.manager.socket(forNamespace: "/room")
    }

  lazy var manager = SocketManager(socketURL: URL(string: serverurl)!, config: [.log(false), .compress, .reconnectAttempts(-1), .forceNew(false), .forceWebsockets(false)])
  var socket : SocketIOClient!
  var matchSocket : SocketIOClient!
  var roomSocket : SocketIOClient!
  
  func tokenChangeReconnect() {
    restApiQueue.async {
      let tk = TokenUtils()
      guard let token = tk.read() else { return }
      DispatchQueue.main.async {
        self.manager.disconnect()
        
        self.matchSocket.connect(withPayload: ["token":"Bearer \(token)"])
        self.roomSocket.connect(withPayload: ["token":"Bearer \(token)"])
        
        self.manager.reconnect()
      }
    }
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
      SocketIOManager.shared.room_readIdUpdated()
      SocketIOManager.shared.room_participantStateChanged()
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
      guard let subscribeform = try? homeViewOption(category: category, section: section).asDictionary() else { return }
      SocketIOManager.shared.matchSocket.off("subscribe")
      SocketIOManager.shared.matchSocket.emitWithAck("subscribe", subscribeform).timingOut(after: 2, callback: { (data) in
//        print("preif", data)
        if data[0] as? String != "NO ACK" {
  //        print(data)
//          print("if", data)
          guard let json = data.first,
                let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                let sessions = try? JSONDecoder().decode(roomsdata.self, from: data)
          else { return }
          rooms.data = sessions
        }
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
      if rooms.data != nil {
        rooms.data!.data.append(session)
      }
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
      if updateNil && rooms.data != nil {
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
      
//      let realm = try! Realm()
//      let user = realm.objects(UserPrivacy.self)[0]
//      let chatroom = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
      
      realmQueue.async {
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
          } else if messages.body?.action == "vote-reset-finished" {
            getRoomUpdate(rid: rid)
          } else if messages.type == "chat" {
            chatroom?.sortforat = Int(messages.at!)!
          }
        } // realm write
      } //dispatch
    }
  }
  
  func room_emitChat(rid: String, text: String) {
    print("채팅전송")
    let chatEmitData = chatEmitData(roomId: rid, message: text)
    SocketIOManager.shared.roomSocket.emitWithAck("chat", chatEmitData).timingOut(after: 2, callback: { (data) in
      print(data)
    })
  }
  
  func room_emitChatIdx(rid: String, idx: Int) {
    print("리드 송신 중")
    let chatEmitData = chatIdxEmitData(roomId: rid, messageId: idx)
    
    
//    SocketIOManager.shared.roomSocket.emit("read", chatEmitData)
    SocketIOManager.shared.roomSocket.emitWithAck("read", chatEmitData).timingOut(after: 2, callback: { (data) in
//      print("송신성공", data)
    })
    
  }
  
  func room_readIdUpdated() {
    print("리드 온")
    SocketIOManager.shared.roomSocket.off("readIdUpdated")
    SocketIOManager.shared.roomSocket.on("readIdUpdated") { (dataArray, ack) in
//      print("리드 수신", dataArray)
      guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted),
            let session = try? JSONDecoder().decode(messageIds.self, from: data)
      else { return }

      
//      let realm = try! Realm()
//      let db = realm.object(ofType: ChatDB.self, forPrimaryKey: session.roomId)
      realmQueue.async {
        let realm = try! Realm()
        let db = realm.object(ofType: ChatDB.self, forPrimaryKey: session.roomId)
  //      print(session)
        try! realm.write {
  //        session.messageIds.sel
          
          db?.read = session.messageIds
  //        db?.read.removeAll()
  //        db?.read.append(objectsIn: session.messageIds)
        } //write
      }
    }
  }
  
  func room_participantStateChanged() {
    print("준비 온")
    SocketIOManager.shared.roomSocket.off("participantStateChanged")
    SocketIOManager.shared.roomSocket.on("participantStateChanged") { (dataArray, ack) in
//      print("준비 수신", dataArray)
      guard let data = try? JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted),
            let session = try? JSONDecoder().decode(ChatUsersInfo.self, from: data)
      else { return }
//      print(session)

      
//      let realm = try! Realm()
//      let db = realm.object(ofType: ChatDB.self, forPrimaryKey: session.roomId)
      realmQueue.async {
        let realm = try! Realm()
        let db = realm.object(ofType: ChatDB.self, forPrimaryKey: session.roomId)
//  //      print(session)
        try! realm.write {
          guard let members = db?.member else { return }
          for i in members {
            if i.userId == session.userId {
              i.isReady = session.isReady
              break
            }
          }

//          db?.read = session.messageIds
//  //        db?.read.removeAll()
//  //        db?.read.append(objectsIn: session.messageIds)
        } //write
      }
    }
  }
  
}


