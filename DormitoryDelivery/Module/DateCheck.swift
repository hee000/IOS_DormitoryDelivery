//
//  DateCheck.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation

class DateCheck : NSObject, ObservableObject{
  var timeTrigger = true
  var realTime = Timer()
  
  @Published var nowDate: Date = Date()
  
  func startAction(){
    if timeTrigger {
      checkTimeTrigger()
    }
  }
  
  func checkTimeTrigger() {
    realTime = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    timeTrigger = false
  }

  @objc func updateCounter() {
    nowDate = Date()
//    print("주기 업데이트 됨")
  }
}
