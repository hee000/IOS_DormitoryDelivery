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
              .font(.title3)
              .bold()
              .padding(.bottom)
            
            Button{
              self.model.oderlistview.toggle()
            } label: {
              HStack{
                Text("주문서")
                  .font(.callout)
                Spacer()
                Image(systemName: "chevron.right")
              }
            }
            
            Divider()
            
            Button{
              if let mytoken = naverLogin.loginInstance?.accessToken {
                postVoteReset(rid: self.rid, token: mytoken)
              }
            } label: {
              HStack{
                Text("투표하기")
                  .font(.callout)
                Spacer()
                Image(systemName: "chevron.right")
              }
            }

            Divider()

            Spacer()
          
            Text("참여상대")
              .font(.title3)
              .bold()
              .padding(.bottom)
            
            if RoomChat != nil {
              VStack{
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
                  if RoomChat?.superUser != nil {
                    Text(RoomChat!.superUser!.name!)
                  }
                  Spacer()
                  
                  if RoomChat!.state?.orderFix == true && RoomChat!.state?.orderDone == false && RoomChat!.superUser!.userId != privacy._id { //강퇴투표
                    Button{
                      if let mytoken = naverLogin.loginInstance?.accessToken {
                        postVoteKick(rid: self.rid, uid: RoomChat!.superUser!.userId!, token: mytoken)
                      }
                    } label: {
                      Text("강퇴 투표")
                        .font(.footnote)
                        .padding(7)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                    }
                  }
                }
              
                ForEach(RoomChat!.member.indices, id: \.self) { index in
                  if RoomChat!.member[index].userId != RoomChat!.superUser!.userId {
                    HStack{
                      Image("ImageDefaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.5), radius: 1)
                      Text(RoomChat!.member[index].name!)
                      Spacer()
                      if RoomChat!.state?.orderFix == false && RoomChat!.superUser!.userId == privacy._id { // 방장강퇴
                        Button{
                          if let mytoken = naverLogin.loginInstance?.accessToken {
                            getKick(rid: self.rid, uid: RoomChat!.member[index].userId!, token: mytoken)
                          }
                        } label: {
                          Text("강퇴하기")
                            .font(.footnote)
                            .padding(7)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                        }
                      }
                      
                      if RoomChat!.state?.orderFix == true && RoomChat!.state?.orderDone == false && RoomChat!.member[index].userId != privacy._id { //강퇴투표
                        Button{
                          if let mytoken = naverLogin.loginInstance?.accessToken {
                            postVoteKick(rid: self.rid, uid: RoomChat!.member[index].userId!, token: mytoken)
                          }
                        } label: {
                          Text("강퇴 투표")
                            .font(.footnote)
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
          
          Button(action: {
            // order-done == ture || order-fix == false
            if let mytoken = naverLogin.loginInstance?.accessToken {
//              getRoomLeave(rid: self.rid, token: mytoken, model: model)
              let url = urlroomleave(rid: self.rid)
              let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": mytoken])
              req.response { response in
                do {
                  if response.response?.statusCode == 200 {
                    self.model.leave.toggle()
                  }
                } catch {
                  print(error)
                }
              }
            }
          }) {
            HStack {
              Image(systemName: "arrow.right.square")
              Text("채팅나가기")
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
