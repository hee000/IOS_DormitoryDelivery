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
let categoryNameToEng = ["한식":"korean", "중식":"chinese", "일식":"japanese", "양식":"western", "돼지고기":"porkcutlet", "치킨":"chicken", "피자":"pizza", "떡":"ddeock", "패스트푸드":"fastfood"] as Dictionary
let sectionNameEng = ["Narae", "Hoyoen", "Changzo", "Bibong"]
let categoryNameEng = ["korean", "chinese" , "japanese", "western", "porkcutlet", "chicken", "pizza" ,"ddeock", "fastfood" ]
let sectionNameToKor = ["Narae":"나래", "Hoyoen":"호연", "Changzo":"창조", "Bibong":"비봉"] as Dictionary

func MyJsonDecoder<T: Decodable>(_ data: Data) -> T {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse Data as \(T.self):\n\(error)")
    }
}
