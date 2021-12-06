//
//  SectionCategoryData.swift
//  DormitoryDelivery
//
//  Created by cch on 2021/12/06.
//

import Foundation
import Combine


struct homeviewdata: Codable {
  var category: String
  var section: String
}

struct test {
  let categorys = ["한식", "중식", "일식", "양식", "돼지고기", "치킨", "피자", "떡", "페스트푸드"]
  let sections = ["전체", "창조", "나래", "호연", "비봉"]
}




func MyJsonDecoder<T: Decodable>(_ data: Data) -> T {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse Data as \(T.self):\n\(error)")
    }
}
