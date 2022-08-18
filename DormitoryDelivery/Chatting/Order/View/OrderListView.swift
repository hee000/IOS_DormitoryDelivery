import SwiftUI
import Network

struct OrderListView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var naverLogin: NaverLogin
  @StateObject var orderlistmodel: OrderList = OrderList()
  var RoomChat: ChatDB?
  var rid: String

  var body: some View {
    NavigationView{
      GeometryReader { geo in
        ZStack(alignment: .topTrailing) {
          ScrollView {
            VStack(alignment: .center) {
              if orderlistmodel.data != nil{
                ForEach(orderlistmodel.data!.indices, id:\.self) { index in
                  OrderListCard(model: orderlistmodel.data![index], roomid: rid, RoomChat: RoomChat)
                }
                .frame(width: geo.size.width * (9/10))
                .background(.white)
                .cornerRadius(5)
                .clipped()
                .shadow(color: Color.black.opacity(0.15), radius: 4)
              }
              
            } //vstack
            .frame(width: geo.size.width)
            .onAppear {
              orderlistmodel.data = nil
              getMenuList(rid: self.rid, model: orderlistmodel)
            }
            .padding(.top)
          }//scroll
          
          if RoomChat?.state?.orderFix == true {
            Image("ImageOrderStamp")
              .resizable()
              .scaledToFit()
              .frame(width: geo.size.width / 2, height: geo.size.width / 2)
              .offset(x: 20)
              .rotationEffect(.degrees(15))
              .opacity(0.3)
          }
          
        } //Z
      } //geo
      .clipped()
      
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden(true)
      .navigationBarTitle("주문 리스트")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            presentationMode.wrappedValue.dismiss()
          } label: {
            Image(systemName: "xmark")
              .foregroundColor(.black)
          }
        }
      }

    }//navi
  }
}
