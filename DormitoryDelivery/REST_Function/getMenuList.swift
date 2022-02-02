//
//  getMenuList.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire

func getMenuList(rid: String, token: String, model: OrderList) {
  let url = urlmenulist(rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
    

    switch response.result {
    case .success(let value):
      do {
        let result = response.value as! [Any]
        let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
        let session = try JSONDecoder().decode([orderlistdata].self, from: data2)
        model.data = session
        if model.data != nil{
          if let idx = model.data!.firstIndex{$0.user.userId == UserDefaults.standard.string(forKey: "MyID")!} {
            model.data!.move(fromOffsets: IndexSet(integer: idx), toOffset: 0)
          }
        }
      }
      catch {
        print(error)
      }
    case .failure(let error):
      print(error)
    }
  }
}

