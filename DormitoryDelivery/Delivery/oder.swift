//
//  oder.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/09.
//

import SwiftUI

struct Oder: View {
    var body: some View {
      VStack{
        Text("주문서 작성")
        HStack{
          Text("메뉴")
//          TextField("메뉴입력")
        }
        HStack{
          Text("가격")
//          TextField("가격입력")
        }
        HStack{
          Text("수량")
//          TextField("수량 쁠마")
        }
        HStack{
          Text("상세설명")
  //          TextField("수량 쁠마")
        }
        
        Button {
          // 플러스하기
        } label: {
          Text("대충 플러스버튼")
        }

      }
        
    }
}

struct Oder_Previews: PreviewProvider {
    static var previews: some View {
        Oder()
    }
}
