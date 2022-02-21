//
//  Message.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import SwiftUI

enum MessageType {
  case newLeft
  case left2
  case right
  case right2
  case orderFixed
  case orderChecked
  case voteKickCreated
  case voteKickFinished
  case voteResetCreated
  case voteResetFinished
}

struct Message: View {
  @StateObject var model: Chatting
  
  var RoomDB: ChatDB
  var type: MessageType
  var index: Int
  
  var body: some View {
    let privacy = getUserPrivacy()
    
    if type == .newLeft {
      if RoomDB.messages[index].body!.userid == RoomDB.superUser!.userId {
        HStack(alignment: .top, spacing: 0) { // 방장인경우
          Image("ImageDefaultProfile")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .cornerRadius(28)
            .shadow(color: Color.black.opacity(0.5), radius: 1)
            .padding(.trailing, 5)
          VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0){
              Image("ImageSuperCrown")
                .resizable()
                .scaledToFit()
                .frame(width: 9, height: 8)
              Text("방장 | \(RoomDB.messages[index].body!.username!)")
                .font(.system(size: 12, weight: .regular))
//                .font(.footnote)
                .padding(.leading, 3)
            }
            .padding([.top, .bottom], 3)
            Text(RoomDB.messages[index].body!.message!)
              .font(.system(size: 14, weight: .regular))
              .padding(10)
              .foregroundColor(Color.black)
              .background(.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .background(Color.white
                            .frame(width: 30, height:30)
                            .position(x: 0, y: 0)
              )
              .clipped()
          }
        }
        .padding(.leading, 10)
        .padding(.trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment:.leading)
      } else {
        HStack(alignment: .top, spacing: 0) {
          Image("ImageDefaultProfile")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
            .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
            .cornerRadius(28)
            .shadow(color: Color.black.opacity(0.5), radius: 1)
            .padding(.trailing, 5)
          VStack(alignment: .leading, spacing: 0) {
            Text(RoomDB.messages[index].body!.username!)
              .font(.system(size: 12, weight: .regular))
//              .font(.footnote)
              .padding([.top, .bottom], 3)
            Text(RoomDB.messages[index].body!.message!)
              .font(.system(size: 14, weight: .regular))
              .padding(10)
              .foregroundColor(Color.black)
              .background(.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
              .background(Color.white
                            .frame(width: 30, height:30)
                            .position(x: 0, y: 0)
              )
              .clipped()
          }
        }
        .padding(.leading, 10)
        .padding(.trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment:.leading)
      }
    } else if type == .orderFixed {
      HStack{
        VStack(alignment: .leading){
          Text("방장이 메뉴를 확정했어요!")
            .font(.system(size: 16, weight: .bold))
          Text("이제 메뉴를 바꿀 수 없습니다.")
            .font(.system(size: 16, weight: .bold))
          Spacer()
        }
        .padding()
        Spacer()
        Image("ImageOrderFix")
          .resizable()
          .scaledToFit()
          .frame(width: 97, height: 81)
          .padding()
      }
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.2), radius: 4)
      .padding(10)
    } else if type == .orderChecked {
      if RoomDB.superUser!.userId! != UserDefaults.standard.string(forKey: "MyID")! {
        VStack(spacing: 0){
          HStack{
            VStack(alignment: .leading){
              Text("\(privacy.name!)님의")
                .font(.system(size: 16, weight: .bold))
              Text("보낼 금액을 확인해보세요.")
                .font(.system(size: 16, weight: .bold))
            }
            Spacer()
            Image("ImageOrderCheck")
              .resizable()
              .scaledToFit()
              .frame(width: 135, height: 73)
          }
          .padding()
          .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
          Button{
            self.model.userodercheck.toggle()
          } label: {
            Text("주문내역 확인하기")
              .font(.system(size: 14, weight: .regular))
              .frame(height: 40)
              .frame(maxWidth: .infinity)
          }
          .background(Color(.sRGB, red: 225/255, green: 225/255, blue: 231/255, opacity: 1))
          .cornerRadius(5)
          .padding([.leading, .trailing])
          .padding([.top, .bottom], 10)
        } //v
        .frame(width: UIScreen.main.bounds.width * 9/10)
        .background(.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.2), radius: 4)
        .padding(10)

      } else {
        VStack(spacing: 0){
          HStack{
            VStack(alignment: .leading){
              Text("영수증을 전달했습니다.")
                .bold()
              Text("입금이 확인되면 주문을 마무리하고 주문 완료 버튼을 눌러주세요!")
                .bold()
            }
            Spacer()
            Image("ImageOrderCheck")
              .resizable()
              .scaledToFit()
              .frame(width: 135, height: 73)
          }
          .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 9/10)
        .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.2), radius: 4)
        .padding(10)
      }
    } else if type == .voteKickCreated {    // 강퇴 투표 시작
      VStack(spacing: 0){
        VStack {
          Text("\(RoomDB.messages[index].body!.data!.targetUser!.name!)님에 대한")
            .bold()
          Text("강퇴 건의가 시작되었습니다.")
            .bold()
        }
        .padding()
        Button{
//           self.userodercheck.toggle()
        } label: {
          Text("투표하기")
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.sRGB, red: 225/255, green: 225/255, blue: 231/255, opacity: 1))
        .cornerRadius(5)
        .padding([.leading, .trailing])
        .padding([.top, .bottom], 10)
      } //v
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.2), radius: 4)
      .padding(10)
    } else if type == .voteKickFinished {   // 강퇴 투표 끝
      VStack {
        Text("\(RoomDB.messages[index].body!.data!.target!.name!)님에 대한")
          .bold()
        Text("강퇴 건의가 승인되었습니다.") //부결되었습니다
          .bold()
      }
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.2), radius: 4)
      .padding(10)
    } else if type == .voteResetCreated {   // 리셋 투표 시작
      VStack(spacing: 0){
        VStack {
          Text("방에 대한")
            .bold()
          Text("리셋 건의가 시작되었습니다.")
            .bold()
        }
        .padding()
        Button{
        } label: {
          Text("투표하기")
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.sRGB, red: 225/255, green: 225/255, blue: 231/255, opacity: 1))
        .cornerRadius(5)
        .padding([.leading, .trailing])
        .padding([.top, .bottom], 10)
      } //v
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.2), radius: 4)
      .padding(10)
    } else if type == .voteResetFinished {
      VStack {
        Text("방에 대한 리셋 건의가 승인되었습니다.")
          .bold()
      }
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.2), radius: 4)
      .padding(10)
    }
  }
}

//struct Message_Previews: PreviewProvider {
//    static var previews: some View {
//        Message()
//    }
//}
