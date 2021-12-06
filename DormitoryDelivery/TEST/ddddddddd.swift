//
//  ddddddddd.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/05.
//

import SwiftUI

struct ddddddddd: View {
  var observables = ["전체", "창조"," 나래",  "호연"]
  @State var selectedColor = 0
    var body: some View {

      ZStack{
        Text("전체")
          .foregroundColor(Color.black)
          .font(.largeTitle)
          .bold()
        
        Menu("전체") {
          Text("Menu Item 1")
          Text("Menu Item 2")
          Text("Menu Item 3")
        }
        .font(.largeTitle)
//          .frame(width: 100, height: 100)
        .opacity(0.1)
      }
    }
}

struct ddddddddd_Previews: PreviewProvider {
    static var previews: some View {
        ddddddddd()
    }
}
