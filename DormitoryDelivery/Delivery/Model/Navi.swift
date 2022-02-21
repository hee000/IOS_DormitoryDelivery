//
//  Navi.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation
import RealmSwift

class ChatNavi: ObservableObject{
  @Published var rid: String?
  @Published var index: Int?
  @Published var Active: Bool
  @Published var State: Bool

  @Published var NaviJoinActive: Bool
  @Published var NaviCreateActive: Bool
  
  private var chatsToken: NotificationToken?

  init() {
    NaviJoinActive = false
    NaviCreateActive = false
    Active = false
    State = false // false = join, true = create
    
    activateChannelsToken()
  }

  func forceActive(){
    let realm = try! Realm()
    let channels = realm.objects(ChatDB.self)
    for (idx, chatdb) in channels.enumerated() {
      if chatdb.rid == self.rid {
        self.index = idx
        self.NaviJoinActive = true
      }
    }
  }
  
  private func activateChannelsToken() {
    let realm = try! Realm()
    let channels = realm.objects(ChatDB.self)
    chatsToken = channels.observe { V in
      if self.Active {
        for (idx, chatdb) in channels.enumerated() {
          if chatdb.rid == self.rid {
            self.index = idx
            if !self.State {
              self.NaviJoinActive = true
            } else {
              self.NaviCreateActive = true
            }
          }
        }
      }
    }
  }

  deinit {
    chatsToken?.invalidate()
  }
}
