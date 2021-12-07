//
//  Join.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/11/16.
//

import SwiftUI
import Foundation
import Combine




//struct ReceivingChatMessage: Decodable, Identifiable {
//  let date: Date
//  let id: UUID
//  let message: String
//}






struct ChattingView: View {
  var Id_room: String
  @State private var message22 = "input"
  @ObservedObject var models = model()
//  @State private var message33 = self.models.messages

  @State var chattest:Bool = true
  
  
  func scrollToLastMessage(proxy: ScrollViewProxy) {
    if let lastMessage = models.messages.last { // 4
      withAnimation(.easeOut(duration: 0.4)) {
        proxy.scrollTo(lastMessage.id, anchor: .bottom) // 5
      }
    }
  }

  
    var body: some View {
//      Text(String(self.Id_room))
      VStack {
        // Chat history.
//        ScrollView {
//          LazyVStack(spacing: 8) {
//            ForEach(models.messages.indices, id: \.self) { index in
//              Text(models.messages[index])
//            }
//          }
//        }
//        
        
        ScrollView {
          ScrollViewReader { proxy in // 1
            LazyVStack(spacing: 8) {
              ForEach(models.messages.indices, id: \.self) { index in
//                Text(models.messages[index].message)
//                  .id(models.messages[index].id) // 2
                
                HStack {
                  if models.messages[index].userID {
                    Spacer()
                  }
                  
                  VStack(alignment: .leading, spacing: 6) {
                    HStack {
                      Text(models.messages[index].user)
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                      
//                      Text(Self.dateFormatter.string(from: message.date))
//                        .font(.system(size: 10))
//                        .opacity(0.7)
                    }
                    
                    Text(models.messages[index].message)
                  }
                  .id(models.messages[index].id)
                  .foregroundColor(models.messages[index].userID ? .white : .black)
                  .padding(10)
                  .background(models.messages[index].userID ? Color.blue : Color(white: 0.95))
                  .cornerRadius(5)
                  
                  
                  if !models.messages[index].userID {
                    Spacer()
                  }
                }
                .padding()
                
                
              }
            }
            .onChange(of: models.messages.count) { _ in // 3
              scrollToLastMessage(proxy: proxy)
            }
          }
        }

        // Message field.
        HStack {
          TextField("Message", text: $message22) // 2
            .padding(10)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(5)
          
          
          Button(action: {
            
            if chattest {
              models.messages.append(modelm(id: UUID(), message: message22, user: "name", userID: true))
              chattest = false
            } else {
              models.messages.append(modelm(id: UUID(), message: message22, user: "상대방", userID: false))
              chattest = true
            }
//            models.messages.append(modelm(id: UUID(), message: message22, user: "name", userID: true))
//            print(modelm(id: UUID(), message: message22))
            chatemit(text: message22)
            
            
          }) { // 3
            Image(systemName: "arrowshape.turn.up.right")
              .font(.system(size: 20))
          }
          .padding(.trailing)
          .disabled(message22.isEmpty) // 4
        }
        .padding(.leading)
      
      }
      
    }
}

func chatemit (text: String) {
  SocketIOManager.shared.socket3.emitWithAck("chat", text).timingOut(after: 2, callback: { (data) in
  })
}

struct Join_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView(Id_room: "14")
    }
}
