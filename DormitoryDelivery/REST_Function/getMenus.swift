//
//  getMenus.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import Foundation
import Alamofire

func getMenus(uid: String, rid: String, mid: ChatDB, token: String, model: Order) {
  
  let dispatchGroup = DispatchGroup()
  let queue = DispatchQueue(label: "queue")
  var items: [orderdata] = []
  
  let semaphore = DispatchSemaphore(value: 1)

  for menu in mid.menu {
    queue.sync {
      dispatchGroup.enter()
      semaphore.wait()
      let url = urlmenus(uid: uid, rid: rid, mid: menu)
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])

      req.responseJSON(queue: .global()) { response in
        do {
          let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
          var session = try JSONDecoder().decode(orderdata.self, from: data2)
          items.append(session)
          }
        catch {
          print(error)
        }
        semaphore.signal()
        dispatchGroup.leave()
      }
    }
  }

  
  dispatchGroup.notify(queue: queue) {
    DispatchQueue.main.async {
      model.data.append(contentsOf: items)
      model.forcompare.append(contentsOf: items)
    }
  }

  
  
}
