//
//  ServerUrl.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation

// 59.25.26.152:3000
// 59.25.26.152:3000


let serverurl = "http://localhost:3000/"
let createroomposturl = "http://localhost:3000/room"
let emailsendurl = "http://localhost:3000/auth/email/send"
let authcodesendurl = "http://localhost:3000/auth/email/verify"

func roomdetail(matchId: String) -> URL {
  let url = URL(string: "http://localhost:3000/match/" + matchId + "/info")!
  return url
}

func roomjoin(matchId: String) -> URL {
  let url = URL(string: "http://localhost:3000/match/" + matchId + "/join")!
  return url
}

func urlroomleave(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/leave")!
  return url
}

func urladdmenu(uid: String, rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/user/" + uid + "/room/" + rid + "/menus")!
  return url
}

func urldeletemenu(uid: String, rid: String, mid: String) -> URL {
  let url = URL(string: "http://localhost:3000/user/" + uid + "/room/" + rid + "/menus/" + mid)!
  return url
}

func urlmenulist(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/menus")!
  return url
}

func urlready(uid: String, rid: String, state: Bool) -> URL {
  let value = state ? "false" : "true"
  let url = URL(string: "http://localhost:3000/user/" + uid + "/room/" + rid + "/ready?state=" + value)!
  return url
}

func urloderfix(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/order-fix")!
  return url
}

func urloderdone(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/order-done")!
  return url
}

func urlorderimageupload(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/purchase-screenshot")!
  return url
}

func urlordercheck(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/order-check")!
  return url
}

func urlimgdownload(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/purchase-screenshot")!
  return url
}

func urlimgdownloadurl(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/purchase-screenshot-urls")!
  return url
}

func urlreceipt(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/receipt")!
  return url
}

func urlparticipants(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/participants")!
  return url
}

func urlmenus(uid: String, rid: String, mid: String) -> URL {
  let url = URL(string: "http://localhost:3000/user/" + uid + "/room/" + rid + "/menus/" + mid)!
  return url
}

func urlrooms(uid: String) -> URL {
  let url = URL(string: "http://localhost:3000/user/" + uid + "/rooms")!
  return url
}

func urlchatlog(rid: String, idx: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/chat/" + idx)!
  return url
}

func urlkick(rid: String, uid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/kick?uid=" + uid)!
  return url
}

func urlvotekick(rid: String, uid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/vote-kick?targetId=" + uid)!
  return url
}

func urlvotereset(rid: String) -> URL {
  let url = URL(string: "http://localhost:3000/room/" + rid + "/vote-reset")!
  return url
}


func urluniversity() -> URL {
  let url = URL(string: "http://localhost:3000/university")!
  return url
}

func urluniversitydormitory(id: String) -> URL {
  let url = URL(string: "http://localhost:3000/university/" + id + "/dormitory")!
  return url
}


func urlemailsend() -> URL {
  let url = URL(string: "http://localhost:3000/auth/email/send")!
  return url
}

func urlemailverify() -> URL {
  let url = URL(string: "http://localhost:3000/auth/email/verify")!
  return url
}

func urlsession() -> URL {
  let url = URL(string: "http://localhost:3000/auth/token")!
  return url
}
