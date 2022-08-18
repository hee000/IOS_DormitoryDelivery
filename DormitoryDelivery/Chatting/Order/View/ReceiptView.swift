//
//  UserOrderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import SwiftUI
import Alamofire
import MobileCoreServices // copy
import UniformTypeIdentifiers

struct ReceiptView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject var model: Receipt = Receipt()
  @EnvironmentObject var naverLogin: NaverLogin

  @State var imagetoggle = false
  var roomid: String

    var body: some View {
      NavigationView{
        ScrollView {
          if model.data != nil {
          VStack(alignment: .leading, spacing: 0){
            Text("배달팁과 총 결제금액을 확인해주세요.")
              .font(.system(size: 16, weight: .bold))
              .padding([.top, .bottom])
              .padding(.bottom)

            HStack{
              ImageSlider(images: self.model.images)
                .frame(width: 300, height: 300)
                .background(Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1))
                .cornerRadius(5)
                .clipped()
                .shadow(color: Color.black.opacity(0.5), radius: 5)
                .onTapGesture {
                  self.imagetoggle.toggle()
                }
            }
            .frame(maxWidth: .infinity)
            
            Text("주문 내역")
              .font(.system(size: 16, weight: .bold))
              .padding([.top, .bottom])
              .padding(.top)
            
            VStack(alignment: .leading) {
              if model.data != nil {
                ForEach(model.data!.menus.indices, id:\.self) { index in
                  HStack{
                    VStack(alignment: .leading, spacing: 10) {
                      Text("\(model.data!.menus[index].price)원")
                        .font(.system(size: 18, weight: .bold))
                      Text(model.data!.menus[index].name)
                        .font(.system(size: 14, weight: .bold))
                      if model.data!.menus[index].description != "" {
                        Text(model.data!.menus[index].description)
                          .foregroundColor(.gray)
                          .font(.system(size: 14, weight: .regular))
                      }
                    }
                    Spacer()
                    Text("수량 \(model.data!.menus[index].quantity) 개")
                      .font(.system(size: 14, weight: .regular))
                  }
                  Divider()
                    .padding([.top, .bottom], 10)
                }
                HStack{
                  Text("+ 배달팁")
                    .font(.system(size: 12, weight: .regular))
                  Spacer()
                  Text("\(model.data!.tipForUser ?? 0)원")
                    .font(.system(size: 12, weight: .regular))
                }
                .foregroundColor(Color(.sRGB, red: 132/255, green: 166/255, blue: 255/255, opacity: 1))
                .padding(.bottom, 5)

                HStack{
                  Text("총 주문금액")
                    .font(.system(size: 14, weight: .regular))
                  Spacer()
                  Text("\(model.data!.totalPrice ?? 0)원")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(.sRGB, red: 91/255, green: 66/255, blue: 212/255, opacity: 1))
                }
              }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.size.width * (9/10))
            .background(.white)
            .cornerRadius(5)
            .clipped()
            .shadow(color: Color.black.opacity(0.2), radius: 8)
            

            Text("계좌 확인하기")
              .font(.system(size: 16, weight: .bold))
              .padding([.top, .bottom])
              .padding(.top)
            HStack{
              VStack(alignment: .leading) {
                Text(model.data?.accountBank ?? "")
                  .font(.system(size: 18, weight: .bold))
                Text(model.data?.accountNumber ?? "")
                  .font(.system(size: 18, weight: .bold))
                  .padding(.bottom, 5)
                Text("예금주: \(model.data?.accountUserName ?? "")")
                  .font(.system(size: 14, weight: .regular))
                  .foregroundColor(.gray)
              }
              Spacer()
              Button{
                if model.data != nil {
                  let accountCopy = "\(model.data!.accountNumber) \(model.data!.accountBank) \(model.data!.accountUserName)"
                  UIPasteboard.general.setValue(accountCopy,
                      forPasteboardType: UTType.utf8PlainText.identifier as String)
                }
                //액션시트와 같은 종류로 복사하기가 완료되었다는 메시지 출력하기
              } label:{
                Text("계좌 복사")
                  .font(.system(size: 12, weight: .regular))
                  .frame(width:60, height: 40)
                  .foregroundColor(.white)
                  .background(Color(.sRGB, red: 165/255, green: 162/255, blue: 246/255, opacity: 1))
                  .cornerRadius(5)
              }
            }//h 계좌
            .padding()
            .frame(width: UIScreen.main.bounds.size.width * (9/10))
            .background(.white)
            .cornerRadius(5)
            .clipped()
            .shadow(color: Color.black.opacity(0.2), radius: 8)
            
        } // Vstack
          .padding([.leading, .trailing])
          .padding([.leading, .trailing])
        } // if model.data
      } //scroll
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("주문내역 확인")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.black)
            }
          }
        }
      } // navi
