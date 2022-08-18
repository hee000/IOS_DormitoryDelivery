//
//  RoomJoin.swift.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire
import RealmSwift

func getRoomJoin(matchid: String, title: String, rid: String, detaildata: RoomDetailData, navi: ChatNavi) {
  restApiQueue.async {
    let tk = TokenUtils()
    let url = roomjoin(matchId: matchid)
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())
    req.responseJSON { response in
      appVaildCheck(res: response)
      
      guard let statusCode = response.response?.statusCode else { return }
      
      if statusCode == 200 {
        AF.request(urlparticipants(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader()).responseJSON { result in
          appVaildCheck(res: result)
          
          guard let result2 = result.value as? [Any],
                let data2 = try? JSONSerialization.data(withJSONObject: result2, options: .prettyPrinted),
                let session = try? JSONDecoder().decode(List<ChatUsersInfo>.self, from: data2)
          else { return }

          print("asdasdasd")
          navi.State = false
          navi.rid = rid
          navi.Active = true
          
          let chatroomopen = ChatDB()
          let superUser = ChatUsersInfo()
          
          superUser.userId = detaildata.data?.purchaser.userId
          superUser.name = detaildata.data?.purchaser.name
          
          chatroomopen.rid = rid
          chatroomopen.superUser = superUser
          chatroomopen.title = title
          
//          for i in session.indices {
//            let userinfo = ChatUsersInfo()
//            userinfo.userId = session[i].userId
//            userinfo.name = session[i].name
//            userinfo.isReady = session[i].isReady
//            
//            chatroomopen.member.append(userinfo)
//          }
          chatroomopen.member = session
          
          addChatting(chatroomopen)

          detaildata.isActive.toggle()
        
        }//참가자 확인 끝
      }
    }
  }
}


struct participantsinfo: Codable, Equatable {
  var id: String;
  var name: String;
}


struct participantsinfo2: Codable, Equatable {
  var name: String;
  var isReady: Bool;
  var role: String;
  var roomId: String;
  var userId: String;
}
