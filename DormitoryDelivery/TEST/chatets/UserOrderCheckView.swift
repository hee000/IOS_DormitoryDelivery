//
//  UserOrderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import SwiftUI
import Alamofire

struct UserOrderCheckView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var model: UserOrderCheck = UserOrderCheck()
  @EnvironmentObject var naverLogin: NaverLogin

  var roomid: String

    var body: some View {
      NavigationView{
        VStack{
          Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
          Button("Dismiss") {
              presentationMode.wrappedValue.dismiss()
          }
          Image(uiImage: model.image)
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
          
          if model.data != nil {
            Text(model.data!.accountBank)
          }

        } // Vstack
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("영수증")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
      }
      .onAppear {
        let destination: DownloadRequest.Destination = { _, _ in
               let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
               .userDomainMask, true)[0]
               let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
               let fileURL = documentsURL.appendingPathComponent("image.jpg")

               return (fileURL, [.removePreviousFile, .createIntermediateDirectories]) }
        
        AF.download(urlimgdownload(rid: self.roomid),
                    headers: ["Authorization": naverLogin.loginInstance!.accessToken] ,to: destination)
               .downloadProgress { progress in
                      print("Download Progress: \(progress.fractionCompleted)")
                   }
               .response { response in
                           debugPrint(response)
                   if response.error == nil, let imagePath = response.fileURL?.path {
                               let image = UIImage(contentsOfFile: imagePath)
                     model.image = image ?? UIImage()
                           }
                       }
        
        
        AF.request(urlreceipt(rid: self.roomid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": naverLogin.loginInstance!.accessToken])
          .responseJSON { response in
            do {
              let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
              let session = try JSONDecoder().decode(Receipt.self, from: data2)

              print(session)
              model.data = session
                
              }
            catch {
              print(error)
            }

        }
        
      }
        
      
    }
}

class UserOrderCheck: ObservableObject {
  @Published var image = UIImage()
  @Published var data: Receipt? = nil
}


struct Receipt: Codable {
  var menus: [orderlistmenudata];
  var tipForUser: Int?;         // 제목
  var totalPrice: Int?;          // 배달지역
  var accountNumber: String;               // 현재 총 금액
  var accountBank: String;        // 최소 주문 금액
  var accountUserName: String;    // 방장 이름
}

