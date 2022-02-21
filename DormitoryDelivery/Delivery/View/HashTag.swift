//
//  HashTag.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import SwiftUI

struct HashTag: View {
  @Binding var flag: [Bool]
  var tag: Int

    var body: some View {
      if flag[tag]{
        Button {
          withAnimation(Animation.default.speed(5)) {
            self.flag[tag].toggle()
          }
//          self.flag[tag].toggle()
        } label: {
          Text(category[tag])
            .font(.system(size: 12, weight: .bold))
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color(.sRGB, red: 93/255, green: 95/255, blue: 235/255, opacity: 1), lineWidth: 1.5))
        }
      } else {
        Button {
          withAnimation(Animation.default.speed(5)) {
            self.flag[tag].toggle()
          }
          
        } label: {
          Text(category[tag])
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(Color.gray)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .overlay(RoundedRectangle(cornerRadius: 21).stroke(Color.gray, lineWidth: 1.5))
        }
      }
    }
}

//struct HashTag_Previews: PreviewProvider {
//    static var previews: some View {
//        HashTag()
//    }
//}
