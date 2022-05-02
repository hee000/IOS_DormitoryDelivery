//
//  NotificationView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/15.
//

import SwiftUI

struct NotificationView: View {
  @EnvironmentObject var chatdata: ChatData
  @EnvironmentObject var datecheck: DateCheck
  @EnvironmentObject var chatnavi: ChatNavi
  @EnvironmentObject var noti: Noti
  @Environment(\.presentationMode) var presentationMode
  @Binding var tabSelect: Int
  @State var isActive = false

  @ViewBuilder
  func notiButtton(rid: String, title: String, action: String, at: String) -> some View {
    Button{
      self.chatnavi.rid = rid
      self.chatnavi.forceActive()

      self.isActive = true
      presentationMode.wrappedValue.dismiss()
    } label:{
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .font(.system(size: 18, weight: .bold))
          .padding(.bottom, 5)
        Text(action)
          .font(.system(size: 16, weight: .bold))
        Text("\(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(at)!/1000))) / 60))) 분전")
          .font(.system(size: 10, weight: .regular))
          .padding(.top)
          .foregroundColor(.gray)
      }
      .foregroundColor(Color.black)
      .padding()
      .frame(height: UIScreen.main.bounds.height / 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
    }
  }
    var body: some View {
      GeometryReader { _ in
        if noti.systemNoti {
          ScrollView{
            VStack(spacing: 2){
              ForEach(chatdata.chatlist) { chat in
                ForEach(chat.messages.filter("type == 'system' AND idx > \(chat.confirmation)")) { system in
                  if system.body?.action == "order-fixed" {
                    notiButtton(rid: chat.rid!, title: chat.title!, action: "메뉴가 확정 되었습니다.", at: system.at!)
                  } else if system.body?.action == "order-checked" {
                    notiButtton(rid: chat.rid!, title: chat.title!, action: "배달이 시작되었습니다. 채팅 창을 확인해주세요.", at: system.at!)
                  } else if system.body?.action == "order-finished" {
                    notiButtton(rid: chat.rid!, title: chat.title!, action: "1/n 정산이 완료되었어요. 배달금액을 체크해주세요.", at: system.at!)
                  }
                }// 둘 for
              } // 첫 for
            }//v
          }//scroll
        } else {
          Text("신규 알람이 없습니다.")
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
      }//geo
      .onDisappear(perform: {
        if self.isActive {
          self.tabSelect = 2
        }
      })
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("알림")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          HStack{
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: "chevron.left")
                .foregroundColor(.black)
            }
          }
        }
      }
    }
}
