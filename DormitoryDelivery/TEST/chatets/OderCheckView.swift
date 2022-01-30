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
  @Published var tip = ""
  @Published var imageupload = false
}

struct OderCheckView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var oderCheckData: OderCheck = OderCheck()

  var roomid: String
    var body: some View {
      NavigationView {
        VStack(alignment: .leading) {

          Text("가격을 확인할 수 있는 캡처 사진을 올려주세요.")
            .bold()
            .padding([.top, .bottom], 10)
          
          Button(action: {
            self.oderCheckData.isShowPhotoLibrary = true
          }) {
              ZStack {
                VStack{
                  Text("캡처 사진 가져오기")
                  Image(systemName: "plus.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                }
                .foregroundColor(.black)
                Image(uiImage: self.oderCheckData.image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 300, height: 300)
                  .clipped()
              }
              .frame(width: 300, height: 300)
              .background(Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1))
              .cornerRadius(5)
              .clipped()
              .shadow(color: Color.black.opacity(0.5), radius: 5)
          }
          .frame(maxWidth: .infinity)
          .padding(.bottom)
          .padding(.bottom)
          
          Text("배탈팁을 적어주세요.")
            .bold()
          TextField("가격", text: $oderCheckData.tip)
            .keyboardType(.phonePad)
            .font(.subheadline)
          Divider()
          
          Spacer()
          
          Button{
            if self.oderCheckData.image.size != CGSize(width: 0, height: 0){
              if let mytoken = naverLogin.loginInstance?.accessToken {
                postOrderCheck(rid: self.roomid, token: mytoken, model: oderCheckData)
              }
            }
          } label: {
            Text("보내기")
              .font(.title3)
              .foregroundColor(.white)
              .bold()
              .frame(height: 50)
              .frame(maxWidth: .infinity)
          }
          .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
          .cornerRadius(5)
          .padding([.leading, .trailing])

        } // vstack
        .onTapGesture {
            hideKeyboard()
        }
        .padding([.leading, .trailing])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("인증서")
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
      } //navi
      .sheet(isPresented: $oderCheckData.isShowPhotoLibrary) {
        ImagePicker(selectedImage: self.$oderCheckData.image, sourceType: .photoLibrary)
      }
//      .fullScreenCover(isPresented: $oderCheckData.isShowPhotoLibrary) {
//        ImagePicker(selectedImage: self.$oderCheckData.image, sourceType: .photoLibrary)
//      }
    }
}


struct oderccc: Codable {
  var rid: String            // 이름
  var delivery_tip : Int            // 개수
}
