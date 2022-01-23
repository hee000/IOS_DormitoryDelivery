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
    @Published var text = ""
    @Published var showMenu = false
    @Published var leave = false
    @Published var oderview = false
    @Published var oderlistview = false
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
//        HStack(spacing: 0 ) {
//            content()
//                .padding(.all, 15)
//                .foregroundColor(Color.white)
//                .background(color)
//                .clipShape(RoundedRectangle(cornerRadius: 18))
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                        .foregroundColor(color)
//                        .rotationEffect(Angle(degrees: position == .left ? -50 : -130))
//                        .offset(x: position == .left ? -5 : 5)
//                    ,alignment: position == .left ? .bottomLeading : .bottomTrailing)
//        }
//        .padding(position == .left ? .leading : .trailing , 15)
//        .padding(position == .right ? .leading : .trailing , 60)
//        .frame(width: UIScreen.main.bounds.width, alignment: position == .left ? .leading : .trailing)

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
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                        .foregroundColor(color)
//                        .rotationEffect(Angle(degrees:-50))
//                        .offset(x: -5)
//                    ,alignment: .bottomLeading)
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
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                        .foregroundColor(color)
//                        .rotationEffect(Angle(degrees:-50))
//                        .offset(x: -5)
//                    ,alignment: .bottomLeading)
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
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                        .foregroundColor(color)
//                        .rotationEffect(Angle(degrees:-130))
//                        .offset(x:5)
//                    ,alignment: .bottomTrailing)
        }
        .padding(.trailing , 15)
        .padding(.leading , 60)
        .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
      } else {
        HStack(spacing: 0 ) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 18))
//                .overlay(
//                    Image(systemName: "arrowtriangle.left.fill")
//                      .foregroundColor(.gray)
//                        .rotationEffect(Angle(degrees:-130))
//                        .offset(x:5)
//                    ,alignment: .bottomTrailing)
        }
//        .padding(.trailing , 15)
//        .padding(.leading , 60)
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
      }



      
      
      
    }
}


