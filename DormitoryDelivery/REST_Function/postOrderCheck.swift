//
//  postOrderCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import Foundation
import Alamofire

func postOrderCheck(rid: String, token: String, model: OrderCheck, account: UserAccount) {
  let imgdata = model.image.jpegData(compressionQuality: 0.2)!
    
  let imgurl = urlorderimageupload(rid: rid)
  let checkurl = urlordercheck(rid: rid)
    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(imgdata, withName: "purchase_screenshot", fileName: "purchase_screenshot.jpeg", mimeType: "image/jpeg")

    }, to: imgurl, headers: ["Authorization": token])
    .responseJSON { response in

      let createkey = OrdercheckTip(delivery_tip: Int(model.tip)!, accountBank: account.bank!, accountNum: account.account!, accountHolderName: account.name!)
      var request = URLRequest(url: checkurl)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.timeoutInterval = 10
      request.allHTTPHeaderFields = (["Authorization": token])
      
      do {
          try request.httpBody = JSONEncoder().encode(createkey)
      } catch {
          print("http Body Error")
      }
      
      AF.request(request).responseJSON { (response) in
        print(response)
        model.imageupload.toggle()
      }
    }
}



