//
//  RoomJoin.swift.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func getRoomJoin(matchid: String, title: String, rid: String, detaildata: RoomDetailData, navi: ChatNavi) {
  let tk = TokenUtils()
  let url = roomjoin(matchId: matchid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())
  req.response { response in
    do {
      if response.response?.statusCode == 200 {
        
        AF.request(urlparticipants(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader()).responseJSON { result in
          let result2 = result.value as! [Any]
          do {
              let data2 = try JSONSerialization.data(withJSONObject: result2, options: .prettyPrinted)
            let session = try JSONDecoder().decode([participantsinfo].self, from: data2)

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
            
            for i in session.indices {
              let userinfo = ChatUsersInfo()
              userinfo.userId = session[i].id
              userinfo.name = session[i].name
              chatroomopen.member.append(userinfo)
            }
            
            addChatting(chatroomopen)

            detaildata.isActive.toggle()
            }
          catch {
            print(error)
          }
          
        }//참가자 확인 끝
        
      }
    } catch {
      print(error)
    }
  }
}


struct participantsinfo: Codable, Equatable {
  var id: String;
  var name: String;
}
