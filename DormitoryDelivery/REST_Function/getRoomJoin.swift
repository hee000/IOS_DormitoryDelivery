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
        
        AF.request(urlparticipants(rid: rid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token]).responseJSON { result in
          
          let result2 = result.value as! [Any]
          do {
              let data2 = try JSONSerialization.data(withJSONObject: result2, options: .prettyPrinted)
            let session = try JSONDecoder().decode([participantsinfo].self, from: data2)

            let chatroomopen = ChatDB()
            chatroomopen.rid = rid
            chatroomopen.superid = detaildata.data?.shopLink
            chatroomopen.title = title
            for i in session.indices {
              let userinfo = ChatUsersInfo()
              userinfo.id = session[i].id
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


struct participantsinfo: Codable {
  var id: String;
  var name: String;
}
