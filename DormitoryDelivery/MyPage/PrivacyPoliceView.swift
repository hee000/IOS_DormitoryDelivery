//
//  PrivacyPoliceView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/04/12.
//

import SwiftUI

struct PrivacyPoliceView: View {
  @Environment(\.presentationMode) var presentationMode

  
    var body: some View {
        Webview(url: URL(string: "https://gachihasil.link/policy/privacy.html")!)
        .edgesIgnoringSafeArea(.bottom)
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("개인정보 처리방침")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
                  .foregroundColor(.black)
              }
            }
          }
        }
        .background(Color(.sRGB, red: 243/255, green: 242/255, blue: 238/255, opacity: 1))
    }
}
struct PrivacyPoliceView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPoliceView()
    }
}
