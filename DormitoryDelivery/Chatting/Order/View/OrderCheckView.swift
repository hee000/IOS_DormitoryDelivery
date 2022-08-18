//
//  OderCheckView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI
import UIKit
import Alamofire
import Photos


struct OrderCheckView: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @Environment(\.presentationMode) var presentationMode
  @StateObject var orderCheckData: OrderCheck = OrderCheck()
  @StateObject var userPrivacy = UserData()

  var roomid: String
    var body: some View {
      NavigationView {
        ZStack{
          ScrollView {
            VStack(alignment: .leading) {
              VStack(alignment: .leading) {
                Text("가격을 확인할 수 있는 캡처 사진을 올려주세요.")
                  .font(.system(size: 16, weight: .bold))
                  .padding([.top, .bottom], 10)
                
                ZStack {
                  
                  
                  Button(action: {
                    self.orderCheckData.isShowPhotoLibrary = true
                  }) {
                      ZStack {
                        VStack{
                          Text("캡처 사진 가져오기")
                            .font(.system(size: 16, weight: .regular))
                          Image(systemName: "plus.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        }
                        .foregroundColor(self.orderCheckData.images.isEmpty ? Color.black : Color.clear)
                      }
                      .frame(width: 300, height: 300)
                      .background(Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1))
//                      .background(.white)
                      .cornerRadius(5)
                      .clipped()
                      .shadow(color: Color.black.opacity(0.5), radius: 5)
                  } //btn
                  
                  .sheet(isPresented: $orderCheckData.isShowPhotoLibrary) {
                    PhotoLibraryPicker($orderCheckData.images)
                  }
                  
                  ImageSlider(images: self.orderCheckData.images)
                    .frame(width: 300, height: 300)
//                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .onTapGesture {
                      self.orderCheckData.isShowPhotoLibrary = true
                    }
                } // z
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                .padding(.bottom)
                
                Text("배탈팁을 적어주세요.")
                  .font(.system(size: 16, weight: .bold))
                TextField("가격", text: $orderCheckData.tip)
                  .keyboardType(.numberPad)
                  .font(.system(size: 16, weight: .bold))
                Divider()
                  .padding(.bottom)
                  .padding(.bottom)
                
                Text("계좌를 확인해주세요.")
                  .font(.system(size: 16, weight: .bold))
              } //v
              .padding([.leading, .trailing])
              
              VStack{
                if !userPrivacy.data!.accounts.isEmpty {
                  if let acc = userPrivacy.data!.mainAccount {
                    
                    HStack(alignment: .bottom) {
                      VStack(alignment: .leading) {
                        Text(acc.bank!)
                          .font(.system(size: 18, weight: .bold))
                        Text(acc.account!)
                          .font(.system(size: 18, weight: .bold))
                          .padding(.bottom, 5)
                        Text("예금주: \(acc.name!)")
                          .font(.system(size: 14, weight: .regular))
                          .foregroundColor(.gray)
                      }
                      
                      Spacer()
                      
                      NavigationLink(destination: AccountView()) {
                        Text("계좌 관리")
                          .font(.system(size: 14, weight: .regular))
                          .padding([.top, .bottom], 5)
                          .padding([.leading, .trailing], 7)
                          .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                          .foregroundColor(.black)
                      }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                    .cornerRadius(5)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.15), radius: 4)
                    .padding()
                  }
                }
              }
              
              Spacer()
            } // vstack
          }//scroll
          .onTapGesture {
              hideKeyboard()
          }
          
          VStack{
            Spacer()
            
            Button{
//              if self.orderCheckData.image.size != CGSize(width: 0, height: 0){
              if !self.orderCheckData.images.isEmpty {
                postOrderCheck(rid: self.roomid, model: orderCheckData, account: userPrivacy.data!.mainAccount!)
              }
            } label: {
              Text("보내기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
            .cornerRadius(5)
            .padding([.leading, .trailing])
          } // v 버튼
          .ignoresSafeArea(.keyboard)

        } //z
        .onAppear {
          PHPhotoLibrary.requestAuthorization { PHAuthorizationStatus in
            print(PHAuthorizationStatus)
          }
        }
        .onChange(of: orderCheckData.imageupload, perform: { newValue in
          presentationMode.wrappedValue.dismiss()
        })
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
//      .overlay(UserData().data?.mainAccount == nil ? AlertOneButtonPresentationMode(presentationMode: presentationMode) { Text("마이 페이지에서").font(.system(size: 16, weight: .regular))
//        Text("계좌 등록을 먼저 진행해주세요").font(.system(size: 16, weight: .regular)) } : nil)
//      .sheet(isPresented: $orderCheckData.isShowPhotoLibrary) {
//        ImagePicker(selectedImage: self.$orderCheckData.image, sourceType: .photoLibrary)
//      }
//      .fullScreenCover(isPresented: $oderCheckData.isShowPhotoLibrary) {
//        ImagePicker(selectedImage: self.$oderCheckData.image, sourceType: .photoLibrary)
//      }
    }
}
