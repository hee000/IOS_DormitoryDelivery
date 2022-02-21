import Foundation
import Alamofire
import Combine
import SwiftUI

let token = "AAAANx4Iyrlqjp-pgRjfoa4rp-tr1Ic_pgynqfvDmd3-TG9RE3n4Gto-u1T8VGFS9lf5bkgvm5v81TV5Fg0UYuTbJ2s"
let matchid = "3f41f07e-b7dc-4023-8968-dfeea5419f67"

func roomdetail(matchId: String) -> URL {
  let url = URL(string: "http://localhost:3000/match/" + matchId + "/info")!
  return url
}

struct userdata: Codable, Hashable{
  var userId: String;
  var name: String;
}

struct roomdetaildata: Codable, Identifiable {
  let id: String;  // 룸 아이디
  var shopName: String
  var category: String;
  var section: String;
  var shopLink: String;
  var atLeast: Int;
  var participants: Int;
  var purchaser: userdata;
}

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}


protocol ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<roomdetaildata, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<roomdetaildata, NetworkError>, Never> {
        let url = roomdetail(matchId: matchid)
        
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: roomdetaildata.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


class ViewModel: ObservableObject {
    
    @Published var chats: roomdetaildata?
    @Published var chatListLoadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getChatList()
    }
    
    func getChatList() {
        dataManager.fetchChats()
            .sink { (dataResponse) in
              print(dataResponse)
//                if dataResponse.error != nil {
//                    self.createAlert(with: dataResponse.error!)
//                } else {
//                    self.chats = dataResponse.value!
//                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}

var aa = ViewModel
