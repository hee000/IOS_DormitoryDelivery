//
//  ServerUrl.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation

let serverurl = "https://gachihasil.link/"
let createroomposturl = "https://gachihasil.link/room"
let emailsendurl = "https://gachihasil.link/auth/email/send"
let authcodesendurl = "https://gachihasil.link/auth/email/verify"

func roomdetail(matchId: String) -> URL {
  let url = URL(string: "https://gachihasil.link/match/" + matchId + "/info")!
  return url
}

func roomjoin(matchId: String) -> URL {
  let url = URL(string: "https://gachihasil.link/match/" + matchId + "/join")!
  return url
}

func urlroomleave(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/leave")!
  return url
}

func urladdmenu(uid: String, rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/user/" + uid + "/room/" + rid + "/menus")!
  return url
}

func urldeletemenu(uid: String, rid: String, mid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/user/" + uid + "/room/" + rid + "/menus/" + mid)!
  return url
}

func urlmenulist(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/menus")!
  return url
}

func urlreport(mid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/report/v1/message/\(mid)")!
  return url
}

func urlready(uid: String, rid: String, state: Bool) -> URL {
  let value = state ? "false" : "true"
  let url = URL(string: "https://gachihasil.link/user/" + uid + "/room/" + rid + "/ready?state=" + value)!
  return url
}

func urloderfix(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/order-fix")!
  return url
}

func urloderdone(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/order-done")!
  return url
}

func urlorderimageupload(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/purchase-screenshot")!
  return url
}

func urlordercheck(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/order-check")!
  return url
}

func urlimgdownload(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/purchase-screenshot")!
  return url
}

func urlimgdownloadurl(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/purchase-screenshot-urls")!
  return url
}

func urlreceipt(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/receipt")!
  return url
}

func urlparticipants(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/participants")!
  return url
}

func urlmenus(uid: String, rid: String, mid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/user/" + uid + "/room/" + rid + "/menus/" + mid)!
  return url
}

func urlrooms(uid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/user/" + uid + "/rooms")!
  return url
}

func urlchatlog(rid: String, idx: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/chat/" + idx)!
  return url
}

func urlchatread(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/\(rid)/chat/read")!
  return url
}

func urlkick(rid: String, uid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/kick?uid=" + uid)!
  return url
}

func urlvotekick(rid: String, uid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/vote-kick?targetId=" + uid)!
  return url
}

func urlvotereset(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/" + rid + "/vote-reset")!
  return url
}

func urlvotevaild(rid: String, vid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/\(rid)/vote/\(vid)")!
  return url
}

func urlvotesubmit(rid: String, vid: String, isagree: Bool) -> URL {
  let url = URL(string: "https://gachihasil.link/room/\(rid)/vote/\(vid)?isAgree=\(isagree)")!
  return url
}

func urluniversity() -> URL {
  let url = URL(string: "https://gachihasil.link/university")!
  return url
}

func urluniversityinfo(id: Int) -> URL {
  let url = URL(string: "https://gachihasil.link/university/\(id)")!
  return url
}

func urluniversitydormitory(id: String) -> URL {
  let url = URL(string: "https://gachihasil.link/university/" + id + "/dormitory")!
  return url
}


func urlemailsend() -> URL {
  let url = URL(string: "https://gachihasil.link/signup/v1/session")!
  return url
}

func urlemailverify(sid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/signup/v1/session/\(sid)/verifyCode")!
  return url
}

func urlemailuserinfo(sid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/signup/v1/session/\(sid)/userInfo")!
  return url
}

func urlsession() -> URL {
  let url = URL(string: "https://gachihasil.link/auth/token")!
  return url
}


func urlwithdrawal(uid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/user/\(uid)")!
  return url
}


func urlroomupdate(rid: String) -> URL {
  let url = URL(string: "https://gachihasil.link/room/\(rid)/state")!
  return url
}


func urlalramonoff() -> URL {
  let url = URL(string: "https://gachihasil.link/notification")!
  return url
}
