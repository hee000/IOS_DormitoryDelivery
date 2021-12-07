//
//  SectionCategoryData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine
import SocketIO

struct homeViewOption: Codable, SocketData {
  var category: [String]
  var section: [String]
  
  func socketRepresentation() -> SocketData {
      return ["category": category, "section": section]
  }
}


let sections = ["전체", "창조", "나래", "호연", "비봉"]
let categorys = ["한식", "중식", "일식", "양식", "돼지고기", "치킨", "피자", "떡", "페스트푸드"]
let sectionNameEng = ["Narae", "Hoyoen", "Changzo", "Bibong"]
let sectionNameToKor = ["Narae":"나래", "Hoyoen":"호연", "Changzo":"창조", "Bibong":"비봉"] as Dictionary

func MyJsonDecoder<T: Decodable>(_ data: Data) -> T {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse Data as \(T.self):\n\(error)")
    }
}
