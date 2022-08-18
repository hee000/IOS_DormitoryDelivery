//
//  textview.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/18.
//

import SwiftUI

struct textview: View {
    var body: some View {
      ForEach(0..<3, id:\.self) { index in
        let a = print("변화")
        Text("\(index)")
      }
    }
}

struct textview_Previews: PreviewProvider {
    static var previews: some View {
        textview()
    }
}