//      .overlay(self.imagetoggle ? Image(uiImage: model.image).resizable().background(Color.black) : nil)
      .overlay(self.imagetoggle ?
        NavigationView{
          GeometryReader{ geo in
//            Image(uiImage: model.image)
//              .resizable()
//              .scaledToFit()
//              .frame(maxWidth: .infinity, maxHeight: .infinity)
            ImageSlider(images: self.model.images)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } //geo
          .navigationBarTitleDisplayMode(.inline)
          .navigationBarTitle("영수증")
          .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
              Button {
                self.imagetoggle.toggle()
              } label: {
                Image(systemName: "xmark")
                  .foregroundColor(Color.white)
              }
            }
          }
          .background(Color.black)
       }
        .transition(AnyTransition.opacity.animation(.easeInOut))
        .onAppear(perform: {
          UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        })
               : nil) //overlay
      .onAppear {
        AF.request(urlimgdownloadurl(rid: self.roomid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
          .responseJSON { response2 in
//            var a = response2.
            guard let urls = response2.value as? [String] else { return }
            print(urls)
            
            var sync = [UIImage?](repeating: nil, count: 3)
            
            let destination : DownloadRequest.Destination  = { _, _ in
              let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                      .userDomainMask, true)[0]
              let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
              let fileURL = documentsURL.appendingPathComponent("image.jpg")
              return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }


            let dispatchGroup = DispatchGroup()
            let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent)
            
            for (idx, url) in urls.enumerated() {
              dispatchGroup.enter()
//              AF.download(URL(string: url)!, to: destination)
//                .downloadProgress { progress in
//  //                  print("Download Progress: \(progress.fractionCompleted)")
//                }
//                .response { response in
////                     debugPrint(response)
//                  if response.error == nil, let imagePath = response.fileURL?.path {
//                    let image = UIImage(contentsOfFile: imagePath)
////                    model.image = image ?? UIImage()
//                    print(idx)
//                    print("ala img", image)
//                    sync[idx] = image
//                  }
//                  dispatchGroup.leave()
//                }
              AF.download(URL(string: url)!)
                .responseData { AFdata in
                  print(AFdata.value)
                  
                  guard let data = AFdata.value,
                        let img = UIImage(data: data)
                  else { return }
                  sync[idx] = img
                  dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: queue) {
                DispatchQueue.main.async {
//                    self.reviewTableView.reloadData()
//                    self.dismissIndicator()
//                  print("sync",sync)
                  for otimage in sync {
                    if let image = otimage {
                      model.images.append(image)
                    }
                  }
////                  model.images
//                  print("model",model.images)
                    print("#3")
                }
            }
          }
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
//        let destination: DownloadRequest.Destination = { _, _ in
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
//                                                                  .userDomainMask, true)[0]
//          let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
//          let fileURL = documentsURL.appendingPathComponent("image.jpg")
//          return (fileURL, [.removePreviousFile, .createIntermediateDirectories]) }
        
//        AF.download(urlimgdownload(rid: self.roomid),
//                    headers: ["Authorization": naverLogin.sessionId] ,to: destination)
//          .downloadProgress { progress in
////                      print("Download Progress: \(progress.fractionCompleted)")
//          }
//          .response { response in
////                           debugPrint(response)
//            if response.error == nil, let imagePath = response.fileURL?.path {
//              let image = UIImage(contentsOfFile: imagePath)
//              model.image = image ?? UIImage()
//            }
//          }
        
        
        AF.request(urlreceipt(rid: self.roomid), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
          .responseJSON { response in
            do {
              let data2 = try JSONSerialization.data(withJSONObject: response.value, options: .prettyPrinted)
              let session = try JSONDecoder().decode(receiptdata.self, from: data2)
//              print(session)
              model.data = session
              }
            catch {
              print(error)
            }
        }
      } // onappear
    }
}
 
