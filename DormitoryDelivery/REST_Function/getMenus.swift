//
//  getMenus.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire

func getMenuListIndividual(uid: String, rid: String, model: Order) {
  let url = urladdmenu(uid: uid, rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    guard let menulist = try? JSONDecoder().decode([restOnlyOrderData].self, from: response.data!) else { return }
    
    if menulist.count == 0 {
      let nonemenue = orderdata(id: UUID().uuidString, name: "", quantity: 1, description: "세부 정보를 입력해주세요.", price: "")
      model.data.append(nonemenue)
      model.forcompare = model.data
    } else {
      var menus: [orderdata] = []
      for menu in menulist {
        model.isMenu.append(menu.id)
        menus.append(orderdata(id: menu.id, name: menu.name, quantity: menu.quantity, description: menu.description, price: String(menu.price)))
      }
//      model.data.append(contentsOf: menulist)
      model.data = menus
      model.forcompare = model.data
    }
  }
}

//func getMenus(uid: String, rid: String, mid: ChatDB, token: String, model: Order) {
//  
//  let dispatchGroup = DispatchGroup()
//  let queue = DispatchQueue(label: "queue")
//  var items: [orderdata] = []
//  
//  let semaphore = DispatchSemaphore(value: 1)
//
//  for menu in mid.menu {
//    queue.sync {
//      dispatchGroup.enter()
//      semaphore.wait()
//      let url = urlmenus(uid: uid, rid: rid, mid: menu)
//      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
//
//      req.responseJSON(queue: .global()) { response in
//        do {
//          let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
//          var session = try JSONDecoder().decode(orderdata.self, from: data2)
//          items.append(session)
//          }
//        catch {
//          print(error)
//        }
//        semaphore.signal()
//        dispatchGroup.leave()
//      }
//    }
//  }
//
//  
//  dispatchGroup.notify(queue: queue) {
//    DispatchQueue.main.async {
//      model.data.append(contentsOf: items)
//      model.forcompare.append(contentsOf: items)
//    }
//  }
//
//  
//  
//}
