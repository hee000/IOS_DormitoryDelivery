import Foundation
import UIKit
import NaverThirdPartyLogin
import Alamofire
import SwiftUI

struct NaverTest: View {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
    var body: some View {
//      Button(action: {
//        let naverConnection = NaverThirdPartyLoginConnection.getSharedInstance()
//
//        naverConnection?.delegate = self
//
//        naverConnection?.requestThirdPartyLogin()
//
//      }) {
//        Text("Button")
//      }
      
      LoginViewControllerBridge()
      
    }
}

struct NaverTest_Previews: PreviewProvider {
    static var previews: some View {
      NaverTest()
    }
}

class functest: UIViewController, NaverThirdPartyLoginConnectionDelegate, ObservableObject {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
//  loginInstance?.delegate = self
  @Published var login = "1111"
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
      getInfo()
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
      loginInstance?.accessToken
  }
  
  // 로그아웃
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out")
  }
  
  // 모든 error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
      print("error = \(error.localizedDescription)")
  }
  func loginee() {
    print("onClickButton");
//    loginInstance?.delegate = self
//       print(test.login)
//       test.login = "99999999999993"
//       print(test.login)
          loginInstance?.requestThirdPartyLogin()
    self.login = "444444"
  }
  
  func getInfo() {
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    print("========")
    print(isValidAccessToken)
    print("========")
    if !isValidAccessToken {
      return
    }
    
    guard let refreshToken = loginInstance?.refreshToken else { return }
    guard let tokenType = loginInstance?.tokenType else { return }
    guard let accessToken = loginInstance?.accessToken else { return }
      
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    
    print("================================")
//    print(tokenType)
    print(refreshToken)
//    print(accessToken)
    print("================================")
    
    let authorization = "\(tokenType) \(accessToken)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    
    req.responseJSON { response in
      guard let result = response.value as? [String: Any] else { return }
      guard let object = result["response"] as? [String: Any] else { return }
//      guard let name = object["name"] as? String else { return }
//      guard let email = object["email"] as? String else { return }
//      guard let id = object["id"] as? String else {return}
      
      print(object)
      
//      self.nameLabel.text = "\(name)"
//      self.emailLabel.text = "\(email)"
//      self.id.text = "\(id)"
    }
  }
  
}
  

class TESTcustom_viewcontroller: UIViewController, NaverThirdPartyLoginConnectionDelegate {
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  var test = StateLogin()
//  @EnvironmentObject var test: StateLogin

  
  func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
      print("Success login")
      getInfo()
  }
  
  // referesh token
  func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
      loginInstance?.accessToken
  }
  
  // 로그아웃
  func oauth20ConnectionDidFinishDeleteToken() {
      print("log out")
  }
  
  // 모든 error
  func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
      print("error = \(error.localizedDescription)")
  }
  
  
  lazy var label: UIButton = {
    
          // Define the size of the label.
          let width: CGFloat = 300
          let height: CGFloat = 100
          
          // Define coordinates to be placed.
          // (center of screen)
          let posX: CGFloat = self.view.bounds.width/2 - width/2
          let posY: CGFloat = self.view.bounds.height/2 - height/2
          
          // Label Create.
          let label: UIButton = UIButton(frame: CGRect(x: posX, y: posY, width: width, height: height))
          
          // Define background color.
//          label.backgroundColor = .orange
          
          
          label.layer.masksToBounds = true
          
          // Radius of rounded corner.
          label.layer.cornerRadius = 20.0
    label.setImage(#imageLiteral(resourceName: "kakao_login_medium_wide"), for: .normal)

  
    label.addTarget(self, action: #selector(onClickMyButton(_:)), for: .touchUpInside)
    
          return label
      }()
  
  
   @objc internal func onClickMyButton(_ sender: Any) {
     if let button = sender as? UIButton {
       print("onClickButton");
//       print(test.login)
//       test.login = "99999999999993"
//       print(test.login)
             loginInstance?.requestThirdPartyLogin()
//             loginInstance?.requestDeleteToken()
//       print("button.currentTitle: \(button.currentTitle!)")
//       print("button.tag: \(button.tag)")
     }
   }

    override func loadView() {
      loginInstance?.delegate = self
      
//      loginInstance?.requestThirdPartyLogin()
//      loginInstance?.requestDeleteToken()
      
        let view = UIView()
        self.view = view
      view.frame = CGRect(x: 0, y: 0, width: 414.0, height: 710.0)
      view.addSubview(label)
//      labe.
//        view.addSubview()
    }
  
  func getInfo() {
    guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    print("========")
    print(isValidAccessToken)
    print("========")
    if !isValidAccessToken {
      return
    }
    
    guard let refreshToken = loginInstance?.refreshToken else { return }
    guard let tokenType = loginInstance?.tokenType else { return }
    guard let accessToken = loginInstance?.accessToken else { return }
      
    let urlStr = "https://openapi.naver.com/v1/nid/me"
    let url = URL(string: urlStr)!
    
    print("================================")
//    print(tokenType)
    print(refreshToken)
//    print(accessToken)
    print("================================")
    
    let authorization = "\(tokenType) \(accessToken)"
    
    let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    
    req.responseJSON { response in
      guard let result = response.value as? [String: Any] else { return }
      guard let object = result["response"] as? [String: Any] else { return }
//      guard let name = object["name"] as? String else { return }
//      guard let email = object["email"] as? String else { return }
//      guard let id = object["id"] as? String else {return}
      
      print(object)
      
//      self.nameLabel.text = "\(name)"
//      self.emailLabel.text = "\(email)"
//      self.id.text = "\(id)"
    }
  }
  
}



class LoginViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var id: UILabel!
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func loadView() {
      print("TEST")
        loginInstance?.delegate = self
    }
    
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    @IBAction func login(_ sender: Any) {
        
        loginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logout(_ sender: Any) {
        loginInstance?.requestDeleteToken()
    }
    
    // RESTful API, id가져오기
    func getInfo() {
      guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
      
      if !isValidAccessToken {
        return
      }
      
      guard let tokenType = loginInstance?.tokenType else { return }
      guard let accessToken = loginInstance?.accessToken else { return }
        
      let urlStr = "https://openapi.naver.com/v1/nid/me"
      let url = URL(string: urlStr)!
      
      let authorization = "\(tokenType) \(accessToken)"
      
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
      
      req.responseJSON { response in
        guard let result = response.value as? [String: Any] else { return }
        guard let object = result["response"] as? [String: Any] else { return }
        guard let name = object["name"] as? String else { return }
        guard let email = object["email"] as? String else { return }
        guard let id = object["id"] as? String else {return}
        
        print(email)
        
        self.nameLabel.text = "\(name)"
        self.emailLabel.text = "\(email)"
        self.id.text = "\(id)"
      }
    }
    
}




struct LoginViewControllerBridge: UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> TESTcustom_viewcontroller {
    let uiViewController = TESTcustom_viewcontroller()
//    uiViewController.map.delegate = context.coordinator
    return uiViewController
  }

  func updateUIViewController(_ uiViewController: TESTcustom_viewcontroller, context: Context) {
//    uiViewController.map.clear()
//    markers.forEach { $0.map = uiViewController.map }
  }
}


