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

  lazy var manager = SocketManager(socketURL: URL(string: serverurl)!, config: [.log(false), .compress])
  var socket : SocketIOClient!
  var matchSocket : SocketIOClient!
  var roomSocket : SocketIOClient!
  
  
  
  func establishConnection(token: String, roomdata: RoomData) {
      print("연결시작")
      socket.connect(withPayload: ["token": token])
      matchSocket.connect(withPayload: ["token": token])
      roomSocket.connect(withPayload: ["token": token])
    
//    socket.on("connect") { data, ack in
//            socket.emit("connectWithNewId", UsersViewController.nickname)
    matchSocket.on("connect") { data, ack in
      SocketIOManager.shared.match_emitSubscribe(rooms: roomdata, section: sectionNameEng, category: categoryNameEng)
      SocketIOManager.shared.match_onArrive(rooms: roomdata)
    }
    roomSocket.on("connect") { data, ack in
      SocketIOManager.shared.room_onChat()
    }
    }

    func closeConnection(){
      print("연결 해제")
        socket.disconnect()
        matchSocket.disconnect()
    }
    
  func match_emitSubscribe(rooms:RoomData, section: [String], category: [String]){
    
//    rooms.data = nil
    do{
      let subscribeform = homeViewOption(category: category, section: section)
      print("구독시작22")
      SocketIOManager.shared.matchSocket.emitWithAck("subscribe", subscribeform).timingOut(after: 2, callback: { (data) in
        do {
          if data[0] as? String != "NO ACK" {
            let data2 = try JSONSerialization.data(withJSONObject: data[0], options: .prettyPrinted)
            let session = try JSONDecoder().decode(roomsdata.self, from: data2)
            rooms.data = session
          }
        }
        catch {
          print(error)
        }
      })
    } catch {
      print(error)
    }
    
  }
  
  func match_onArrive(rooms:RoomData) {
    print("On 시작")
    SocketIOManager.shared.matchSocket.off("new-arrive")
    SocketIOManager.shared.matchSocket.on("new-arrive") { (dataArray, ack) in
        do {
//          print(dataArray)
          let data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomdata.self, from: data)
          rooms.data!.data.append(session)
        }
        catch {
          print(error)
        }
      }
    
    SocketIOManager.shared.matchSocket.off("update")
    SocketIOManager.shared.matchSocket.on("update") { (dataArray, ack) in
        do {
          let data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomdata.self, from: data)
          for (idx, room) in rooms.data!.data.enumerated() {
            if session.id == room.id {
              rooms.data!.data[idx] = session
            }
          }
        }
        catch {
          print(error)
        }
      }
    
    SocketIOManager.shared.matchSocket.off("closed")
    SocketIOManager.shared.matchSocket.on("closed") { (dataArray, ack) in
        do {
          let data = try JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
          let session = try JSONDecoder().decode(roomdata.self, from: data)
          for (idx, room) in rooms.data!.data.enumerated() {
            if session.id == room.id {
              rooms.data!.data.remove(at: idx)
            }
          }
        }
        catch {
          print(error)
        }
      }
    
  }
  
  func room_onChat(){
    print("쳇온")
    SocketIOManager.shared.roomSocket.off("chat")
    SocketIOManager.shared.roomSocket.on("chat") { (dataArray, ack) in
//      print(dataArray)
//      print(ack)
      do {
//        print("뭐가 오긴함")
        var jsonResult = dataArray[0] as? Dictionary<String, AnyObject>

        if let messages = jsonResult?["messages"] as? NSArray {
          let message = try! JSONSerialization.data(withJSONObject: messages.firstObject!, options: .prettyPrinted)
  //          print(messages)
  //          print(String(data: messages, encoding: .utf8)!)
          let json = try JSONDecoder().decode(ChatMessageDetail.self, from: message)
          
          let realm = try! Realm()
          let user = realm.objects(UserPrivacy.self)[0]
//           print(type(of: jsonResult!["rid"]!))
          let chatroom = realm.object(ofType: ChatDB.self, forPrimaryKey: jsonResult!["rid"]!)    /// 수정 필요
          try! realm.write {
            chatroom?.messages.append(json)
            if json.body?.action == "order-fixed" {
              chatroom?.state?.allReady = false
              chatroom?.state?.orderFix = true
            } else if json.body?.action == "users-new" {
              let userinfo = ChatUsersInfo()
              userinfo.userId = json.body?.data?.userId
              userinfo.name = json.body?.data?.name
              chatroom?.member.append(userinfo)
            } else if json.body?.action == "users-leave" {
              if json.body!.data!.userId == user._id {
                chatroom?.Kicked = true
              } else{
                let leaveuser = chatroom?.member.filter("userId == '\(json.body!.data!.userId!)'")
                realm.delete(leaveuser!)
              }
            } else if json.body?.action == "all-ready" {
              chatroom?.state?.allReady = true
            } else if json.body?.action == "all-ready-canceled" {
              chatroom?.state?.allReady = false
            } else if json.body?.action == "order-checked" {
              chatroom?.state?.orderChecked = true
            } else if json.body?.action == "order-finished" {
              chatroom?.state?.orderDone = true
            } else if json.type == "chat" {
              chatroom?.index += 1
              chatroom?.sortforat = Int(json.at!)!
            }
          }
          
        }
        
//        let data = try! JSONSerialization.data(withJSONObject: dataArray[0], options: .prettyPrinted)
//        print("파싱결과")
  //        print(String(data: data, encoding: .utf8)!)
  //        let json = try JSONDecoder().decode(ChatDB.self, from: data)
  //        addChatting(json)
        
//        print("암것도아님")
      } catch {
        print(error)
      }
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
