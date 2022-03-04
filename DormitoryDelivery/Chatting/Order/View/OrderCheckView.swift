//
//  OderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI
import UIKit
import Alamofire


struct OrderCheckView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @Environment(\.presentationMode) var presentationMode
  @StateObject var orderCheckData: OrderCheck = OrderCheck()
  @StateObject var userPrivacy = UserData()

  var roomid: String
    var body: some View {
      NavigationView {
        ZStack{
          VStack(alignment: .leading) {
            Text("가격을 확인할 수 있는 캡처 사진을 올려주세요.")
              .bold()
              .padding([.top, .bottom], 10)
            
            Button(action: {
              self.orderCheckData.isShowPhotoLibrary = true
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
                  Image(uiImage: self.orderCheckData.image)
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
            TextField("가격", text: $orderCheckData.tip)
              .keyboardType(.phonePad)
              .font(.subheadline)
              .padding(.bottom)
              .padding(.bottom)
            
            Text("계좌를 확인해주세요.")
              .bold()
            VStack{
              if !userPrivacy.data.accounts.isEmpty {
                if let acc = userPrivacy.data.mainAccount {
                  VStack(alignment: .leading) {
                    Text(acc.bank!)
                      .bold()
                    
                    Text(acc.account!)
                      .bold()
                    
                    HStack{
                      Text("예금주: ")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .padding(.top, 1)
                      Text(acc.name!)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .padding(.top, 1)
                    }
                  }
                  .padding()
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                  .cornerRadius(5)
                  .clipped()
                  .shadow(color: Color.black.opacity(0.15), radius: 8)
                  .padding([.leading, .trailing])
                }
              }
            }
            
            Divider()
            
            Spacer()
          } // vstack
          .onTapGesture {
              hideKeyboard()
          }
          
          VStack{
            Spacer()
            
            Button{
              if self.orderCheckData.image.size != CGSize(width: 0, height: 0){
                postOrderCheck(rid: self.roomid, model: orderCheckData, account: userPrivacy.data.mainAccount!)
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
          } // v 버튼
          .ignoresSafeArea(.keyboard)

        } //z
        .onChange(of: orderCheckData.imageupload, perform: { newValue in
          presentationMode.wrappedValue.dismiss()
        })
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
      .sheet(isPresented: $orderCheckData.isShowPhotoLibrary) {
        ImagePicker(selectedImage: self.$orderCheckData.image, sourceType: .photoLibrary)
      }
//      .fullScreenCover(isPresented: $oderCheckData.isShowPhotoLibrary) {
//        ImagePicker(selectedImage: self.$oderCheckData.image, sourceType: .photoLibrary)
//      }
    }
}
