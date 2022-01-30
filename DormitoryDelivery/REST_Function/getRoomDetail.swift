//
//  JoinButton.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Alamofire
import SwiftUI


func getRoomDetail(matchid: String, token: String, detaildata: RoomDetailData, detaildata2: RoomDetailData) {
  let url = roomdetail(matchId: matchid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
//    print(response.value)
    
    let result = response.value as! [String: Any]
    do {
        let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        let session = try JSONDecoder().decode(roomdetaildata.self, from: data2)
        detaildata.data = session
      detaildata2.data = session
      }
    catch {
      print(error)
    }
  }
}
