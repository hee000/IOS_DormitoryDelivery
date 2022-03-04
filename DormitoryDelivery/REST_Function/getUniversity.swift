
import Foundation
import Alamofire
//import RealmSwift

func getUniversity(token: String) {
  let url = urluniversity()
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
  req.responseJSON { response in
    
    print(response)
  }
}


func getUniversityDormitory(dormitoryId: String, model: dormitoryData) {
  print("d")
  let url = urluniversitydormitory(id: dormitoryId)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)

  req.responseJSON(queue: .global()) { response in
    guard let json = response.data else { return }
    guard let restdata = try? JSONDecoder().decode([dormitory].self, from: json)
    else {
      getUniversityDormitory(dormitoryId: dormitoryId, model: model)
      return
    }
    model.data = restdata
  }
}

struct dormitory: Codable, Identifiable {
  var id: Int
  var name: String
}

class dormitoryData: ObservableObject {
  @Published var data: [dormitory] = []
}

struct jwtdata: Codable {
  var id: String
  var iat: Int
  var univId: Int
  var exp: Int
  var name: String
}
