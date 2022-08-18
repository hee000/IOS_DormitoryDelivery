//
//  Message.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/31.
//

import SwiftUI
import RealmSwift

//class ObservedChatDB: ObservableObject {
//  @Published var db: ChatDB?
//  private var token: NotificationToken?
//  private var rid: String
//
//  init(roomid: String) {
//    rid = roomid
//    let realm = try! Realm()
//    db = realm.object(ofType: ChatDB.self, forPrimaryKey: roomid)
//    activateChannelsToken()
//  }
//
//  private func activateChannelsToken() {
//    let realm = try! Realm()
//    let channel = realm.object(ofType: ChatDB.self, forPrimaryKey: rid)
//    guard let trueDB = channel else { return }
//    token = trueDB.observe { _ in
//      self.db = trueDB
//    }
//  }
//}

enum MessageType {
  case newLeft
  case left
  case right
//  case right2
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
  
  func readCount(_ isSelf: Bool = false) -> String {
    var count = isSelf ? RoomDB.member.count - 1 : RoomDB.member.count - 2
    
    let myuid = getUserPrivacy().id
    let mid = RoomDB.messages[index].body?.userid
    
    for read in RoomDB.read {
      if read.userId == myuid || mid == read.userId {
        continue
      }

      if isSelf && mid != myuid {
        continue
      }

      if let idx = RoomDB.messages[index].idx, read.messageId >= idx {
        count -= 1
      }
    }
    
    return String(count < 0 ? 0 : count)
  }
  
