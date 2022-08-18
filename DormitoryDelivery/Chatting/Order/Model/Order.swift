import Foundation
import SwiftUI


struct orderdata: Codable, Identifiable, Equatable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: String;
}

struct addmenu: Codable {
  var name: String            // 이름
  var quantity: Int            // 개수
  var description: String            // 내용
  var price: Int             // 가격
}

struct restOnlyOrderData: Codable, Identifiable, Equatable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int;
}

class Order: ObservableObject {
  @Published var data: [orderdata] = []
  @Published var forcompare: [orderdata] = []
  @Published var isMenu: [String] = []
  
  @Published var postalertstate = false
  @Published var exitalertstate = false
  @Published var exit = false
  @Published var addanimation = false
  @Published var onanimation = false
  @Published var height: CGFloat? = .zero
}

