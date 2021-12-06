////
////  TEST.swift
////  DormitoryDelivery
////
////  Created by cch on 2021/11/18.
////
//
//import SwiftUI
//import SocketIO
//import Alamofire
//import Combine
//
//
//struct TEST: View {
//  @ObservedObject var uersd: _UserSession = _UserSession()
//  
//  func postTest() {
//          let url = "http://172.30.1.58:3010/auth/login"
//          var request = URLRequest(url: URL(string: url)!)
//          request.httpMethod = "POST"
//          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//          request.timeoutInterval = 10
//          
//          // POST 로 보낼 정보
//          let params = ["userId":"qwer", "password":"qwer"] as Dictionary
//
//          // httpBody 에 parameters 추가
//          do {
//              try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
//          } catch {
//              print("http Body Error")
//          }
//    
//          AF.request(request).responseJSON { (response) in
//              switch response.result {
//              case .success(let value):
//                  print("POST 성공")
//                print(value)
//                print("=======")
//    
//                do {
//                  let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                  
//                  let session = try JSONDecoder().decode(UserSession.self, from: data)
////                  session.sessionId
//                  uersd.sessionId = "{token : "+session.sessionId+"}"
//                  uersd.sessionId2 = session.sessionId
////                  uersd.sessionId = session.sessionId
//                }
//                catch {
//                  
//                }
//                print(uersd.sessionId)
//              
//              case .failure(let error):
//                  print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
//              }
//          }
//      }
//  
//  
//    var body: some View {
//      VStack{
//        Button(action: {
//          SocketIOManager.shared.establishConnection()
//        }) {
//          Text("연결")
//        }
//        
//        Button(action: {
//          SocketIOManager.shared.closeConnection()
//        }) {
//          Text("연결해제")
//        }
//        
//        Button(action: {
////          AF.request("http://192.168.10.105:3010/auth/login").response { response in
////              debugPrint(response)
////          }
//          postTest()
//          
//        }) {
//          Text("http")
//        }
//        
//        Button(action: {
//          SocketIOManager.shared.createEmit()
//        }) {
//          Text("emit")
//        }
//        
//        Button(action: {
//          SocketIOManager.shared.subscribeEmit()
//        }) {
//          Text("구독")
//        }
//        Button(action: {
//          SocketIOManager.shared.newArriveOn()
//        }) {
//          Text("on")
//        }
//      }
//      .onAppear(perform: {
//        //            postTest()
////        SocketIOManager.shared.establishConnection()
////        SocketIOManager.shared.newArriveOn()
////        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
////          SocketIOManager.shared.subscribeEmit()
////        }
//
//        
//        
//      })
////      .onDisappear(perform: {
////        SocketIOManager.shared.closeConnection()
////      })
//    }
//  
//}
//
//struct TEST_Previews: PreviewProvider {
//    static var previews: some View {
//        TEST()
//    }
//}
