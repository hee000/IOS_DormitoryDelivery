//
//  ReportView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/09/19.
//

import SwiftUI
import Alamofire

enum reportReason: String, CaseIterable {
  case obscene = "음란한 내용"
  case violent = "폭력적인 내용"
  case unpleasant = "불쾌한 내용"
  case etc = "기타"
}

struct ReportView: View {
  @Environment(\.presentationMode) var presentationMode

  let messageId: String
  @State var caseReason: reportReason? = nil
  @State var reason = ""
  
    var body: some View {
      NavigationView{
        ZStack{
          VStack(alignment: .leading) {
            Text("신고 사유")
              .font(.system(size: 16, weight: .bold))
              .padding(.top)
              .padding(.top)
            
            Menu {
              ForEach(reportReason.allCases, id: \.rawValue) { data in
                Button{
                  self.caseReason = data
                } label: {
                  Text(data.rawValue)
                    .font(.system(size: 14, weight: .regular))
                }
              }
            } label: {
              HStack{
                Text(self.caseReason != nil ? "\(self.caseReason!.rawValue)" : "신고 사유를 선택해주세요.")
                  .font(.system(size: 14, weight: .regular))
                  .foregroundColor(.black)
                Spacer()
                Image(systemName: "arrowtriangle.down.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 13, height: 10)
                  .foregroundColor(.purple)
              }
              .frame(maxWidth: .infinity)
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            }
            
//            if let caseR = caseReason, caseR == reportReason.etc {
            Text("(선택) 구체적인 사유를 적어주세요.")
              .font(.system(size: 16, weight: .regular))
            
            TextEditor(text: $reason)
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray.opacity(0.7), lineWidth: 1))
              .frame(height: UIScreen.main.bounds.size.height/3.5)
//            }
            
            Spacer()
          }//v
          .padding([.leading, .trailing])
          VStack{
            Spacer()
            
            Button {
              guard let data = caseReason?.rawValue,
                    let param = try? ["reasonId" : "\(data), \(reason)"].asDictionary()
              else { return }
              let url = urlreport(mid: messageId)
              
//              let param = ["reasonId" : "\(data), \(reason)"] as
              AF.request(url, method: .put,
                         parameters: param,
                         encoding: JSONEncoding.default,
                         headers: TokenUtils().getAuthorizationHeader()
              ).responseString { response in
                if response.response?.statusCode == 200 {
                  presentationMode.wrappedValue.dismiss()
                }
              }
              
            } label: {
                Text("접수하기")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
            }
            .frame(height: 50, alignment: .center)
            .background(caseReason != nil ? Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1) : Color.gray)
            .cornerRadius(5)
            .padding([.bottom,  .leading, .trailing])
            .padding([.leading, .trailing])
            .disabled(caseReason == nil ? true : false)
          }
          .ignoresSafeArea(.keyboard)
        }//z
        .onTapGesture {
            hideKeyboard()
        }
        
        .navigationBarTitle("신고하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack{
              Button {
                presentationMode.wrappedValue.dismiss()
              } label: {
                Image(systemName: "xmark")
                  .foregroundColor(.black)
              }
            }
          }
        }
        
      }//navi
    }
}
