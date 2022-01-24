//
//  OderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI
import UIKit

struct OderCheckView: View {
  @State private var isShowPhotoLibrary = false
  @State private var image = UIImage()
  @State var tip = "600"
  
    var body: some View {
      VStack{
        Text("인증서")
        Divider()

        Button("이미지상태확인"){
          print(self.image.size == CGSize(width: 0, height: 0))
        }
        
        Text("가격을 확인할 수 있는 캡처 사진을 올려주세요.")
        Button(action: {
            self.isShowPhotoLibrary = true
        }) {
            ZStack {
                Text("캡처 사진 가져오기")

                Image(uiImage: self.image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 300, height: 300)
                  .clipped()
            }
            .frame(width: 300, height: 300)
            .background(.gray)
        }
        
        TextEditor(text: $tip)
        
      }
      .fullScreenCover(isPresented: $isShowPhotoLibrary) {
        ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
      }
    }
}
