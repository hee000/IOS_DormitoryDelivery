//
//  CombineTest.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/06.
//

import SwiftUI
import Foundation
import Alamofire
import Combine
import SwiftUI

struct CombineTest: View {
  @StateObject var viewModel = ViewModel()
    var body: some View {
//      Text(viewModel.chats!.shopName )
      Button("TEST"){
        viewModel.getChatList()
      }
//      Text(viewModel.chats!.shopName )
    }
}

struct CombineTest_Previews: PreviewProvider {
    static var previews: some View {
        CombineTest()
    }
}


let token = "AAAAN4Gve3s93W8UWKbXe8LZij5EJhivzDRn13U9fmncJcLiGWktdJJB-xNlSzBqEWCyTD8-f2cLMvkbTAHFcpQhH6o"
let matchid = "3f41f07e-b7dc-4023-8968-dfeea5419f67"

func roomdetail2(matchId: String) -> URL {
  let url = URL(string: "http://localhost:3000/match/" + matchId + "/info")!
  return url
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
        let url = roomdetail2(matchId: "3f41f07e-b7dc-4023-8968-dfeea5419f67")

        return AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": token])
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
//            .sink { (dataResponse) in
//              self.chats = dataResponse.value!
////                if dataResponse.error != nil {
////                    self.createAlert(with: dataResponse.error!)
////                } else {
////                    self.chats = dataResponse.value!
////                }
        .sink(
            receiveCompletion: { completion in
              print(completion)
            },
            receiveValue: { s in
                print("\(s) 최고 !!!")
            }
        ).store(in: &cancellableSet)
    }

    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}

