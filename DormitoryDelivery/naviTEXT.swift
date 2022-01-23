//
//  naviTEXT.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/23.
//

import SwiftUI

struct naviTEXT: View {
    var body: some View {
      VStack{
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
          .navigationBarTitleDisplayMode(.inline)
//          .navigationBartitle("ad")
          .navigationBarTitle("ad")
      }
    }
}

struct naviTEXT_Previews: PreviewProvider {
    static var previews: some View {
        naviTEXT()
    }
}
