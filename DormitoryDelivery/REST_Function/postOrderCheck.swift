//
//  postOrderCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/25.
//

import Foundation
import Alamofire

func postOrderCheck(rid: String, model: OrderCheck, account: UserAccount) {
  restApiQueue.async {

  //
//  let dasd = model.images.map{$0.toImage()}
//  for i in dasd {
//    print(i)
//  }
  let imgdatas = model.images.map{$0.jpegData(compressionQuality: 0.2)!}
//  let imgdatas = model.images.map{$0.toImage().pngData()!}
  //
  print(imgdatas)
//  print(imgdatas[0])
//  let imgdata = model.image.jpegData(compressionQuality: 0.2)!
  
  let imgurl = urlorderimageupload(rid: rid)
  let checkurl = urlordercheck(rid: rid)
    AF.upload(multipartFormData: { multipartFormData in
      
      //
      for (idx, img) in imgdatas.enumerated() {
        multipartFormData.append(img, withName: "purchase_screenshot", fileName: "purchase_screenshot\(idx).jpg", mimeType: "image/jpeg")
      }
      
      //
//      print(multipartFormData)
//      print(multipartFormData.contentLength)
//      print(multipartFormData.boundary)
//      print(multipartFormData.contentType)
//      multipartFormData.append(imgdatas[0], withName: "purchase_screenshot", fileName: "purchase_screenshot.jpeg", mimeType: "image/jpeg")

    }, to: imgurl, headers: TokenUtils().getAuthorizationHeader())
    .uploadProgress(queue: .main, closure: { progress in
        //Current upload progress of file
        print("Upload Progress: \(progress.fractionCompleted)")
    })
    .responseJSON { response in
      print("status", response.response?.statusCode)
      print("upload response: ",response)
      print("upload response.error: ",response.error)
      guard let tip = Int(model.tip) else { return }
      let createkey = OrdercheckTip(deliveryTip: tip, accountBank: account.bank!, accountNum: account.account!, accountHolderName: account.name!)
      
      guard let param = try? createkey.asDictionary() else { return }
      print(createkey)
      print(param)
      AF.request(checkurl, method: .post,
      parameters: param,
                 encoding: JSONEncoding.default,
                 headers: TokenUtils().getAuthorizationHeader()
      ).responseJSON { (response) in
        print(response)
        DispatchQueue.main.async {
          model.imageupload.toggle()
        }
      }
    }
  }
}
