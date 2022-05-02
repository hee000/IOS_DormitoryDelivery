//
//  ChatSideMenu.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/23.
//

import SwiftUI
import Alamofire
import RealmSwift

struct ChatSideMenu: View {
  @EnvironmentObject var naverLogin: NaverLogin
  @EnvironmentObject var chatdata: ChatData
  
  @StateObject var model: Chatting
  @Binding var RoomChat: ChatDB?
  var rid: String
  
    var body: some View {
      let privacy = getUserPrivacy()
      GeometryReader { geo in
        VStack(alignment: .leading) {
          VStack(alignment: .leading, spacing: 10) {
            Text("채팅방")
              .font(.system(size: 18, weight: .bold))
              .padding(.bottom)
            
            Button{
              self.model.oderlistview.toggle()
            } label: {
              HStack{
                Text("주문서")
                  .font(.system(size: 16, weight: .regular))
                Spacer()
                Image(systemName: "chevron.right")
                  .font(.system(size: 16, weight: .regular))
              }
            }
            
            Divider()
            
            if RoomChat != nil && RoomChat!.state?.orderFix == true && RoomChat!.state?.orderDone == false {
              Button{
                postVoteReset(rid: self.rid)
              } label: {
                HStack{
                  Text("투표하기")
                    .font(.system(size: 16, weight: .regular))
                  Spacer()
                  Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .regular))
                }
              }

              Divider()
              
            }
            
            Spacer()
          
            Text("참여상대")
              .font(.system(size: 18, weight: .bold))
              .padding(.bottom)
            
            if RoomChat != nil {
              VStack{
                if RoomChat?.superUser != nil {
                  HStack{
                    ZStack{
                      Image("ImageDefaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.5), radius: 1)
                      Image("ImageSuperMark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .offset(x: 10, y: 10)
                    }
                    Text(RoomChat!.superUser!.name!)
                      .font(.system(size: 16, weight: .regular))
                    Spacer()
                    
                    if RoomChat!.state?.orderFix == true && RoomChat!.state?.orderDone == false && RoomChat!.superUser!.userId != privacy.id { //강퇴투표
                      Button{
                        postVoteKick(rid: self.rid, uid: RoomChat!.superUser!.userId!)
                      } label: {
                        Text("강퇴 투표")
                          .font(.system(size: 14, weight: .regular))
                          .padding(7)
                          .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                      }
                    }
                  }
                }//if
              
                ForEach(RoomChat!.member.indices, id: \.self) { index in
                  if RoomChat!.member[index].userId != RoomChat!.superUser?.userId {
                    HStack{
                      Image("ImageDefaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.5), radius: 1)
                      Text(RoomChat!.member[index].name!)
                        .font(.system(size: 16, weight: .regular))
                      Spacer()
                      if RoomChat!.state?.orderFix == false && RoomChat!.superUser?.userId == privacy.id { // 방장강퇴
                        Button{
                          getKick(rid: self.rid, uid: RoomChat!.member[index].userId!)
                        } label: {
                          Text("강퇴하기")
                            .font(.system(size: 14, weight: .regular))
                            .padding(7)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                        }
                      }
                      
                      if RoomChat!.state?.orderFix == true && RoomChat!.state?.orderDone == false && RoomChat!.member[index].userId != privacy.id { //강퇴투표
                        Button{
                          postVoteKick(rid: self.rid, uid: RoomChat!.member[index].userId!)
                        } label: {
                          Text("강퇴 투표")
                            .font(.system(size: 14, weight: .regular))
                            .padding(7)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                        }
                      }
                    }//h
                  } //if
                } //for
              }//v
            }//if
          } // 나가기 위 vstack
          .padding()
          .padding(.trailing)
          .disabled(RoomChat?.Kicked ?? false ? true : false)
          
          Button(action: {
            // order-done == ture || order-fix == false
//              getRoomLeave(rid: self.rid, token: mytoken, model: model)
            if RoomChat?.Kicked != true {
              let url = urlroomleave(rid: self.rid)
              let tk = TokenUtils()
              let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())
              req.response { response in
                print(response)
                do {
                  if response.response?.statusCode == 200 {
                    self.model.leave = true
                  }
                } catch {
                  print(error)
                }
              }
            } else {
              self.model.leave = true
            }
          }) {
            HStack {
              Image(systemName: "arrow.right.square")
                .font(.system(size: 14, weight: .regular))
              Text("채팅나가기")
                .font(.system(size: 14, weight: .regular))
            }
          }
          .padding([.leading])
          .frame(width: geo.size.width, height: 46, alignment: .leading)
          .background(Color(.sRGB, red: 223/255, green: 223/255, blue: 229/255, opacity: 1))

        } // vstack
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
      } // geo

    }
}
