//
//  bubble.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import Foundation
import SwiftUI

enum BubblePosition {
    case left
    case left2
    case right
    case center
}


class ChatModel: ObservableObject {
    @Published var text = "33333"
    @Published var showMenu = false
    @Published var leave = false
    @Published var oderview = false
    @Published var oderlistview = false
    @Published var odercheck = false
    @Published var userodercheck = false
}


//struct CardTest : View {
//  var body: some View {
//    
//  }
//}

struct ChatBubble<Content>: View where Content: View {
    let position: BubblePosition
    let color : Color
    let content: () -> Content
    init(position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.color = color
        self.position = position
    }
    
    var body: some View {
      if position == .left {
        HStack(spacing: 0 ) {
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
          
            content()
                .padding(.all, 15)
                .foregroundColor(Color.black)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.leading, 15)
        .padding(.trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment:.leading)
      } else if position == .left2 {
        HStack(spacing: 0 ) {
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 0))
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
          
            content()
                .padding(.all, 15)
                .foregroundColor(Color.black)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.leading, 15)
        .padding(.trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment:.leading)
      } else if position == .right {
        HStack(spacing: 0 ) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .padding(.trailing , 15)
        .padding(.leading , 60)
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
      } else {
        HStack(spacing: 0 ) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.black)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
      }



      
      
      
    }
}


