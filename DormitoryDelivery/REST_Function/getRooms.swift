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
  restApiQueue.async {
    let req = AF.request(urlroomupdate(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    req.responseJSON { response in
      guard let json = response.data else { return }
      guard let restdata = try? JSONDecoder().decode(roomupdate.self, from: json) else { return }
      
//      print(restdata)
      
      let realm = try! Realm()
      try! realm.write {
        if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
          if db.readyAvailable != restdata.isReadyAvailable {
            db.readyAvailable = restdata.isReadyAvailable
          }
          if db.ready != restdata.isReady {
            db.ready = restdata.isReady
          }
  //        db.readyAvailable = restdata.isReadyAvailable
          if restdata.state == 1 {
            db.state?.allReady = true
            db.state?.orderFix = false
            db.state?.orderChecked = false
            db.state?.orderDone = false
            db.state?.orderCancel = false
          } else if restdata.state == 2 {
            db.state?.allReady = false
            db.state?.orderFix = true
            db.state?.orderChecked = false
            db.state?.orderDone = false
            db.state?.orderCancel = false
          } else if restdata.state == 3 {
            db.state?.allReady = false
            db.state?.orderFix = true
            db.state?.orderChecked = true
            db.state?.orderDone = false
            db.state?.orderCancel = false
          } else if restdata.state == 4 {
            db.state?.allReady = false
            db.state?.orderFix = true
            db.state?.orderChecked = true
            db.state?.orderDone = true
            db.state?.orderCancel = false
          } else if restdata.state == 5 {
            db.state?.allReady = false
            db.state?.orderFix = true
            db.state?.orderChecked = true
            db.state?.orderDone = true
            db.state?.orderCancel = true
          } else if restdata.state == 0 {
            db.state?.allReady = false
            db.state?.orderFix = false
            db.state?.orderChecked = false
            db.state?.orderDone = false
            db.state?.orderCancel = false
          }
        } // db
      } // try realm
    }
  }
}

func getParticipantsUpdate(rid: String) {
  restApiQueue.async {
    AF.request(urlparticipants(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
      .responseJSON { response in
        guard let json = response.data else { return }
        guard var participants = try? JSONDecoder().decode(List<ChatUsersInfo>.self, from: json) else { return }
        if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: rid) {
          let realm = try! Realm()
          
          // 방장 나감
          if let superUser = db.superUser {
            var NotIn = true
            for participant in participants {
              if superUser.userId == participant.userId {
                NotIn = false
              }
            }
            if NotIn {
              try! realm.write {
                db.superUser = nil
              }
            }
          }
          
          try! realm.write {
            db.member = participants
          }
          
        }
      }
  }
}

func getRooms(uid: String) {
  restApiQueue.async {
    print("채팅목록1")
    let url = urlrooms(uid: uid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
    req.responseJSON { response in

//      print(response, "채팅목록2")
      do {
        switch response.result {
        case .success(let value):
          if response.response?.statusCode == 200 {
            let result = value as! [Any]
            let message = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let json = try JSONDecoder().decode([rooms].self, from: message)

            let realm = try! Realm()
            

            for room in json {
              if let db = realm.object(ofType: ChatDB.self, forPrimaryKey: room.id) {
  //              print(db)
                AF.request(urlparticipants(rid: room.id), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
                  .responseJSON { response2 in
//                    print(response2, "채팅목록3")
                    guard let participants = try? JSONDecoder().decode(List<ChatUsersInfo>.self, from: response2.data!) else { return }

                    
                    try! realm.write {
                      db.readyAvailable = room.isReadyAvailable

                      db.member = participants

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
//                    print(response2, "채팅목록4")
                    guard let participants = try? JSONDecoder().decode(List<ChatUsersInfo>.self, from: response2.data!) else { return }
                    print("채팅목록 5")
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
                    
                    newroom.member = participants
                    
                    for participant in participants {
                      if participant.userId == room.purchaserId {
                        newroom.superUser = participant
                      }
                    }
                    
                    print("채팅목록 추가 ")
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
}



func getparticipants(rid: String, token: String) {
  let url = urlparticipants(rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    
//    print(response)
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
