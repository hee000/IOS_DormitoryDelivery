//
//  AlertView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/27.
//

import SwiftUI

struct AlertOneButton: View {
  @Binding var isActivity: Bool
  
  var text: String
    var body: some View {
      ZStack{
        Color.black.opacity(0.5)
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
          .edgesIgnoringSafeArea(.all)
        
          VStack(spacing: 0) {
            VStack{
              Text(self.text)
            }
              .padding()
              .padding([.top, .bottom])
              .padding(.top)
            Divider()
            Button {
              self.isActivity.toggle()
            } label : {
              Text("확인")
            }
            .foregroundColor(.black)
            .padding()
          }
          .frame(width: UIScreen.main.bounds.width * 2/3)
          .background(.white)
          .cornerRadius(5)
          .transition(AnyTransition.opacity.animation(Animation.easeInOut))
      }
    }
}



struct AlertTwoButton: View {
  @Binding var yesButton: Bool
  @Binding var noButton: Bool
  
  var text1: String
  var text2: String
    var body: some View {
      ZStack{
        Color.black.opacity(0.5)
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
          .edgesIgnoringSafeArea(.all)
        
          VStack(spacing: 0) {
            VStack{
              Text(self.text1)
              Text(self.text2)
            }
              .padding()
              .padding([.top, .bottom])
              .padding(.top)
            Divider()
            HStack(spacing:0){
              Spacer()
              Button {
                self.yesButton.toggle()
              } label : {
                Text("확인")
              }
              .foregroundColor(.black)
              .padding()
              Spacer()
              Divider()
              Spacer()
              Button {
                self.noButton.toggle()
              } label : {
                Text("취소")
              }
              .foregroundColor(.black)
              .padding()
              Spacer()
            }
            .frame(width:UIScreen.main.bounds.width * 2/3)
            .fixedSize()
          }
          .frame(width: UIScreen.main.bounds.width * 2/3)
          .background(.white)
          .cornerRadius(5)
          .transition(AnyTransition.opacity.animation(Animation.easeInOut))
      }
    }
}
