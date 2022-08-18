//
//  ChatView.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import SwiftUI
import RealmSwift
import Combine


struct ChatView: View {
  @EnvironmentObject var chatdata: ChatData
  @EnvironmentObject var chatnavi: ChatNavi
  @State var navi = false
  @State var isReceiver = true
  

    var body: some View {
      GeometryReader { geo in
        if chatdata.chatlist.count == 0 {
          VStack(alignment: .center) {
            Spacer()
            Text("참여하신 배달방이 없어요.")
              .font(.system(size: 28, weight: .bold))
              .padding()
            Text("홈화면에서 먹고싶은 메뉴의")
              .font(.system(size: 15, weight: .regular))
            Text("배달방을 개설하거나 참여해보세요!")
              .font(.system(size: 15, weight: .regular))
            Spacer()
            Spacer()
          }.frame(width: geo.size.width)
        } else {
          ScrollView {
            if chatnavi.index != nil && chatdata.chatlist.count > chatnavi.index! {

              NavigationLink(destination: ChattingView(roomid: chatdata.chatlist[chatnavi.index!].rid!)
                .onAppear(perform: {
                  chatnavi.Active = false
                  chatnavi.NaviJoinActive = false
                  chatnavi.NaviCreateActive = false
//                  chatnavi.index = nil
                })
                  .onDisappear(perform: {
                    chatnavi.index = nil
                  })
                             , isActive: $navi) {}
            }
            
            VStack(alignment: .leading, spacing: 1) {
              HStack(spacing: 0){
                Text("진행 중인 주문")
                  .font(.system(size: 18, weight: .bold))
                Text("* ")
                  .font(.system(size: 18, weight: .bold))
                  .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
              }
              .padding()
              
              
              ForEach(chatdata.chatlistsortindex, id: \.self) { index in
//              ForEach(chatdata.chatlist.indices, id: \.self) { index in
//                let rid = chatdata.chatlist[index].rid!
                if chatdata.chatlist[index].state?.orderDone != true {
                  NavigationLink(destination: ChattingView(roomid: chatdata.chatlist[index].rid!)) {
                    let filter = chatdata.chatlist[index].messages.filter("type == 'chat'").last
  //                  let confirmation = chatdata.chatlist[index].messages.filter("type == 'chat' AND idx > \(chatdata.chatlist[index].confirmation)").count
                    let confirmation = chatdata.chatlist[index].messages.filter("type == 'chat' AND idx > \(chatdata.chatlist[index].read.filter{$0.userId == UserData().data!.id}.first?.messageId ?? 0)").count

                    ChatCard(title: chatdata.chatlist[index].title,
                             lastmessage: filter?.body?.message,
                             lastat: filter?.at,
                             users: chatdata.chatlist[index].member.count,
                             confirmation: confirmation)
                      .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                      .transition(.slide)
                  }
                  .onAppear {
                    getChatLog(rid: chatdata.chatlist[index].rid!, idx: 999)
                    getRoomUpdate(rid: chatdata.chatlist[index].rid!)
                    getParticipantsUpdate(rid: chatdata.chatlist[index].rid!)
                  }

                  if isReceiver{
                    EmptyView()
                     .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                       getChatLog(rid: chatdata.chatlist[index].rid!, idx: 999)
                       getRoomUpdate(rid: chatdata.chatlist[index].rid!)
                       getParticipantsUpdate(rid: chatdata.chatlist[index].rid!)
                     }
                  } //isreceiver
                }// 진행중인방
              } // for

                
              Text("주문 완료")
                .font(.system(size: 18, weight: .bold))
                .padding()
              
              ForEach(chatdata.chatlistsortindex, id: \.self) { index in
//              ForEach(chatdata.chatlist.indices, id: \.self) { index in
//                let rid = chatdata.chatlist[index].rid!
                if chatdata.chatlist[index].state?.orderDone == true {
                  NavigationLink(destination: ChattingView(roomid: chatdata.chatlist[index].rid!)) {
                    let filter = chatdata.chatlist[index].messages.filter("type == 'chat'").last
  //                  let confirmation = chatdata.chatlist[index].messages.filter("type == 'chat' AND idx > \(chatdata.chatlist[index].confirmation)").count
                    let confirmation = chatdata.chatlist[index].messages.filter("type == 'chat' AND idx > \(chatdata.chatlist[index].read.filter{$0.userId == UserData().data!.id}.first?.messageId ?? 0)").count

                    ChatCard(title: chatdata.chatlist[index].title,
                             lastmessage: filter?.body?.message,
                             lastat: filter?.at,
                             users: chatdata.chatlist[index].member.count,
                             confirmation: confirmation)
                      .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                      .transition(.slide)
                  }
                  .onAppear {
                    getChatLog(rid: chatdata.chatlist[index].rid!, idx: 999)
                    getRoomUpdate(rid: chatdata.chatlist[index].rid!)
                    getParticipantsUpdate(rid: chatdata.chatlist[index].rid!)
                  }

                  if isReceiver{
                    EmptyView()
                     .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
                       getChatLog(rid: chatdata.chatlist[index].rid!, idx: 999)
                       getRoomUpdate(rid: chatdata.chatlist[index].rid!)
                       getParticipantsUpdate(rid: chatdata.chatlist[index].rid!)
                     }
                  } //isreceiver
                }// 완료방
              } // for

            } //v
          } // scroll
        }
        
      }//geo
      .clipped()
      .onChange(of: chatnavi.NaviCreateActive) { NaviActive in
        if NaviActive {
          self.navi = true
        }
      }
      .onDisappear(perform: {
        isReceiver = false
      })
      
      
      .onAppear {
        isReceiver = true
        getRooms(uid: UserData().data!.id!)
        if chatnavi.NaviCreateActive || chatnavi.NaviJoinActive {
          self.navi = true
        }
      }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}



class PublisherHolder {
  static let shared = PublisherHolder()
  var publisher: NotificationCenter.Publisher
  var connectedPublisher: Cancellable?
  
  init() {
    self.publisher = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)

//    self.connectedPublisher = publisher.makeConnectable().connect()
  }
  
  func pcancel(){
    self.connectedPublisher?.cancel()
  }
}


struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
