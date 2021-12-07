//
//  ChatData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine
import Alamofire
import RealmSwift

class model: ObservableObject {
  @Published var messages: [modelm] {
    didSet {
//        UserDefaults.standard.set(sessionId, forKey: "sessionId")
    }
}

  init() {
    self.messages = []
  }
}

struct modelm: Decodable, Identifiable {
  let id: UUID
  let message: String
  let user: String
  let userID: Bool
}



struct ChatRoom: Codable, Identifiable {
  let id: UUID      // vid를 의미
  let message: String //
  let user: String
  let userID: Bool
}

class ChatRoomtop: Object {
  // 2
  @objc dynamic var id = 0    //
  let messages = List<messages>()

  // 3
  convenience init(id: Int) {
    self.init()
    self.id = id
    
  }
    
  override static func primaryKey() -> String? {
    "id"
  }
}

class messages: Object {
  // 2
  @objc dynamic var id = 0    //
  @objc dynamic var messages = ""

  // 3
  override static func primaryKey() -> String? {
    "id"
  }
}

//class ChatRoomtop: Object {
//
//  var messages: [ChatRoom] = ""
//
//
//}

//class Phonebook: Object {
////    @Persisted(PrimaryKey: true) var number: String? // primary key로 지정
//    @Persisted var name: String = ""
//    @Persisted var status: String = ""
//
//    convenience init(number: String) {
//        self.init()
////        self.number = number
//    }
//}


// 1
class IngredientDB: Object {
  // 2
  @objc dynamic var id = 0
  @objc dynamic var title = ""
  @objc dynamic var notes = ""
  @objc dynamic var quantity = 1
  @objc dynamic var bought = false

  // 3
  override static func primaryKey() -> String? {
    "id"
  }
}

//
//
//{
//    "rid": "21",
//
//    "messages": [
//        {
//            "idx"   :   "2",
//            "type"  :   "system",
//            "body"  :   { "action" : "users-new",
//                          "data"  :   {"userid"   : "3",
//                                       "username" : "조창희"}
//                        },
//            "at": "123123365"
//        },
//        {
//            "idx"   :   "3",
//            "type"  :   "chatting",
//            "body"  :   { "user"      : {"userid"   : "4",
//                                         "username" : "변우섭"},
//                          "message"  :  "String"}
//                        },
//            "at": "1231345345"
//        }
//    ]
//
//}

import Foundation

import RealmSwift

 

class ExampleModel: Object, Decodable {

    

    @objc dynamic var rid: String?

//    var arrayData1 = List<ArrayData1Content>()   //List 구조는 @objc dynamic 를 생략한다.

 

    private enum CodingKeys: String, CodingKey {

        case rid = "string_data"

        case arrayData1 = "array_data1"

    }


    override static func primaryKey() -> String? {
      return "rid"
    }
    

    public required convenience init(from decoder: Decoder) throws {

        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)

//        let arrayData1Decode = try container.decodeIfPresent([ArrayData1Content].self, forKey: .arrayData1) ?? [ArrayData1Content()]
//
//        arrayData1.append(objectsIn: arrayData1Decode)


    }

}

 

//class ArrayData1Content: Object, Decodable {
//
//
//
//    @objc dynamic var idx: String?
//
//    @objc dynamic var type: String?
//
//   var body: List<awdasdasd>()
//
//  @objc dynamic var at: Int?
//
//
//
//    private enum CodingKeys: String, CodingKey {
//
//        case languageCode = "language_code"
//
//        case name = "name"
//
//    }
//
//}

//
//class awdasdasd: Object, Decodable {
//
//
//
//    @objc dynamic var idx: String?
//
//    @objc dynamic var type: String?
//
//  @objc dynamic var body: String?
//
//  @objc dynamic var at: Int?
//
//
//
//    private enum CodingKeys: String, CodingKey {
//
//        case languageCode = "language_code"
//
//        case name = "name"
//
//    }
//
//}
