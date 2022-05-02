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
        Text("개인정보 처리방침뷰")
      
      
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
    }
}
struct PrivacyPoliceView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPoliceView()
    }
}
