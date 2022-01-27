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
    
    let result = response.value as! [Any]
//    print(response.value)
    
    
    do {
        let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
      let session = try JSONDecoder().decode([orderlistdata].self, from: data2)
//        detaildata.data = session
//      print(session)
        model.data = session
        if model.data != nil{
          if let idx = model.data!.firstIndex{$0.user.userId == UserDefaults.standard.string(forKey: "MyID")!} {
            model.data!.move(fromOffsets: IndexSet(integer: idx), toOffset: 0)
          }
        }
//      print(session)
      }
    catch {
      print(error)
    }
  }
}


struct orderlistdata: Codable {
  var user: userdata;
  var menus: Array<orderlistmenudata>;
}

struct userdata: Codable {
  var userId: String;
  var name: String;
}
struct orderlistmenudata: Codable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int;
}

class OrderList: ObservableObject {
  @Published var data: [orderlistdata]? = nil
}
