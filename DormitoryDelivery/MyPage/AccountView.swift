//
//  AccountView.swift
//  DormitoryDelivery
//
//  Created by cch on 2022/02/14.
//

import SwiftUI
import RealmSwift

struct AccountView: View {
  @Environment(\.presentationMode) var presentationMode

//  @ObservedResults(UserPrivacy.self) var userPrivacys
  @StateObject var userPrivacy = UserData()
  @State var showingSheet = false
  @State var showingSheetMain = false
  @State var test: UserAccount? = nil
  
    var body: some View {
      
      GeometryReader { _ in
        VStack{
          if !userPrivacy.chatlist.accounts.isEmpty {
            ScrollView{
              VStack(alignment: .leading, spacing: 16){
                if let acc = userPrivacy.chatlist.mainAccount {
                  VStack(alignment: .leading) {
                    HStack{
                      Text(acc.bank!)
                        .bold()
                      Text("대표계좌")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(.sRGB, red: 112/255, green: 52/255, blue: 255/255, opacity: 1))
                    }
                    
                    Text(acc.account!)
                      .bold()
                    
                    HStack{
                      Text("예금주: ")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .padding(.top, 1)
                      Text(acc.name!)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .padding(.top, 1)
                      Spacer()
                      
                      Button{
                        test = acc
                        showingSheetMain.toggle()
                      } label: {
                        Image(systemName: "ellipsis")
                          .rotationEffect(Angle(degrees: 90))
                          .foregroundColor(Color.black)
                      }
                      
                      .confirmationDialog("", isPresented: $showingSheetMain, titleVisibility: .hidden, presenting: test) { data in

                        Button("삭제하기", role: .destructive) {
                          let realm = try! Realm()
                          try? realm.write({
                            let userdb = realm.objects(UserPrivacy.self).first!
                            userdb.mainAccount = nil
                            userdb.accounts.remove(at: userdb.accounts.index(of: data)!)
                          })
                        }

                        Button("취소", role: .cancel) { }
                      }
                    }
                  }
                  .padding()
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                  .cornerRadius(5)
                  .clipped()
                  .shadow(color: Color.black.opacity(0.15), radius: 4)
                  .padding([.leading, .trailing])
                }
                ForEach(userPrivacy.chatlist.accounts.indices, id:\.self) { index in
                  if userPrivacy.chatlist.accounts[index].account != userPrivacy.chatlist.mainAccount?.account {
                    VStack(alignment: .leading) {
                      Text(userPrivacy.chatlist.accounts[index].bank!)
                        .bold()
                      
                      Text(userPrivacy.chatlist.accounts[index].account!)
                        .bold()
                      
                      HStack{
                        Text("예금주: ")
                          .font(.footnote)
                          .foregroundColor(Color.gray)
                          .padding(.top, 1)
                        Text(userPrivacy.chatlist.accounts[index].name!)
                          .font(.footnote)
                          .foregroundColor(Color.gray)
                          .padding(.top, 1)
                        
                        Spacer()
                        
                        Button{
                          test = userPrivacy.chatlist.accounts[index]
                          showingSheet.toggle()
                        } label: {
                          Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                            .foregroundColor(Color.black)
                        }
                        
                        .confirmationDialog("", isPresented: $showingSheet, titleVisibility: .hidden, presenting: test) { data in
                          Button("대표계좌 등록하기") {
                            let realm = try! Realm()
                            try? realm.write({
                              let userdb = realm.objects(UserPrivacy.self).first!
                              userdb.mainAccount = data
                            })
                          }

                          Button("삭제하기", role: .destructive) {
                            let realm = try! Realm()
                            try? realm.write({
                              let userdb = realm.objects(UserPrivacy.self).first!
                              userdb.accounts.remove(at: userdb.accounts.index(of: data)!)
                            })
                          }

                          Button("취소", role: .cancel) { }
                        }
                      }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.sRGB, red: 245/255, green: 245/255, blue: 251/255, opacity: 1))
                    .cornerRadius(5)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.15), radius: 4)
                    .padding([.leading, .trailing])
                    
                    
                  }
                } //for
              } //v
              .padding(.top)
              .padding(.top)
            } //scroll
          } else {
            VStack{
              Image("ImageNil")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
              Text("등록된 계좌가 없습니다.")
                .font(.title3)
                .bold()
              Text("미리 등록하고 빠르게 채팅을 이어가세요.")
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        } //v
        
      }//geo
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("계좌")
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
        ToolbarItem(placement: .navigationBarTrailing) {
          HStack{
            NavigationLink(destination: AccountAddView()) {
              Image(systemName: "plus")
                .foregroundColor(Color.black)
            }
          }
        }
      }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
