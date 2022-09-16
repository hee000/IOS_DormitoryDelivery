//
//  ChatDB.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/07.
//

import Foundation
import RealmSwift
import Combine


//class ChatData : ObservableObject{
//  @Published var chatlist = ""
//}

let realm = try! Realm()

func roomidtodbconnect (rid: String) -> ChatDB? {
  return realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
}

func getUserPrivacy () -> UserPrivacy {
  return realm.objects(UserPrivacy.self)[0]
}

class ChatRead: Object, ObjectKeyIdentifiable, Codable {
  @Persisted var userId: String = ""
  @Persisted var messageId: Int = 0
}

class ChatDB: Object, ObjectKeyIdentifiable, Decodable{
  @Persisted var rid: String?
  @Persisted var superUser: ChatUsersInfo?
  @Persisted var state: ChatState? = ChatState()
//  @Persisted var state2: Int = 0
  @Persisted var title: String?
  @Persisted var member: List<ChatUsersInfo>
  @Persisted var readyAvailable: Bool = false
  @Persisted var ready: Bool = false
  @Persisted var messages: List<ChatMessageDetail>
  @Persisted var confirmation: Int = 0
  @Persisted var sortforat: Int = 0
  @Persisted var Kicked: Bool = false
  @Persisted var read: List<ChatRead>
  
  override class func primaryKey() -> String? {
    return "rid"
  }

  private enum CodingKeys: String, CodingKey {
      case rid = "rid"
      case title = "title"
      case messages = "messages"
  }

  public required convenience init(from decoder: Decoder) throws {
      self.init()
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let messagesDecode = try container.decodeIfPresent([ChatMessageDetail].self, forKey: .messages) ?? [ChatMessageDetail()]
      messages.append(objectsIn: messagesDecode)
  }
}

class ChatState: Object, ObjectKeyIdentifiable{
    @Persisted var allReady: Bool = false
    @Persisted var orderFix: Bool = false
    @Persisted var orderChecked: Bool = false
    @Persisted var orderDone: Bool = false
}

class UserPrivacy: Object, ObjectKeyIdentifiable{
  @Persisted var id: String?
  @Persisted var emailAddress: String?
  @Persisted var name: String?
  @Persisted var belong: Int?
  @Persisted var belongStr: String?
  @Persisted var provider: String?
  @Persisted var alram: Bool = true
  @Persisted var mainAccount: UserAccount? = nil
  @Persisted var accounts: List<UserAccount>
}

class UserAccount: Object, ObjectKeyIdentifiable{
  @Persisted var bank: String?
  @Persisted var account: String?
  @Persisted var name: String?
}

func adduser(_ result : UserPrivacy) {
  DispatchQueue(label: "background").async {
    autoreleasepool {
      let realm = try! Realm()
      try? realm.write {
          realm.add(result)
      }
    }
  }
}

func logoutuserdelete() {
  DispatchQueue(label: "background").async {
    autoreleasepool {
      let realm = try! Realm()
      try? realm.write {
        realm.deleteAll()
      }
    }
  }
}

class ChatUsersInfo: Object, ObjectKeyIdentifiable, Decodable{
  @Persisted var name: String?
  @Persisted var userId: String?
  @Persisted var isReady: Bool = false
  @Persisted var role: String?
  @Persisted var roomId: String?
}

class requestedUserInfo: Object, ObjectKeyIdentifiable, Decodable{
  @Persisted var name: String?
  @Persisted var userId: String?
}

class ChatMessageDetail: Object, ObjectKeyIdentifiable, Identifiable, Decodable{
  @Persisted(primaryKey: true) var id: String?
  @Persisted var type: String?
  @Persisted var body: ChatMessageDetailBody?
  @Persisted var idx: Int?
  @Persisted var at: String?
//    var ofChat = LinkingObjects(fromType: ChatDB.self, property: "messages")


    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case body = "body"
        case idx = "idx"
        case at = "at"
    }

//    override class func primaryKey() -> String? {
//      return "id"
//    }
//  public required convenience init(from decoder: Decoder) throws {
//      self.init()
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      let bodyDecode = try container.decodeIfPresent([ChatMessageDetailBody].self, forKey: .body) ?? [ChatMessageDetailBody()]
//      body.append(objectsIn: bodyDecode)
//  }
}

class ChatMessageDetailBody: Object, Decodable, ObjectKeyIdentifiable{
    @Persisted var action: String?
    @Persisted var data: ChatMessageDetailBodyData?
    @Persisted var userid: String?
    @Persisted var username: String?
    @Persisted var message: String?
//    var ofDetail = LinkingObjects(fromType: ChatMessageDetail.self, property: "body")

    private enum CodingKeys: String, CodingKey {
        case action = "action"
        case data = "data"
        case userid = "userId"
        case username = "name"
        case message = "message"
    }
}