  func datetokor(chatdate: String) -> String {
    let date = DateFormatter()
    date.locale = Locale(identifier: "ko_kr")
    date.timeZone = TimeZone(abbreviation: "KST")
    date.dateFormat = "HH:mm"
    let chatdate = date.string(from: Date(timeIntervalSince1970: TimeInterval(Int(chatdate)!)/1000))
    return chatdate
  }

  
  var body: some View {
//    let a = print(index)
    let privacy = getUserPrivacy()
    if type == .newLeft {
      if RoomDB.messages[index].body!.userid == RoomDB.superUser?.userId {
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
                .padding(.leading, 3)
            }
            .padding([.top, .bottom], 3)
            HStack(alignment: .bottom) {
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
              
              VStack(alignment: .leading) {
                if readCount() != "0" {
                  Text(readCount())
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                }
    //
                if (RoomDB.messages.count - 1) == index {
                  Text(datetokor(chatdate: RoomDB.messages[index].at!))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                } else {
                  if RoomDB.messages[index + 1].type != "chat" || RoomDB.messages[index + 1].body?.userid != RoomDB.messages[index].body?.userid || datetokor(chatdate: RoomDB.messages[index + 1].at!) != datetokor(chatdate: RoomDB.messages[index].at!) {
                    Text(datetokor(chatdate: RoomDB.messages[index].at!))
                      .font(.system(size: 10, weight: .regular))
                      .foregroundColor(.gray)
                  }
                }
                
              } //v
              
            }
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
            HStack(alignment: .bottom) {
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
              
              
              VStack(alignment: .leading) {
                if readCount() != "0" {
                  Text(readCount())
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                }
    //
                if (RoomDB.messages.count - 1) == index {
                  Text(datetokor(chatdate: RoomDB.messages[index].at!))
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray)
                } else {
                  if RoomDB.messages[index + 1].type != "chat" || RoomDB.messages[index + 1].body?.userid != RoomDB.messages[index].body?.userid || datetokor(chatdate: RoomDB.messages[index + 1].at!) != datetokor(chatdate: RoomDB.messages[index].at!) {
                    Text(datetokor(chatdate: RoomDB.messages[index].at!))
                      .font(.system(size: 10, weight: .regular))
                      .foregroundColor(.gray)
                  }
                }
                
              } //v
            }
          }
        }
        .padding(.leading, 10)
        .padding(.trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment:.leading)
      }
    } else if type == .left {

      HStack(alignment: .bottom, spacing: 0) {
        Image("ImageDefaultProfile")
          .resizable()
          .scaledToFit()
          .frame(width: 32, height: 32)
          .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
          .cornerRadius(28)
          .shadow(color: Color.black.opacity(0.5), radius: 1)
          .padding(.trailing, 5)
          .opacity(0)
        
        HStack(alignment: .bottom) {
          Text(RoomDB.messages[index].body!.message!)
            .font(.system(size: 14, weight: .regular))
            .padding(10)
            .foregroundColor(Color.black)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
          
          VStack(alignment: .leading) {
            if readCount() != "0" {
              Text(readCount())
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
            }
//
            if (RoomDB.messages.count - 1) == index {
              Text(datetokor(chatdate: RoomDB.messages[index].at!))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.gray)
            } else {
              if RoomDB.messages[index + 1].type != "chat" || RoomDB.messages[index + 1].body?.userid != RoomDB.messages[index].body?.userid || datetokor(chatdate: RoomDB.messages[index + 1].at!) != datetokor(chatdate: RoomDB.messages[index].at!) {
                Text(datetokor(chatdate: RoomDB.messages[index].at!))
                  .font(.system(size: 10, weight: .regular))
                  .foregroundColor(.gray)
              }
            }
            
          } //v
        }
      }

      .padding(.leading, 10)
      .padding(.trailing, 60)
      .frame(width: UIScreen.main.bounds.width, alignment:.leading)
    

    } else if type == .right {
      HStack(alignment: .bottom) {
        VStack(alignment: .trailing) {
//          if let rc = readCount(true), rc != "0" {
//            Text(rc)
          if readCount(true) != "0" {
            Text(readCount(true))
              .font(.system(size: 12, weight: .regular))
              .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
          }
//
          if (RoomDB.messages.count - 1) == index {
            Text(datetokor(chatdate: RoomDB.messages[index].at!))
              .font(.system(size: 10, weight: .regular))
              .foregroundColor(.gray)
          } else {
            if RoomDB.messages[index + 1].type != "chat" || RoomDB.messages[index + 1].body?.userid != RoomDB.messages[index].body?.userid || datetokor(chatdate: RoomDB.messages[index + 1].at!) != datetokor(chatdate: RoomDB.messages[index].at!) {
              Text(datetokor(chatdate: RoomDB.messages[index].at!))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.gray)
            }
          }
          
        } //v

        Text(RoomDB.messages[index].body!.message!)
          .font(.system(size: 14, weight: .regular))
          .padding(10)
          .foregroundColor(Color.white)
          .background(Color(.sRGB, red: 87/255, green: 126/255, blue: 255/255, opacity: 1))
          .clipShape(RoundedRectangle(cornerRadius: 10))
            
          
      }
      .padding(.trailing , 15)
      .padding(.leading , 60)
      .frame(width: UIScreen.main.bounds.width, alignment:.trailing)

    } else if type == .orderFixed {
      HStack{
        VStack(alignment: .leading){
          Text("방장이 메뉴를 확정했어요!")
            .font(.system(size: 14, weight: .bold))
          Text("이제 메뉴를 바꿀 수 없습니다.")
            .font(.system(size: 14, weight: .bold))
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
      .shadow(color: Color.black.opacity(0.15), radius: 4)
      .padding(10)
    } else if type == .orderChecked {
      if RoomDB.superUser?.userId != UserData().data!.id {
        VStack(spacing: 0){
          HStack{
            VStack(alignment: .leading){
              Text("\(privacy.name!)님의")
                .font(.system(size: 14, weight: .bold))
              Text("보낼 금액을 확인해보세요.")
                .font(.system(size: 14, weight: .bold))
              Spacer()
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
              .font(.system(size: 12, weight: .regular))
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
        .shadow(color: Color.black.opacity(0.15), radius: 4)
        .padding(10)
      } else {
        VStack(spacing: 0){
          HStack(alignment: .top) {
            VStack(alignment: .leading){
              Text("모두에게 1/n 금액을 보냈습니다.")
                .font(.system(size: 14, weight: .bold))
              Text("입금을 확인하고 주문을 완료해주세요.")
                .font(.system(size: 14, weight: .bold))

            }
            Spacer()
            Image("ImageChatSysBell")
              .resizable()
              .scaledToFit()
              .frame(width: 26, height: 26)
          }
          .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 9/10)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 4)
        .padding(10)
      }
    } else if type == .voteKickCreated {    // 강퇴 투표 시작
      
      VStack(spacing: 0){
        HStack{
          VStack(alignment: .leading){
            Text("\(RoomDB.messages[index].body!.data!.targetUser!.name!)님에 대한")
              .font(.system(size: 14, weight: .bold))
            Text("강퇴 투표가 시작되었습니다.")
              .font(.system(size: 14, weight: .bold))
            Spacer()
          }
          Spacer()
          Image("ImageVoteMark")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 135, height: 73)
            .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
        }
        .padding()
        .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
        Button{
          self.model.voteindex = index
          self.model.voteview = true
        } label: {
          Text("투표하기")
            .font(.system(size: 12, weight: .regular))
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
      .shadow(color: Color.black.opacity(0.15), radius: 4)
      .padding(10)
      
    } else if type == .voteKickFinished {   // 강퇴 투표 끝
      
      HStack{
        VStack(alignment: .leading){
          Text("\(RoomDB.messages[index].body!.data!.targetUser!.name!)님에 대한")
            .font(.system(size: 14, weight: .bold))
          if RoomDB.messages[index].body!.data!.result == true  {
            Text("강퇴 투표가 가결되었습니다")
              .font(.system(size: 14, weight: .bold))
          } else {
            Text("강퇴 투표가 부결되었습니다")
              .font(.system(size: 14, weight: .bold))
          }
          
          Spacer()
        }
        .padding()
        Spacer()
        Image("ImageVoteMark")
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 135, height: 73)
          .padding()
          .foregroundColor((RoomDB.messages[index].body!.data!.result == true) ? Color.red : Color.gray)
      }
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.15), radius: 4)
      .padding(10)
      
    } else if type == .voteResetCreated {   // 리셋 투표 시작
      VStack(spacing: 0){
        HStack{
          VStack(alignment: .leading){
            Text("채팅방에 대한")
              .font(.system(size: 14, weight: .bold))
            Text("리셋 투표가 시작되었습니다.")
              .font(.system(size: 14, weight: .bold))
            Spacer()
          }
          Spacer()
          Image("ImageVoteMark")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 135, height: 73)
            .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
        }
        .padding()
        .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
        Button{
          self.model.voteindex = index
          self.model.voteview = true
        } label: {
          Text("투표하기")
            .font(.system(size: 12, weight: .regular))
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
      .shadow(color: Color.black.opacity(0.15), radius: 4)
      .padding(10)
      
    } else if type == .voteResetFinished {
      
      HStack{
        VStack(alignment: .leading){
          Text("채팅방에 대한 리셋 투표가")
            .font(.system(size: 14, weight: .bold))
          if RoomDB.messages[index].body!.data!.result == true  {
            Text("가결되었습니다")
              .font(.system(size: 14, weight: .bold))
          } else {
            Text("부결되었습니다")
              .font(.system(size: 14, weight: .bold))
          }
          
          Spacer()
        }
        .padding()
        Spacer()
        Image("ImageVoteMark")
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 135, height: 73)
          .padding()
          .foregroundColor((RoomDB.messages[index].body!.data!.result == true) ? Color.red : Color.gray)
      }
      .frame(width: UIScreen.main.bounds.width * 9/10)
      .background(.white)
      .cornerRadius(5)
      .shadow(color: Color.black.opacity(0.15), radius: 4)
      .padding(10)
      
    }
  }
}

//struct Message_Previews: PreviewProvider {
//    static var previews: some View {
//        Message()
//    }
//}
