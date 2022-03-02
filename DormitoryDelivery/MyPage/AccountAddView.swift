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
        VStack(alignment: .leading) {
          Text("은행명")
            .bold()
          TextField("은행명을 입력해주세요.", text: $bank)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            .padding(.bottom)

          
          Text("계좌번호")
            .bold()
          TextField("'-' 없이 계좌번호를 입력해주세요", text: $account)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            .padding(.bottom)

          
          Text("예금주")
            .bold()
          TextField("이름을 작성해주세요.", text: $name)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
        }
        .padding()
        
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
              .foregroundColor(.white)
              .bold()
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
