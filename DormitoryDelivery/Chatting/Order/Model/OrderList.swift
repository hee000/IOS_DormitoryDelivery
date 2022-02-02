//
//  OrderList.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/01.
//

import Foundation


struct orderlistdata: Codable {
  var user: userdata;
  var menus: Array<orderlistmenudata>;
}

struct userdata: Codable, Hashable{
  var userId: String;
  var name: String;
}

struct orderlistmenudata: Codable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int;
}

class OrderList: ObservableObject {
  @Published var data: [orderlistdata]? = nil
}
