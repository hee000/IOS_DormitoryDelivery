//
//  ImageSlider.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/12.
//

import SwiftUI

struct ImageSlider: View {
    
    // 1
  let images: [UIImage]
    
    var body: some View {
        // 2
      if !images.isEmpty{
        TabView {
            ForEach(images, id: \.self) { item in
                 //3
                Image(uiImage: item)
                    .resizable()
                    .scaledToFit()
            }
        }
        .tabViewStyle(PageTabViewStyle())
      }
    }
}
