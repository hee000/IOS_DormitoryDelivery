//
//  WithdrawalView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/15.
//

import SwiftUI
import Alamofire

struct WithdrawalView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var naverLogin: NaverLogin

  @State var withdrawalState = false
  
    var body: some View {
      VStack(alignment: .leading) {
        VStack(alignment: .leading) {
          Text("회원탈퇴 시")
            .font(.system(size: 16, weight: .bold))
          Text("유의사항을 확인해주세요")
            .font(.system(size: 16, weight: .bold))
        }
        .padding([.leading, .trailing])
        .padding(.bottom)

        
        VStack(alignment: .leading) {
          Text("참여 중인 모든 배달에서 나가게 되고, 배달방에서 주고 받은 거래 내역과 파일 등 모든 정보가 즉시 삭제되며 복구할 수 없습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 11, weight: .regular))
            .padding()
          Text("탈퇴 후 동일 아이디로 신규 가입이 어려울 수 있습니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 11, weight: .regular))
            .padding([.leading, .trailing])
          Text("탈퇴 시 고객님의 정보는 개인정보 처리방침에 따라 일부 관리됩니다.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 11, weight: .regular))
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.1))
        .cornerRadius(5)
        .padding([.leading, .trailing])
        .padding(.bottom)

        HStack{
          Button{
            self.withdrawalState.toggle()
          } label: {
            HStack{
              Image(self.withdrawalState ? "ImageChecked" : "ImageCheck")
                .resizable()
                .scaledToFit()
                .frame(width: 17, height: 17)
              Text("유의사항을 모두 확인했으며, 이에 동의합니다.")
                .foregroundColor(.black)
            }
          }
        }
        .padding([.leading, .trailing])

        
        Spacer()
        
        Button {
          print("탈퇴시작")
          guard let uid = UserData().data else { return }
          let req = AF.request(urlwithdrawal(uid: uid.id!), method: .delete,
                               encoding: JSONEncoding.default, headers: TokenUtils().getAuthorizationHeader())
          req.responseJSON { response in
            print(response)
            if response.response?.statusCode == 200 {
              naverLogin.logout()
            }
          }
//          naverLogin.loginInstance?.requestDeleteToken()
          
          
        } label: {
            Text("탈퇴하기")
            .foregroundColor(.black)
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
        .background(self.withdrawalState ? Color(.sRGB, red: 237/255, green: 110/255, blue: 125/255, opacity: 1) : Color(.sRGB, red: 195/255, green: 195/255, blue: 195/255, opacity: 1))
        
      }//v
      
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("회원탈퇴")
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
    }
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}
