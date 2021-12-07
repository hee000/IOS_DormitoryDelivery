////
////  realmbackup.swift.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/12/07.
////
//
//import Foundation
//import RealmSwift
//{
//    "string_data": "18C",
//
//    "array_data1": [
//        {
//            "language_code": "en",
//            "name": "English"
//        },
//        {
//            "language_code": "ja",
//            "name": "Japanese"
//        }
//    ],
//
//    "array_in_object": {
//        "array_data2" : [
//        {
//            "title": "test1",
//            "name": "test1 입니다."
//        },
//        {
//            "title": "test2",
//            "name": "test2 입니다."
//        }
//    ]
//    }
//
//}
//
// 
//
//이제 모델들을 정의 해보겠습니다.
//
// 
//
//import Foundation
//
//import RealmSwift
//
// 
//
//class ExampleModel: Object, Decodable {
//
//    
//
//    @objc dynamic var stringData: String?
//
//    var arrayData1 = List<ArrayData1Content>()   //List 구조는 @objc dynamic 를 생략한다.
//
//    @objc dynamic var arrayInObject : ArrayInObjectModel?
//
// 
//
//    private enum CodingKeys: String, CodingKey {
//
//        case stringData = "string_data"
//
//        case arrayData1 = "array_data1"
//
//        case arrayInObject = "array_in_object"
//
//    }
//
//// CodingKeys 부분을 보면
//
//case stringData = "string_data" 에서
//
//"string_data" 이부분은 실제 Json data의 key 값이고
//
// stringData 은 key 값을 대신해서 쓸 값입니다.
//
//= "string_data" 를 사용하지 않으면 case stringData 의 값을 key 값으로
//
//매핑 하니 유의 하시기 바랍니다.
//
//    
//
//    public required convenience init(from decoder: Decoder) throws {
//
//        self.init()
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let arrayData1Decode =
//
//try container.decodeIfPresent([ArrayData1Content].self, forKey: .arrayData1) ??[ArrayData1Content()]
//
// arrayData1.append(objectsIn: arrayData1Decode)
//
////중요한 부분 입니다. Json data 에 List 형태의 데이터가 있을 경우 위와 같이 Decode 를 해주어야 합니다.
//
// 
//
//        let arrayInObjectDecode = try container.decodeIfPresent(ArrayInObjectModel.self, forKey: .arrayInObject)
//
//        arrayInObject = arrayInObjectDecode
//
//       ///해당 부분은 List Data 가 안에 포함이 되어있지만 Object 이므로 위와 같이 Decode를 합니다.
//
//      /// @objc dynamic var arrayInObject : ArrayInObjectModel?   <<<< 선언부를 유심히 보면 List 가 아니므로
//
//
// 
//     /// @objc dynamic 을 붙여준걸 알수 있습니다. 이렇게 붙여야 다음 모델에서 해당 데이터를 사용해 매핑이 가능합니다.
//
//    }
//
//}
//
// 
//
//class ArrayData1Content: Object, Decodable {
//
// 
//
//    @objc dynamic var languageCode: String?
//
//    @objc dynamic var name: String?
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
// 
//
//class ArrayInObjectModel: Object, Decodable {
//
// 
//
//    var arrayData2 = List<ArrayData2Content>()
//
//    
//
//    private enum CodingKeys: String, CodingKey {
//
//        case arrayData2 = "array_data2"
//
//    }
//
//    
//
//    public required convenience init(from decoder: Decoder) throws {
//
//        self.init()
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let arrayData2Decode = try container.decodeIfPresent([ArrayData2Content].self, forKey: .arrayData2) ?? [ArrayData2Content()]
//
//        arrayData2.append(objectsIn: arrayData2Decode)
//
//    }
//
//}
//
// 
//
//class ArrayData2Content : Object, Decodable {
//
//    @objc dynamic var title: String?
//
//    @objc dynamic var name: String?
//
//    
//
//    private enum CodingKeys: String, CodingKey {
//
//        case title = "title"
//
//        case name = "name"
//
//    }
