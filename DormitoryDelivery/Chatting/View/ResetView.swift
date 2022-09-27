//
//  ResetView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/05/09.
//

import SwiftUI
import Alamofire

struct ResetView: View {
  @Environment(\.presentationMode) var presentationMode

  var roomid: String
  
    var body: some View {
      NavigationView{
        
        VStack(alignment: .leading) {
          VStack(alignment: .leading) {
            Text("주문 그만하자는 제안,")
              .font(.system(size: 16, weight: .bold))
            Text("채팅원들에게 보내시겠어요?")
              .font(.system(size: 16, weight: .bold))
          }
          .padding([.leading, .trailing])
          .padding(.bottom)

          
          VStack(alignment: .leading) {
            Text("주문 그만하기란?")
              .font(.system(size: 12, weight: .bold))
              .padding([.top, .leading, .trailing])
            
            VStack(alignment: .leading, spacing: 8){
              Text("1. 방장과의 연락이 되지 않는 상황에서 주문을 그만두고 싶을 때")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 11, weight: .regular))
              Text("2. 방장이 주문 금액을 지불할 능력이 없거나 상실한 경우")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 11, weight: .regular))
              Text("3. 기타의 이유로 주문을 그만두고 싶을 때")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 11, weight: .regular))
              
            }
            .padding()
            .padding(.leading)
          }
          .frame(maxWidth: .infinity)
          .background(Color.black.opacity(0.1))
          .cornerRadius(5)
          .padding([.leading, .trailing])
          .padding(.bottom)

          Spacer()
          
          Button {
//            postVoteReset(rid: self.roomid)
//            print("dddsad")
            restApiQueue.async {

              let url = urlvotereset(rid: self.roomid)
              
              AF.request(url, method: .post, headers: TokenUtils().getAuthorizationHeader()).responseJSON { response in

                appVaildCheck(res: response)
                
                if response.response?.statusCode == 201 {
                  DispatchQueue.main.async {
                    
                    presentationMode.wrappedValue.dismiss()
                  }

                }
              }
            }
          } label: {
              Text("그만하기")
              .foregroundColor(.black)
              .font(.system(size: 16, weight: .bold))
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
          .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
          
          
        }//v
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
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
      } //navi
    
    }
}

//struct ResetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResetView()
//    }
//}
