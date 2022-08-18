//
//  VoteView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/04.
//

import SwiftUI
import Alamofire

enum VoteType {
  case KickCan
  case KickSubmitted
  case KickFinished
  case KickSuggester
  case ResetCan
  case ResetSubmitted
  case ResetFinished
  case ResetSuggester
}

class VoteModel: ObservableObject {
  @Published var type: VoteType?
  @Published var active = false
  
  var rid: String
  var vid: String
  
  init(rid: String, vid: String) {
    self.rid = rid
    self.vid = vid
    
    onAppearinit()
  }
  
  func onAppearinit() {
    restApiQueue.async {
      print(self.vid)
      let url = urlvotevaild(rid: self.rid, vid: self.vid)
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
      req.responseJSON { response in
        print(response)
        guard let resdata = response.data,
              let voteState = try? JSONDecoder().decode(VoteStateData.self, from: resdata) else { return }
        
        print(voteState)
        DispatchQueue.main.async {

          if voteState.type == 0 { //kick
            if voteState.finished {
              self.type = .KickFinished
            } else {
              if !voteState.submitted {
                if voteState.canVote {
                  self.type = .KickCan
                } else {
                  self.type = .KickSuggester
                }
              } else {
                self.type = .KickSubmitted
              }
            }
          } else { //reset
            if voteState.finished {
              self.type = .ResetFinished
            } else {
              if !voteState.submitted {
                if voteState.canVote {
                  self.type = .ResetCan
                } else {
                  self.type = .ResetSuggester
                }
              } else {
                self.type = .ResetSubmitted
              }
            }
          }
        } //main
      } //req
    } //dispatch
  } //onAppearinit
  
  func voteSubmit(_ agree: Bool) {
    restApiQueue.async {
      let url = urlvotesubmit(rid: self.rid, vid: self.vid, isagree: agree)
      let req = AF.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
      req.responseJSON { response in
        print(response.response?.statusCode)
        if response.response?.statusCode == 201 {
          DispatchQueue.main.async {
            self.active = true
          }
        }
      }
    }
  } //voteSubmit
  
  
}

struct VoteStateData: Codable {
  var id: String;
  var type: Int;
  var finished: Bool;
  var result: Bool;
  var metadataId: String?;
  var canVote: Bool;
  var submitted: Bool;
}

struct VoteView: View {
  @StateObject var chatmodel: Chatting
  @Binding var RoomDB: ChatDB?
  @StateObject var votemodel: VoteModel
  
  init(chatmodel: Chatting, RoomDB: Binding<ChatDB?>) {
    self._chatmodel = StateObject(wrappedValue: chatmodel)
    self._RoomDB = RoomDB
    
    let rid: String = RoomDB.wrappedValue?.rid ?? ""
    let vid: String = RoomDB.wrappedValue?.messages[chatmodel.voteindex].body?.data?.voteId ?? ""
    
    self._votemodel = StateObject(wrappedValue: VoteModel(rid: rid, vid: vid))
  }
  
    var body: some View {
      VStack{
        if votemodel.type == .KickCan {
          VoteAlert(votemodel: votemodel, backButton: $chatmodel.voteview) {
            VStack{
              Image("ImageDefaultProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
                .background(Color(.sRGB, red: 180/255, green: 200/255, blue: 255/255, opacity: 1))
                .cornerRadius(28)
              Text(self.RoomDB!.messages[self.chatmodel.voteindex].body!.data!.targetUser!.name!)
                .font(.system(size: 14, weight: .regular))
            }
            .padding(.bottom)
            
            Text("배달에 원활한 진행을 위하여,")
              .font(.system(size: 14, weight: .regular))
            Text("방장이 \(self.RoomDB!.messages[self.chatmodel.voteindex].body!.data!.targetUser!.name!)님을 내보내고자 합니다.")
              .font(.system(size: 14, weight: .regular))
            Text("(동의하시겠습니까?)")
              .foregroundColor(.gray)
              .font(.system(size: 10, weight: .regular))
          }
        } else if votemodel.type == .KickSubmitted {// kickcan if
          AlertOneButton(isActivity: $chatmodel.voteview) {
            Text("이미 투표를 했습니다.")
          }
        } else if votemodel.type == .KickSuggester {
          AlertOneButton(isActivity: $chatmodel.voteview) {
            Text("투표 제안자 입니다.")
          }
        } else if votemodel.type == .KickFinished { // KickSubmitted if
          AlertOneButton(isActivity: $chatmodel.voteview) {
            Text("투표가 종료되었습니다.")
          }
        } else if votemodel.type == .ResetCan {
          VoteAlert(votemodel: votemodel, backButton: $chatmodel.voteview) {
            Text("배달에 원활한 진행을 위하여,")
              .font(.system(size: 14, weight: .regular))
            Text("방을을 리셋하고자 합니다.")
              .font(.system(size: 14, weight: .regular))
            Text("(동의하시겠습니까?)")
              .foregroundColor(.gray)
              .font(.system(size: 10, weight: .regular))
          }
          
        } // if
      } //v
        .onChange(of: votemodel.active) { _ in
          chatmodel.voteview = false
        }
    }
}
