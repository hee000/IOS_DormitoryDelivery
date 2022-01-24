//
//  RoomJoin.swift.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func getRoomJoin(matchid: String, token: String, title: String, rid: String, detaildata: RoomDetailData) {
  let url = roomjoin(matchId: matchid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.response { response in
    do {
      if response.response?.statusCode == 200 {
          let chatroomopen = ChatDB()
          chatroomopen.rid = rid
        chatroomopen.superid = detaildata.data?.shopLink
        chatroomopen.title = title
//          let realm = try! Realm()
//          try! realm.write({
//            realm.add(chatroomopen)
//          })
          addChatting(chatroomopen)
        detaildata.isActive.toggle()
      }
    } catch {
      print(error)
    }
  }
}
