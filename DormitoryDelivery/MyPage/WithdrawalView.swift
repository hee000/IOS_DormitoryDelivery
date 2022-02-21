//
//  WithdrawalView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/15.
//

import SwiftUI

struct WithdrawalView: View {
  @Environment(\.presentationMode) var presentationMode

  
    var body: some View {
        Text("회원탈퇴뷰")
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("회원탈퇴")
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

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}
