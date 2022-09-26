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
  @ObservedObject var blockedUser = BlockedUserData()
//  @(BlockedUser.self) var blockedUser

  @StateObject var model: Chatting
  @Binding var RoomChat: ChatDB?
  var rid: String
  
  func userBlock(uid: String) {
    if blockedUser.data.contains { BlockedUser in
      BlockedUser.userId == uid
    } {
      guard let del = realm.object(ofType: BlockedUser.self, forPrimaryKey: uid) else { return }
      let realm = try! Realm()
      try? realm.write {
        realm.delete(del)
      }
    } else if getUserPrivacy().id != uid {
      print("차단추가")
      let newblockedUser = BlockedUser()
      newblockedUser.userId = uid
      addBlockedUser(newblockedUser)
    }
  }
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
            
            if let state = RoomChat?.state, state.orderFix == true && state.orderDone == false && state.orderCancel == false {
              Button{
                self.model.resetview.toggle()
              } label: {
                HStack{
                  Text("주문 그만하기")
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
            
            if let state = RoomChat?.state {
              VStack{
                if let superUser = RoomChat?.superUser {
                  HStack{
                    ZStack{
                      Image("ImageDefaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.5), radius: 1)
                        .overlay(blockedUser.data.contains { BlockedUser in
                          BlockedUser.userId == superUser.userId
                        } ? Image(systemName: "xmark").foregroundColor(Color.red) : nil)
                      Image("ImageSuperMark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                        .offset(x: 10, y: 10)
                      
//                      if blockedUser.data.contains { BlockedUser in
//                        BlockedUser.userId == RoomChat!.superUser!.userId
//                      } {
//                        Image(systemName: "xmark")
//                          .resizable()
//                          .scaledToFit()
//                          .frame(width: 32, height: 32)
//                          .foregroundColor(Color.red)
//                      }
                    }
//                    .foregroundColor(blockedUser.data.contains { BlockedUser in
//                      BlockedUser.userId == RoomChat!.superUser!.userId
//                    } ? Color.red : Color.gray)
                    
                    Text(superUser.name!)
                      .font(.system(size: 16, weight: .regular))
                    Spacer()
                    
                    if let uid = superUser.userId, privacy.id != uid {
                      Menu{
                        Button{
//                          let uid = superUser.userId!
                          
                          userBlock(uid: uid)
//                          if blockedUser.data.contains { BlockedUser in
//                            BlockedUser.userId == uid
//                          } {
//                            guard let del = realm.object(ofType: BlockedUser.self, forPrimaryKey: uid) else { return }
//                            let realm = try! Realm()
//                            try? realm.write {
//                              realm.delete(del)
//                            }
//                          } else if privacy.id != uid {
//                            print("차단추가")
//                            let newblockedUser = BlockedUser()
//                            newblockedUser.userId = uid
//                            addBlockedUser(newblockedUser)
//
//                          }
                        } label: {
                          Label("차단", systemImage: "xmark.octagon")
                        }
                        
                        Button{
//                          guard let messageId = superUser.userId
//                          else { return }

                          model.messageId = uid
                          model.isReport.toggle()
                        } label: {
                          Label("신고", systemImage: "exclamationmark.triangle")
                        }
                        
                        
                        
                      } label: {
                        Image(systemName: "ellipsis")
                          .rotationEffect(Angle(degrees: 90))
                      }
                    } // 차단 if
                    
                  }
                }//if
              
                ForEach(RoomChat!.member.indices, id: \.self) { index in
                  if let member = RoomChat!.member[index], member.userId != RoomChat!.superUser?.userId {
                    HStack{
                      Image("ImageDefaultProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                        .cornerRadius(28)
                        .shadow(color: Color.black.opacity(0.5), radius: 1)
                        .overlay(blockedUser.data.contains { BlockedUser in
                          BlockedUser.userId == member.userId
                        } ? Image(systemName: "xmark").foregroundColor(Color.red): nil)

                      
                      Text(member.name!)
                        .font(.system(size: 16, weight: .regular))
                      
                      if state.orderFix == false {
                        Text(member.isReady ? "준비완료" : "메뉴고르는중")
                          .font(.system(size: 8, weight: .regular))
                          .padding(.leading)
                          .foregroundColor(member.isReady ? Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1) : Color.gray)
                      }
                      
                      Spacer()
                      
                      
                      if state.orderFix == false && RoomChat!.superUser?.userId == privacy.id { // 방장강퇴
                        Button{
                          getKick(rid: self.rid, uid: member.userId!)
                        } label: {
                          Text("강퇴하기")
                            .font(.system(size: 14, weight: .regular))
                            .padding(7)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                        }
                      }
                      
                      if state.orderFix == true && state.orderDone == false && RoomChat!.superUser?.userId == privacy.id && RoomChat!.member.count > 2 && state.orderCancel == false { //강퇴투표
                        Button{
                          postVoteKick(rid: self.rid, uid: member.userId!)
                        } label: {
                          Text("강퇴 투표")
                            .font(.system(size: 14, weight: .regular))
                            .padding(7)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1.5))
                        }
                      }
                      
                      if let uid = member.userId, privacy.id != uid {
                        Menu{
                          Button{
//                            let uid = RoomChat!.member[index].userId!
                            userBlock(uid: uid)
//                            if blockedUser.data.contains { BlockedUser in
//                              BlockedUser.userId == uid
//                            } {
//                              guard let del = realm.object(ofType: BlockedUser.self, forPrimaryKey: uid) else { return }
//                              let realm = try! Realm()
//                              try? realm.write {
//                                realm.delete(del)
//                              }
//                            } else if privacy.id != uid {
//                              print("차단추가")
//                              let newblockedUser = BlockedUser()
//                              newblockedUser.userId = uid
//                              addBlockedUser(newblockedUser)
//
//                            }
                          } label: {
                            Label("차단", systemImage: "xmark.octagon")
                          }
                          
                          Button{
//                            guard let messageId = RoomChat?.member[index].userId
//                            else { return }

                            model.messageId = uid
                            model.isReport.toggle()
                          } label: {
                            Label("신고", systemImage: "exclamationmark.triangle")
                          }
                          
                          
                          
                        } label: {
                          Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                        }
                      } // 차단 if
                      
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
              restApiQueue.async {
                let url = urlroomleave(rid: self.rid)
                let tk = TokenUtils()
                let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: tk.getAuthorizationHeader())
                req.responseJSON { response in
                  appVaildCheck(res: response)
                  print(response)
                  do {
                    if response.response?.statusCode == 200 {
                      self.model.leave = true
                    }
                  } catch {
                    print(error)
                  }
                }
              } //queue
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
      .onAppear {
        print("asdasd")
        getParticipantsUpdate(rid: self.rid)
      }

    }
}
