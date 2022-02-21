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

    var body: some View {
      GeometryReader { _ in
        if noti.systemNoti {
          ScrollView{
            VStack{
              ForEach(chatdata.chatlist) { chat in
                ForEach(chat.messages.filter("type == 'system' AND idx > \(chat.systemConfirmation)")) { system in
                  Button{
                    self.chatnavi.rid = chat.rid
                    self.chatnavi.forceActive()
                    
                    self.isActive = true
                    presentationMode.wrappedValue.dismiss()
                  } label:{
                    VStack(alignment: .leading) {
                      Text(chat.title!)
                        .bold()
                      Text(system.body?.action ?? "없다네")
                        .bold()
                      Text("\(String(Int((datecheck.nowDate.timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(system.at!)!/1000))) / 60))) 분전")
                        .font(.footnote)
                        .padding(.top, 5)
                        .foregroundColor(.gray)
                    }
                    .foregroundColor(Color.black)
                    .padding()
                    .frame(height: UIScreen.main.bounds.height / 7)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.sRGB, red: 228/255, green: 234/255, blue: 255/255, opacity: 1))
                  }
                }// 둘 for
              } // 첫 for
            }//v
          }//scroll
        } else {
          Text("신규 알람이 없습니다.")
            .font(.title3)
            .bold()
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
