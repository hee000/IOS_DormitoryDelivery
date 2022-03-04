//
//  postOrderCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import Foundation
import Alamofire

func postOrderCheck(rid: String, model: OrderCheck, account: UserAccount) {
  let imgdata = model.image.jpegData(compressionQuality: 0.2)!
    
  let imgurl = urlorderimageupload(rid: rid)
  let checkurl = urlordercheck(rid: rid)
    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(imgdata, withName: "purchase_screenshot", fileName: "purchase_screenshot.jpeg", mimeType: "image/jpeg")

    }, to: imgurl, headers: TokenUtils().getAuthorizationHeader())
    .responseJSON { response in

      let createkey = OrdercheckTip(delivery_tip: Int(model.tip)!, accountBank: account.bank!, accountNum: account.account!, accountHolderName: account.name!)

      guard let param = try? createkey.asDictionary() else { return }
      
      AF.request(checkurl, method: .post,
      parameters: param,
                 encoding: JSONEncoding.default,
                 headers: TokenUtils().getAuthorizationHeader()
      ).responseJSON { (response) in
        print(response)
        model.imageupload.toggle()
      }
    }
}