class ChatMessageDetailBodyData: Object, ObjectKeyIdentifiable, Decodable{
  @Persisted var name: String?
  @Persisted var userId: String?
  @Persisted var requestedUser: requestedUserInfo?
  @Persisted var targetUser: requestedUserInfo?
  @Persisted var voteId: String?
  @Persisted var result: Bool?

  private enum CodingKeys: String, CodingKey {
      case name = "name"
      case userId = "userId"
      case requestedUser = "target"
      case targetUser = "targetUser"
      case voteId = "voteId"
      case result = "result"
  }
}


class BlockedUser: Object, ObjectKeyIdentifiable{
  @Persisted(primaryKey: true) var userId: String
  
}


final class ChatData: ObservableObject, Identifiable{
  @Published var chatlist: [ChatDB]
  @Published var chatlistsortindex: [Int]


  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    
    let config = Realm.Configuration(
    schemaVersion: 11,
    migrationBlock: { migration, oldSchemaVersion in
      print(migration)
      print("new", migration.newSchema)
      print("old", migration.oldSchema)
        // Any migration logic older Realm files may need
    })

    Realm.Configuration.defaultConfiguration = config

    
    let realm = try! Realm()
    chatlist = Array(realm.objects(ChatDB.self).freeze()) // Convert Realm results object to Array
    
    
    var idxs: [Int] = []
    for chatdb in realm.objects(ChatDB.self).sorted(byKeyPath: "sortforat", ascending: false) {
      if Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb) != nil {
        idxs.append(Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb)!)
      }
    }
    chatlistsortindex = idxs
    
    
    activateChannelsToken()
  }

  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(ChatDB.self)
    
    DispatchQueue.main.async {

      self.chatsToken = channels.observe { _ in
        
        
        
        self.chatlist = Array(channels.freeze())

        var idxs: [Int] = []
        for chatdb in channels.sorted(byKeyPath: "sortforat", ascending: false) {
          if Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb) != nil {
            idxs.append(Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb)!)
          }
        }
        self.chatlistsortindex = idxs
      }
    }//dispatch
  }

  deinit {
    chatsToken?.invalidate()
  }
}

func addChatting(_ result : ChatDB) {
//  DispatchQueue(label: "background").async {
//    autoreleasepool {
      let realm = try! Realm()
      try? realm.write {
          realm.add(result)
      }
//    }
//  }
}

func addBlockedUser(_ result : BlockedUser) {
  DispatchQueue(label: "background").async {
    autoreleasepool {
      let realm = try! Realm()
      try? realm.write {
          realm.add(result)
      }
    }
  }
}




final class UserData: ObservableObject{
  @Published var data: UserPrivacy?

  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    let realm = try! Realm()
    if Array(realm.objects(UserPrivacy.self)).isEmpty {
      data = nil
    } else {
      data = Array(realm.objects(UserPrivacy.self))[0] // Convert Realm results
    }
//    data = Array(realm.objects(UserPrivacy.self))[0] // Convert Realm results
    activateChannelsToken()
  }

  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(UserPrivacy.self)
    DispatchQueue.main.async {

      self.chatsToken = channels.observe { _ in
        if channels.isEmpty {
          self.data = nil
        } else {
          self.data = channels[0]
        }
      }
    }//dispatch
  }

  deinit {
    chatsToken?.invalidate()
  }
}


final class Noti: ObservableObject{
  @Published var systemNoti: Bool

  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    let realm = try! Realm()
    var tmpBool = false
    for i in realm.objects(ChatDB.self) {
      if i.messages.filter("type == 'system' AND idx > \(i.confirmation)").filter("body.action == 'order-fixed' OR body.action == 'order-checked' OR body.action == 'order-finished'").count != 0 {
        tmpBool = true
        break
      }
    }
    systemNoti = tmpBool
    
    activateChannelsToken()
  }

  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(ChatDB.self)
    DispatchQueue.main.async {
      self.chatsToken = channels.observe { _ in
        // When there is a change, replace the old channels array with a new one.
        var tmpBool = false
        for i in channels {
          if i.messages.filter("type == 'system' AND idx > \(i.confirmation)").filter("body.action == 'order-fixed' OR body.action == 'order-checked' OR body.action == 'order-finished'").count != 0 {
            tmpBool = true
            break
          }
        }
        self.systemNoti = tmpBool
      }
    }
  }

  deinit {
    chatsToken?.invalidate()
  }
}


final class BlockedUserData: ObservableObject{
  @Published var data: [BlockedUser]

  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    let realm = try! Realm()
    data = Array(realm.objects(BlockedUser.self).freeze())
    activateChannelsToken()
  }

  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(BlockedUser.self)
    DispatchQueue.main.async {

      self.chatsToken = channels.observe { _ in
        self.data = Array(channels.freeze())
      }
    }//dispatch
  }

  deinit {
    chatsToken?.invalidate()
  }
}


extension Results {
  var array: [Element] {
    return self.map { $0 }
  }
}

extension Results {
  var list: List<Element> {
    reduce(.init()) { list, element in
      list.append(element)
      return list
    }
  }
}
