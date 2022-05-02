//
//  getRooms.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/03.
//

import Foundation
import Alamofire
import RealmSwift

func getRoomUpdate(rid: String) {
  let req = AF.request(urlroomupdate(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    guard let json = response.data else { return }
    guard let restdata = try? JSONDecoder().decode(roomupdate.self, from: json) else { return }
    
    print(restdata)
    
    
    if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
      let realm = try! Realm()
      try! realm.write {
        db.readyAvailable = restdata.isReadyAvailable
        if restdata.state == 1 {
          db.state?.allReady = true
          db.state?.orderFix = false
          db.state?.orderChecked = false
          db.state?.orderDone = false
        } else if restdata.state == 2 {
          db.state?.allReady = false
          db.state?.orderFix = true
          db.state?.orderChecked = false
          db.state?.orderDone = false
        } else if restdata.state == 3 {
          db.state?.allReady = false
          db.state?.orderFix = true
          db.state?.orderChecked = true
          db.state?.orderDone = false
        } else if restdata.state == 4 {
          db.state?.allReady = false
          db.state?.orderFix = true
          db.state?.orderChecked = true
          db.state?.orderDone = true
        } else if restdata.state == 0 {
          db.state?.allReady = false
          db.state?.orderFix = false
          db.state?.orderChecked = false
          db.state?.orderDone = false
        }
      }
    }
  }
}

func getParticipantsUpdate(rid: String) {
  AF.request(urlparticipants(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    .responseJSON { response in
      guard let json = response.data else { return }
      guard var participants = try? JSONDecoder().decode([participantsinfo].self, from: json) else { return }
      if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
        let realm = try! Realm()
        
        if let superUser = db.superUser {
          if participants.firstIndex(of: participantsinfo(id: superUser.userId!, name: superUser.name!)) == nil {
            try! realm.write {
              db.superUser = nil
            }
          }
        }
        
        for member in db.member {
          if let idx = participants.firstIndex(of: participantsinfo(id: member.userId!, name: member.name!)) {
            participants.remove(at: idx)
          } else {
            try! realm.write {
//              if let superUser = db.superUser {
//                if member.userId == superUser.userId {
//                  print("방장 나갔어")
//                  db.superUser = nil
//                }
//              }
              db.member.remove(at: db.member.index(of: member)!)
            }
          }
        }
        

        
        try! realm.write {
          for participant in participants {
            let userinfo = ChatUsersInfo()
            userinfo.userId = participant.id
            userinfo.name = participant.name
            db.member.append(userinfo)
          }
        }
      }
    }
}

func getRooms(uid: String) {
  let url = urlrooms(uid: uid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in

    do {
      switch response.result {
      case .success(let value):
        if response.response?.statusCode == 200 {
          let result = value as! [Any]
          let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
          let json = try JSONDecoder().decode([rooms].self, from: message)
//          print(json)
          let realm = try! Realm()
          
//          let db = realm.objects(ChatDB.self)
          for room in json {
            if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: room.id) {
//              print(db)
              AF.request(urlparticipants(rid: room.id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
                .responseJSON { response2 in
                  guard var participants = try? JSONDecoder().decode([participantsinfo].self, from: response2.data!) else { return }
                  for member in db.member {
                    if let idx = participants.firstIndex(of: participantsinfo(id: member.userId!, name: member.name!)) {
                      participants.remove(at: idx)
                    } else {
                      try! realm.write {
                        db.member.remove(at: db.member.index(of: member)!)
                      }
                    }
                  }
                  
                  try! realm.write {
                    db.readyAvailable = room.isReadyAvailable
                    for participant in participants {
                      let userinfo = ChatUsersInfo()
                      userinfo.userId = participant.id
                      userinfo.name = participant.name
                      db.member.append(userinfo)
                    }

                    if room.state == 1 {
                      db.state?.allReady = true
                      db.state?.orderFix = false
                      db.state?.orderChecked = false
                      db.state?.orderDone = false
                    } else if room.state == 2 {
                      db.state?.allReady = false
                      db.state?.orderFix = true
                      db.state?.orderChecked = false
                      db.state?.orderDone = false
                    } else if room.state == 3 {
                      db.state?.allReady = false
                      db.state?.orderFix = true
                      db.state?.orderChecked = true
                      db.state?.orderDone = false
                    } else if room.state == 4 {
                      db.state?.allReady = false
                      db.state?.orderFix = true
                      db.state?.orderChecked = true
                      db.state?.orderDone = true
                    } else if room.state == 0 {
                      db.state?.allReady = false
                      db.state?.orderFix = false
                      db.state?.orderChecked = false
                      db.state?.orderDone = false
                    }
                  }
                }
            } else {
              AF.request(urlparticipants(rid: room.id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
                .responseJSON { response2 in
                  guard let participants = try? JSONDecoder().decode([participantsinfo].self, from: response2.data!) else { return }
                  
                  let newroom = ChatDB()
                  newroom.rid = room.id
                  newroom.title = room.shopName
                  newroom.ready = room.isReady
                  newroom.readyAvailable = room.isReadyAvailable
                  
                  if room.state == 1 {
                    newroom.state?.allReady = true
                    newroom.state?.orderFix = false
                    newroom.state?.orderChecked = false
                    newroom.state?.orderDone = false
                  } else if room.state == 2 {
                    newroom.state?.allReady = false
                    newroom.state?.orderFix = true
                    newroom.state?.orderChecked = false
                    newroom.state?.orderDone = false
                  } else if room.state == 3 {
                    newroom.state?.allReady = false
                    newroom.state?.orderFix = true
                    newroom.state?.orderChecked = true
                    newroom.state?.orderDone = false
                  } else if room.state == 4 {
                    newroom.state?.allReady = false
                    newroom.state?.orderFix = true
                    newroom.state?.orderChecked = true
                    newroom.state?.orderDone = true
                  } else if room.state == 0 {
                    newroom.state?.allReady = false
                    newroom.state?.orderFix = false
                    newroom.state?.orderChecked = false
                    newroom.state?.orderDone = false
                  }
                  
                  for participant in participants {
                    let userinfo = ChatUsersInfo()
                    userinfo.userId = participant.id
                    userinfo.name = participant.name
                    if participant.id == room.purchaserId {
                      newroom.superUser = userinfo
                    }
                    newroom.member.append(userinfo)
                  }
                  
                  addChatting(newroom)
              }
              print("디비없음")
            }
          }
          
//              print(json)
        }
      case .failure(let error):
        print(error)
      }
    } catch {
      print(error)
    }

  }
}



func getparticipants(rid: String, token: String) {
  let url = urlparticipants(rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    
    print(response)
  }
}


struct rooms: Codable{
  var id: String;
  var purchaserId: String
  var shopName: String;
  var state: Int;
  var role: String;
  var isReady: Bool;
  var isReadyAvailable: Bool;
}


struct roomupdate: Codable{
  var state: Int;
  var role: String;
  var isReady: Bool;
  var isReadyAvailable: Bool;
}
