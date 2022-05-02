//
//  CategoryView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/29.
//

import SwiftUI

struct CategoryView: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var createRoomData: CreateRoom
  
    var body: some View {
      List(category.indices, id:\.self) { index in
        Button {
          createRoomData.category = index
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text(category[index])
            .font(.system(size: 16, weight: .regular))
        }
        .padding()
      }.listStyle(InsetListStyle())
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("카테고리")
      .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "chevron.left")
            }
            .foregroundColor(.black)
          }
      }
      
      
    }
}
