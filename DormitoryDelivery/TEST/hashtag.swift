//
//  hashtag.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/05.
//

import SwiftUI

struct hashtag: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .padding(5)
//        .border(Color.blue, width: 2)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 2))
    }
}

struct hashtag_Previews: PreviewProvider {
    static var previews: some View {
        hashtag()
    }
}
