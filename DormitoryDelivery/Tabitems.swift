//
//  tabitems.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/05.
//

import SwiftUI

struct Tabitems: View {
    var body: some View {
      Image("a_홈")
        .resizable()
        .scaledToFit()
        .frame(width: 10, height: 10)
    }
}

struct tabitems_Previews: PreviewProvider {
    static var previews: some View {
        Tabitems()
    }
}
