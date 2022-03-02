//
//  AlertView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/27.
//

import SwiftUI

struct AlertOneButton<Content>: View where Content: View {
  @Binding var isActivity: Bool
  var content: () -> Content
  
  init(isActivity: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    self._isActivity = isActivity
    self.content = content
  }

    var body: some View {
      ZStack{
        Color.black.opacity(0.5)
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
          .edgesIgnoringSafeArea(.all)
        
          VStack(spacing: 0) {
            VStack{
              content()
            }
              .padding()
              .padding([.top, .bottom])
              .padding(.top)
            Divider()
            Button {
              self.isActivity.toggle()
            } label : {
              Text("확인")
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity)
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



struct AlertTwoButton<Content>: View where Content: View {
  @Binding var yesButton: Bool
  @Binding var noButton: Bool
  var content: () -> Content

  init(YActivity: Binding<Bool>, NActivity: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
    self._yesButton = YActivity
    self._noButton = NActivity
    self.content = content
  }
  
    var body: some View {
      ZStack{
        Color.black.opacity(0.5)
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
          .edgesIgnoringSafeArea(.all)
        
          VStack(spacing: 0) {
            VStack{
              content()
            }
              .padding()
              .padding([.top, .bottom])
              .padding(.top)
            Divider()
            HStack(spacing:0){
              Button {
                self.noButton.toggle()
              } label : {
                Text("취소")
                  .font(.system(size: 16, weight: .regular))
                  .frame(maxWidth: .infinity)
              }
              .foregroundColor(.black)
              .padding()
              Divider()
              Button {
                self.yesButton.toggle()
              } label : {
                Text("확인")
                  .font(.system(size: 16, weight: .regular))
                  .frame(maxWidth: .infinity)
              }
              .foregroundColor(.black)
              .padding()
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
