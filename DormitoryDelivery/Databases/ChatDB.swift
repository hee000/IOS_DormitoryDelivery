//
//  ChatDB.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/07.
//

import Foundation
import RealmSwift
import Combine



class ChatDB: Object {
    @objc dynamic var rid: String?
    var message = List<ChatMessageDetail>()
  
    override class func primaryKey() -> String? {
      return "rid"
    }
  
  convenience init(rid: String) {
    self.init()
    self.rid = rid
  }

}


class ChatMessageDetail: Object {
    @objc dynamic var id: UUID?
    @objc dynamic var type: String?
    @objc dynamic var body: Data?
    @objc dynamic var at: String?
    let ofChatDB = LinkingObjects(fromType: ChatDB.self, property: "message")
  
  override class func primaryKey() -> String? {
    return "id"
  }
}

final class ChatData: ObservableObject {
  @Published var chatlist: [ChatDB]
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
