//
//  getRoomLeave.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/23.
//

import Foundation
import Alamofire
import RealmSwift

func getRoomLeave(rid: String, token: String, model: ChatModel) {
//  let url = urlroomleave(rid: rid)
//  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
//  req.response { response in
//    do {
//      if response.response?.statusCode == 200 {
//        model.leave.toggle()
////        let realm = try! Realm()
////        try! realm.write({
////          realm.delete(roomidtodbconnect(rid: rid)!)
////        })
//      }
//    } catch {
//      print(error)
//    }
//  }
}

//func getRoomLeave(rid: String, token: String) {
//  let url = urlroomleave(rid: rid)
//  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
//  req.response { response in
//    do {
//      if response.response?.statusCode == 200 {
//        let realm = try! Realm()
//        try! realm.write({
//          realm.delete(roomidtodbconnect(rid: rid)!)
//        })
//      }
//    } catch {
//      print(error)
//    }
//  }
//}
