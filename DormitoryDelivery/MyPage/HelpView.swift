//
//  HelpView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/04/13.
//

import SwiftUI

struct HelpView: View {
  @Environment(\.presentationMode) var presentationMode

  
    var body: some View {
        Text("도뭄말뷰")
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("도움말")
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


struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
