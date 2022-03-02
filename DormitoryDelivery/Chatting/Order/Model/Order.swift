import Foundation
import SwiftUI


struct orderdata: Codable, Identifiable, Equatable {
  var id: String;
  var name: String;
  var quantity: Int;
  var description: String;
  var price: Int?;
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

