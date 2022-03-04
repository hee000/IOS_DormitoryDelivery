//
//  EmailCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/21.
//

import Foundation

struct university: Codable, Hashable, Identifiable {
  var id: Int;
  var korName: String;
  var engName: String;
  var emailDomain: String;
}


class universityList: ObservableObject{
  @Published var data: [university] = []
}


struct emailsend: Codable {
  var universityId: Int;
  var email: String;
  var oauthAccessToken: String;
}

struct emailverify: Codable {
  var authCode: String;
  var oauthAccessToken: String;
}


struct authsession: Codable {
  var type: String;
  var accessToken: String;
  var deviceToken: String;
}

struct tokenvalue: Codable{
  var accessToken: String;
  var refreshToken: String;
}
