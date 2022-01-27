//
//  getMenuList.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import Foundation
import Alamofire

func getMenuList(rid: String, token: String, model: tete2) {
  let url = urlmenulist(rid: rid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
  req.responseJSON { response in
    
    let result = response.value as! [Any]
//    print(response.value)
    
    
    do {
        let data2 = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
      let session = try JSONDecoder().decode([tetet2].self, from: data2)
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


struct tetet2: Codable {
  var user: teteuser;
  var menus: Array<tetemenus>;
}

struct teteuser: Codable {
  var userId: String;
  var name: String;
}
struct tetemenus: Codable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int;
}

class tete2: ObservableObject {
  @Published var data: [tetet2]? = nil
  @Published var isActive = false
}
