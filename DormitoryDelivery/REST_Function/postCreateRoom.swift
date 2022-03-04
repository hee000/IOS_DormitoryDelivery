//
//  createRoom.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import Foundation
import Alamofire

func postCreateRoom(createRoomData: CreateRoom, section: Int, deliveryPriceAtLeast: Int, navi: ChatNavi){
  print("방만들기 시도")
  guard let createkey = try? createroomdata(shopName: createRoomData.shopName, shopLink: createRoomData.shopLink, category: categoryNameToEng[category[createRoomData.category!]]!, section: section, deliveryPriceAtLeast: deliveryPriceAtLeast).asDictionary() else { return }
  let url = createroomposturl
  let tk = TokenUtils()
  
  AF.request(url, method: .post, parameters: createkey, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader()).responseJSON { (response) in

    print(response)
    switch response.result {
    case .success(let value):
//      print("방 생성 성공")
//      print(value)
//      print("=======")
      if let id = value as? [String: Any] {
        if let idvalue = id["id"] {
          let chatroomopen = ChatDB()
          if let rid = idvalue as? String {
            let userprivacy = realm.objects(UserPrivacy.self).first!
            navi.State = true
            navi.rid = rid
            navi.Active = true
  
            chatroomopen.rid = rid
            chatroomopen.title = createRoomData.shopName
            let userinfo = ChatUsersInfo()
            userinfo.userId = userprivacy.id
            userinfo.name = userprivacy.name
            chatroomopen.superUser = userinfo
            chatroomopen.member.append(userinfo)
            addChatting(chatroomopen)

            createRoomData.rid = rid
            

            print("방만들기끝")
          }
        }
      }

    case .failure(let error):
        print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
    }
  }
}
