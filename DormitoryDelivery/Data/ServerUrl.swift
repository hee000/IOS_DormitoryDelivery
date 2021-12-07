//
//  ServerUrl.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation


let serverurl = "http://192.168.0.22:3000/"
//let serverurl = "http://192.168.10.104:3000/"

let createroomposturl = "http://192.168.0.22:3000/room"
//let createroomposturl = "http://192.168.10.104:3000/room"

let emailsendurl = "http://192.168.0.22:3000/auth/email/send"
let authcodesendurl = "http://192.168.0.22:3000/auth/email/verify"


func roomdetail(matchId: String) -> URL {
  let url = URL(string: "http://192.168.0.22:3000/match/" + matchId + "/info")!
  return url
}


func roomjoin(matchId: String) -> URL {
  let url = URL(string: "http://192.168.0.22:3000/match/" + matchId + "/join")!
  return url
}
