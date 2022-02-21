//
//  TOSView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/15.
//

import SwiftUI

struct TOSView: View {
  @Environment(\.presentationMode) var presentationMode

  
    var body: some View {
        Text("이용약관뷰")
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("이용약관")
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

struct TOSView_Previews: PreviewProvider {
    static var previews: some View {
        TOSView()
    }
}
