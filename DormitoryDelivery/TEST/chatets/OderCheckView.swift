//
//  OderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI
import UIKit
import Alamofire

class OderCheck: ObservableObject {
  @Published var isShowPhotoLibrary = false
  @Published var image = UIImage()
  @Published var tip = "600"
  @Published var imageupload = false
}

struct OderCheckView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var oderCheckData: OderCheck = OderCheck()

  var roomid: String
    var body: some View {
      NavigationView {
        VStack{
          Text("인증서")
          Divider()

  //        Button("나가기"){
  //          presentationMode.wrappedValue.dismiss()
  //        }
          
          Button("이미지상태확인"){
            if self.oderCheckData.image.size != CGSize(width: 0, height: 0){
              if let mytoken = naverLogin.loginInstance?.accessToken {
                postOrderCheck(rid: self.roomid, token: mytoken, model: oderCheckData)
              }
            }
          }
          
          Text("가격을 확인할 수 있는 캡처 사진을 올려주세요.")
          Button(action: {
            self.oderCheckData.isShowPhotoLibrary = true
          }) {
              ZStack {
                  Text("캡처 사진 가져오기")

                  Image(uiImage: self.oderCheckData.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipped()
              }
              .frame(width: 300, height: 300)
              .background(.gray)
          }
          
          TextEditor(text: $oderCheckData.tip)
          
        } // vstack
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("주문 확인")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }
        }
      } //navi
      .fullScreenCover(isPresented: $oderCheckData.isShowPhotoLibrary) {
        ImagePicker(selectedImage: self.$oderCheckData.image, sourceType: .photoLibrary)
      }
    }
}


struct oderccc: Codable {
  var rid: String            // 이름
  var delivery_tip : Int            // 개수
}
