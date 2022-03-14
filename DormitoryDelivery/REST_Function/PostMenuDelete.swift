//
//  PostMenuDelete.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/24.
//

import Foundation
import Alamofire
import SwiftUI

func postMenuDelete(model:Order, index: Int, oderdata: orderdata, rid: String, anima: Binding<Bool>){

  let url = urldeletemenu(uid: UserData().data!.id!, rid: rid, mid: oderdata.id)
  
  AF.request(url, method: .delete, headers: TokenUtils().getAuthorizationHeader()).responseJSON { response in
    print(response)
    if response.response?.statusCode == 200 {
      for (index, comparedata) in model.forcompare.enumerated() {
        if comparedata.id == oderdata.id {
          model.forcompare.remove(at: index)
//          anima.wrappedValue.toggle()
          model.data.remove(at: index)
          break
        }
      }
    }
  }
  
}
