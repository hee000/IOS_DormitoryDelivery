//
//  ErrorAlertView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/08/08.
//

import SwiftUI

struct ErrorAlertView: View {
  @AppStorage("restError") var restError: Bool = UserDefaults.standard.bool(forKey: "restError")
  @AppStorage("restErrorMessage") var restErrorMessage: String = (UserDefaults.standard.string(forKey: "restErrorMessage") ?? "")
  
  var body: some View {
    if restError {
      AlertOneButton(isActivity: $restError) {
        Text("\(restErrorMessage)")
          .font(.system(size: 16, weight: .regular))
        }
        .onDisappear{
          UserDefaults.standard.set("", forKey: "restErrorMessage")
        }
    } else {
      EmptyView()
    }
  }
}

