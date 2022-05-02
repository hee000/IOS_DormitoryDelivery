//
//  TESFILE.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/02.
//

import SwiftUI

struct TESFILE: View {
  var body: some View {
    NavigationView{
      TabView{
        Text("1")
          .tabItem {
            Text("1")
          }
        
        NavigationLink(destination: Text("222")) {
          Text("2")
        }
          .tabItem {
            Text("2")
          }
      }
    }
  }
}

struct TESFILE_Previews: PreviewProvider {
    static var previews: some View {
        TESFILE()
    }
}
