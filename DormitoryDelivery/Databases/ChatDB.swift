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



class ChatDB: Object, ObjectKeyIdentifiable, Decodable{

  @objc dynamic var rid: String?
  @objc dynamic var title: String?
  var messages = List<ChatMessageDetail>()


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


class ChatMessageDetail: Object, Decodable,ObjectKeyIdentifiable {
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

class ChatMessageDetailBody: Object, Decodable, ObjectKeyIdentifiable {
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

class ChatMessageDetailBodyData: Object, Decodable, ObjectKeyIdentifiable {
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


final class ChatData: ObservableObject {
  @Published var chatlist: [ChatDB]
  @Published var leaveroomrid: String = ""

  private var chatsToken: NotificationToken?


  // Grab channels from Realm, and then activate a Realm token to listen for changes.
  init() {
    let realm = try! Realm()
    chatlist = Array(realm.objects(ChatDB.self)) // Convert Realm results object to Array
    activateChannelsToken()
  }

  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(ChatDB.self)
    chatsToken = channels.observe { _ in
      // When there is a change, replace the old channels array with a new one.
      self.chatlist = Array(channels)
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
