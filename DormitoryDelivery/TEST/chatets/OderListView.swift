//
//  OderListView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/24.
//

import SwiftUI

struct OderListView: View {
  @Environment(\.presentationMode) var presentationMode

    var body: some View {
      VStack{
        Button("Dismiss") {
            presentationMode.wrappedValue.dismiss()
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      }
    }
}

struct OderListView_Previews: PreviewProvider {
    static var previews: some View {
        OderListView()
    }
}
