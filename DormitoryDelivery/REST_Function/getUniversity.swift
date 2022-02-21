
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


func getUniversityDormitory() {
  let url = urluniversitydormitory(id: "0")
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
  req.responseJSON { response in
    guard let restdata = try? JSONDecoder().decode([dormitorys].self, from: response.data!) else { return }
    
    print(restdata)
  }
}

struct dormitorys: Codable {
  var id: Int
  var name: String
}

class domis: ObservableObject {
  @Published var data: [dormitorys] = []
}
