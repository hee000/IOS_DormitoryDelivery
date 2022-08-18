//
//  TOSView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/15.
//

import SwiftUI
import WebKit

struct TOSView: View {
  @Environment(\.presentationMode) var presentationMode
  
    var body: some View {
        Webview(url: URL(string: "https://gachihasil.link/policy/terms.html")!)
        .edgesIgnoringSafeArea(.bottom)
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("이용약관")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "chevron.left")
                  .foregroundColor(.black)
              }
            }
          }
        }
        .background(Color(.sRGB, red: 243/255, green: 242/255, blue: 238/255, opacity: 1))
    }
}


struct Webview: UIViewRepresentable {
    let url: URL
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = WKWebView()
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        return webview
    }
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
}
