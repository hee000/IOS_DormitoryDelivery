//
//  MessageView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/18.
//

import SwiftUI
import RealmSwift

class ObservedChatDB: ObservableObject {
  @Published var db: ChatDB?
  @Published var dbWrite: ChatDB?
  @Published var dbCount: ReversedCollection<(Range<Int>)>
  private var token: NotificationToken?
  private var rid: String
  
  init(roomid: String) {
    rid = roomid
    let realm = try! Realm()
    if let isdb = realm.object(ofType: ChatDB.self, forPrimaryKey: roomid) {
      db = isdb.freeze()
      dbWrite = isdb
    } else {
      db = nil
      dbWrite = nil
    }
    dbCount = (0..<(realm.object(ofType: ChatDB.self, forPrimaryKey: roomid)?.messages.count ?? 0)).reversed()
    activateChannelsToken()
  }
  
  deinit {
      print("채팅방 디비 deinit")
  }
  
  func pressDeninit() {
    self.token = nil
    self.db = nil
    print("강제채팅방 디비 deinit")
  }
  private func activateChannelsToken() {
    let realm = try! Realm()
    let channel = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
    guard let trueDB = channel else { return }
    token = trueDB.observe { change in
      switch change {
      case .change(let object, let properties):
        
        if !properties.contains{$0.name == "messages"} && properties.contains { $0.name == "sortforat"} || properties.contains{$0.name == "confirmation"} {
          break
        }
        print(properties)
//          for property in properties {
//            print("Property '\(property.name)' of old \(property.oldValue) changed to '\(property.newValue!)'")
//          }
        self.dbCount = (0..<trueDB.messages.count).reversed()
        self.db = trueDB.freeze()
        self.dbWrite = trueDB
      case .error(let error):
          print("An error occurred: \(error)")
      case .deleted:
          print("The object was deleted.")
        self.db = nil
      }
//      self.db = trueDB
    }
    
  }
}

//class ObservedMessagesDB: ObservableObject, Identifiable {
//  @Published var db: [ChatMessageDetail]
//  private var token: NotificationToken?
//  private var rid: String
//
//  init(roomid: String) {
//    rid = roomid
//    let realm = try! Realm()
//    db = realm.object(ofType: ChatDB.self, forPrimaryKey: roomid)!.messages.map { $0 }
//    activateChannelsToken()
//  }
//
//  private func activateChannelsToken() {
//    let realm = try! Realm()
//    let channel = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)?.messages
//    guard let trueDB = channel else { return }
//    token = trueDB.observe { change in
//      print("채팅업뎃")
//      self.db = trueDB.map{$0}
//    }
//
//  }
//}


struct MessageView: View {
//  @ObservedRealmObject var chatdb: ChatDB
  @ObservedObject var blockedUser = BlockedUserData()

  @StateObject var chatdb: ObservedChatDB
//  @ObservedObject var chatdb: ObservedChatDB
//  @StateObject var messagesdb: ObservedMessagesDB
  @StateObject var chatmodel: Chatting

  @State private var maxNumber: Int = 30
  
  var rid: String
  
  
  init(roomid: String, chatmodel: Chatting, chatdb: ObservedChatDB) {
//    self._chatdb = ObservedObject(wrappedValue: chatdb)
    self._chatdb = StateObject(wrappedValue: chatdb)
//    self._chatdb = StateObject(wrappedValue: ObservedChatDB(roomid: roomid))
//    self._messagesdb = StateObject(wrappedValue: ObservedMessagesDB(roomid: roomid))
    self._chatmodel = StateObject(wrappedValue: chatmodel)
    
    self.rid = roomid
    
//    let realm = try! Realm()
//    self.chatdb = realm.object(ofType: ChatDB.self, forPrimaryKey: roomid)!
  }
  
    var body: some View {
      GeometryReader { scrollgeo in
        ScrollViewReader { proxy in
          ScrollView {
            Spacer().frame(height: 10) // 패딩
              LazyVStack(spacing: 0) {
                if chatdb.db != nil {
//                  ForEach(chatdb.db!.messages.indices, id: \.self) { index in
                  ForEach(chatdb.dbCount, id: \.self) { index in
                    HStack{
                    if chatdb.db!.messages[index].type == "chat" {
                        if chatdb.db!.messages[index].body!.userid == UserData().data?.id { // 내 매세지
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .right, index: index)
                        } else { // 상대방
                          if !(blockedUser.data.contains { BlockedUser in
                            BlockedUser.userId == chatdb.db?.messages[index].body?.userid
                          }) { // 차단기능
                            if index != 0 { // 상대방 처음
                              if chatdb.db!.messages[index - 1].type == "system" || chatdb.db!.messages[index].body!.userid != chatdb.db!.messages[index - 1].body!.userid{
                                Message(model:chatmodel, RoomDB: chatdb.db!, type: .newLeft, index: index)
                              } else { // 상대 처음 이후
                                Message(model:chatmodel, RoomDB: chatdb.db!, type: .left, index: index)
                              }
                            } else {//index 0인지?
                                Message(model:chatmodel, RoomDB: chatdb.db!, type: .newLeft, index: index)
                            }
                          }
                          
                        }
                      } else { // 시스템 메시지
                        if chatdb.db!.messages[index].body!.action! == "users-new" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(chatdb.db!.messages[index].body!.data!.name!)님이 참여했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if chatdb.db!.messages[index].body!.action! == "users-leave" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(chatdb.db!.messages[index].body!.data!.name!)님이 퇴장했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if chatdb.db!.messages[index].body!.action! == "users-leave-kick" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(chatdb.db!.messages[index].body!.data!.name!)님이 강퇴되었습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if chatdb.db!.messages[index].body!.action! == "users-leave-vote" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("\(chatdb.db!.messages[index].body!.data!.name!)님이 투표에 의해 강퇴되었습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if chatdb.db!.messages[index].body!.action! == "order-fixed" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .orderFixed, index: index)
                        } else if chatdb.db!.messages[index].body!.action! == "order-checked" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .orderChecked, index: index)
                        } else if chatdb.db!.messages[index].body!.action! == "order-finished" {
                          ChatBubble(position: BubblePosition.systemuUserInOut, color: Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1)) {
                            Text("방장이 주문을 완료했습니다.")
                              .font(.system(size: 12, weight: .regular))
                          }
                        } else if chatdb.db!.messages[index].body!.action! == "vote-kick-created" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .voteKickCreated, index: index)
                        }
                        else if chatdb.db!.messages[index].body!.action! == "vote-kick-finished" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .voteKickFinished, index: index)
                        }
                        else if chatdb.db!.messages[index].body!.action! == "vote-reset-created" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .voteResetCreated, index: index)
                        }
                        else if chatdb.db!.messages[index].body!.action! == "vote-reset-finished" {
                          Message(model:chatmodel, RoomDB: chatdb.db!, type: .voteResetFinished, index: index)

                        }
                      }
                    }//v
                    .rotationEffect(Angle(degrees: 180))
//                    .padding([.top, .bottom], 1.5)

                    
                    } //for
                  } //if
                } //lazyV
//                .disabled(chatdb.db?.Kicked ?? false ? true : false)
//            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            Spacer().frame(height: 10) // 뒤집힌 스크롤 하단 패딩
          } //scrollview
          .rotationEffect(Angle(degrees: 180))
          .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        }//reader
      }//geo
      .clipped()
      .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
      .onTapGesture {
        hideKeyboard()
      }
    }
}


