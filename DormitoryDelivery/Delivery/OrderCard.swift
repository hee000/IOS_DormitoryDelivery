//
//  OrderCard.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/01/26.
//

import SwiftUI

struct OrderCard: View {
  @Binding var model: tetemenussss
  
    var body: some View {
      VStack{
        HStack{
          Text("메뉴")
        }
        Divider()
        HStack{
          Text("가격")
        }
        Divider()
        HStack{
          Text("수령")
        }
        Divider()
        HStack{
          Text("상세설명")
          TextField("세부 정보를 입력해주세요", text: $model.name)
        }
      }
    }
}
