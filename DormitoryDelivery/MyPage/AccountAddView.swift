//
//  AccountAddView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/14.
//

import SwiftUI
import RealmSwift

struct AccountAddView: View {
  @Environment(\.presentationMode) var presentationMode

  
  @State var bank = ""
  @State var account = ""
  @State var name = ""
  
    var body: some View {
      ZStack(alignment: .top) {
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading) {
            Text("방장이 배달 확정을 했을 때 구성원들에게 입금 받을 계좌번호입니다.")
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray)
              .frame(maxWidth: .infinity, alignment: .leading)
//              .padding(.bottom)
            
            Text("계좌 등록 시 유효 계좌 확인 절차가 없으니 정확하게 기입해주세요.")
              .font(.system(size: 14, weight: .regular))
              .foregroundColor(.gray)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
              .padding([.top, .bottom])
            
            Text("은행명")
              .font(.system(size: 16, weight: .bold))
            TextField("은행명을 입력해주세요.", text: $bank)
              .font(.system(size: 14, weight: .bold))
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
              .padding(.bottom)

            
            Text("계좌번호")
              .font(.system(size: 16, weight: .bold))
            TextField("'-' 없이 계좌번호를 입력해주세요", text: $account)
              .font(.system(size: 14, weight: .bold))
              .keyboardType(.numberPad)
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
              .padding(.bottom)

            
            Text("예금주")
              .font(.system(size: 16, weight: .bold))
            TextField("이름을 작성해주세요.", text: $name)
              .font(.system(size: 14, weight: .bold))
              .padding()
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
          }
          .padding()
          
          Spacer()
            .frame(height: 300)
        } // scroll
        .onTapGesture {
            hideKeyboard()
        }
        
        VStack{
          Spacer()
          Button {
            let realm = try! Realm()
            let add = UserAccount()
            add.bank = self.bank
            add.name = self.name
            add.account = self.account
            try? realm.write({
              let userdb = realm.objects(UserPrivacy.self).first
              if userdb?.mainAccount == nil {
                userdb?.mainAccount = add
              }
              userdb?.accounts.append(add)
            })
            presentationMode.wrappedValue.dismiss()
          } label: {
              Text("등록완료")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
          }
          .frame(height: 47, alignment: .center)
          .background(Color(.sRGB, red: 113/255, green: 46/255, blue: 255/255, opacity: 1))
          .cornerRadius(5)
          .padding([.bottom,  .leading, .trailing])
          .padding([.leading, .trailing])
        }
        .ignoresSafeArea(.keyboard)
      }//z
      
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("계좌등록")
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

struct AccountAddView_Previews: PreviewProvider {
    static var previews: some View {
        AccountAddView()
    }
}
