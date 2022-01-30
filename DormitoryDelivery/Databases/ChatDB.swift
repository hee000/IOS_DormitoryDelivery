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

class ChatDB: Object, ObjectKeyIdentifiable, Decodable{
  @objc dynamic var id = UUID().uuidString
  @objc dynamic var rid: String?
  @objc dynamic var superUser: ChatUsersInfo?
  @objc dynamic var state: ChatState? = ChatState()
  @objc dynamic var title: String?
  var member = List<ChatUsersInfo>()
  var menu = List<String>()
  @objc dynamic var ready: Bool = false
  var messages = List<ChatMessageDetail>()
  @objc dynamic var index: Int = 0
  @objc dynamic var confirmation: Int = 0
  @objc dynamic var sortforat: Int = 0

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
    @objc dynamic var allReady: Bool = false
    @objc dynamic var orderFix: Bool = false
    @objc dynamic var orderChecked: Bool = false
    @objc dynamic var orderDone: Bool = false
}

class UserPrivacy: Object, ObjectKeyIdentifiable{
  @objc dynamic var _id: String?
  @objc dynamic var name: String?
  @objc dynamic var belong: String?
  @objc dynamic var account: String?
  @objc dynamic var alram: Bool = false
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
      let result = realm.objects(UserPrivacy.self)
      try? realm.write {
          realm.delete(result)
      }
    }
  }
}

class ChatUsersInfo: Object, ObjectKeyIdentifiable{
    @objc dynamic var name: String?
    @objc dynamic var userId: String?
}

class ChatMessageDetail: Object, Decodable,ObjectKeyIdentifiable{
    @objc dynamic var id: String?
    @objc dynamic var type: String?
    @objc dynamic var body: ChatMessageDetailBody?
    @objc dynamic var idx: String?
    @objc dynamic var at: String?
  

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case body = "body"
        case idx = "idx"
        case at = "at"
    }

//    override class func primaryKey() -> String? {
//      return "idx"
//    }

//  public required convenience init(from decoder: Decoder) throws {
//      self.init()
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      let bodyDecode = try container.decodeIfPresent([ChatMessageDetailBody].self, forKey: .body) ?? [ChatMessageDetailBody()]
//      body.append(objectsIn: bodyDecode)
//  }
}

class ChatMessageDetailBody: Object, Decodable, ObjectKeyIdentifiable{
    @objc dynamic var action: String?
    @objc dynamic var data: ChatMessageDetailBodyData?
    @objc dynamic var userid: String?
    @objc dynamic var username: String?
    @objc dynamic var message: String?

    private enum CodingKeys: String, CodingKey {
        case action = "action"
        case data = "data"
        case userid = "userId"
        case username = "name"
        case message = "message"
    }
}

class ChatMessageDetailBodyData: Object, Decodable, ObjectKeyIdentifiable{
  @objc dynamic var name: String?
  @objc dynamic var userId: String?
  @objc dynamic var TEST: String?
  @objc dynamic var TEST2: String?
  @objc dynamic var TEST3: String?

  private enum CodingKeys: String, CodingKey {
      case name = "name"
      case userId = "userId"
      case TEST = "TEST"
      case TEST2 = "TEST2"
      case TEST3 = "TEST3"
  }
}


final class ChatData: ObservableObject{
  @Published var chatlist: [ChatDB]
  @Published var chatlistsortindex: [Int]

  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    let realm = try! Realm()
    chatlist = Array(realm.objects(ChatDB.self)) // Convert Realm results object to Array
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
    chatsToken = channels.observe { _ in
      // When there is a change, replace the old channels array with a new one.
      
      self.chatlist = Array(channels)
//      print(channels.sorted(byKeyPath: "sortforat"))
//      self.chatlist = Array(channels.sorted(byKeyPath: "sortforat", ascending: false))
//      print(channels.sorted(byKeyPath: "sortforat", ascending: false).first)
      var idxs: [Int] = []
      for chatdb in channels.sorted(byKeyPath: "sortforat", ascending: false) {
        if Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb) != nil {
          idxs.append(Array(realm.objects(ChatDB.self)).firstIndex(of: chatdb)!)
        }
      }
      self.chatlistsortindex = idxs
    }
  }

  deinit {
    chatsToken?.invalidate()
  }
}

func addChatting(_ result : ChatDB) {
  DispatchQueue(label: "background").async {
    autoreleasepool {
      let realm = try! Realm()
      try? realm.write {
          realm.add(result)
      }
    }
  }
}
