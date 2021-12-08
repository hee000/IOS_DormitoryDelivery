//
//  ChatCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/08.
//

import SwiftUI

struct ChatCard: View {
  var roomid: String = ""
  @State var title:String = "제목"
  @State var lastmessage:String = "마지막 톡 내용ddddddddddddddddsdddddd"
  @State var lastmessagetime:String = "17:24"
  @State var notconfirm:Int = 2
  @State var usersnum:Int = 4
  
    var body: some View {
      HStack{
        NavigationLink(destination: ChattingView(Id_room: self.roomid)) {
          Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
            

          VStack(alignment: .leading, spacing: 5){
            Text(self.title)
              .font(.title3)
              .foregroundColor(Color.black)
            Text(self.lastmessage)
              .font(.body)
              .foregroundColor(Color.black)
          }
        
          Spacer()
        
          VStack(alignment: .trailing, spacing: 10) {
            Text(self.lastmessagetime)
              .font(.caption)
              .foregroundColor(Color.black)
            Text(String(self.notconfirm))
              .foregroundColor(Color.white)
              .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
              .background(Color.red)
              .cornerRadius(21)
            
          }.padding(.trailing)
        }
      }
      .frame(width: UIScreen.main.bounds.size.width, height: 60, alignment: .leading)
      .padding()
      .onAppear {
      }
    }
}

struct ChatCard_Previews: PreviewProvider {
    static var previews: some View {
        ChatCard()
    }
}
