//
//  getVoteVaild.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/04.
//

import Foundation
import Alamofire


func getVoteVaild(rid: String, vid: String) {
  let url = urlvotevaild(rid: rid, vid: vid)
  let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
  req.responseJSON { response in
    appVaildCheck(res: response)
    guard let resdata = response.data,
          let voteState = try? JSONDecoder().decode(VoteStateData.self, from: resdata) else { return }
    print("guard", voteState)
  }
}

//struct VoteStateData: Codable {
//  var id: String;
//  var type: Int;
//  var finished: Bool;
//  var result: Bool;
//  var metadataId: String;
//  var canVote: Bool;
//  var submitted: Bool;
//}
