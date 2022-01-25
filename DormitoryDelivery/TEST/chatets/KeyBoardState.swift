import UIKit
import Combine
import SwiftUI

class KeyboardManager: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    @Published var isVisible = false
    
//    var keyboardCancellable: Cancellable?
//
//    init() {
//        keyboardCancellable = NotificationCenter.default
//            .publisher(for: UIWindow.keyboardWillChangeFrameNotification)
//            .sink { [weak self] notification in
//                guard let self = self else { return }
//
//                guard let userInfo = notification.userInfo else { return }
//                guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//
//                self.isVisible = keyboardFrame.minY < UIScreen.main.bounds.height
//                self.keyboardHeight = self.isVisible ? keyboardFrame.height : 0
//            }
//    }
    
}




#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


struct DynamicHeightTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var height: CGFloat
    @Binding var rows: CGFloat
    var rowsum: CGFloat = 0
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = false
        
        textView.text = text
        textView.backgroundColor = UIColor.clear
        textView.font = .systemFont(ofSize: 16)

      context.coordinator.textView = textView
      textView.delegate = context.coordinator
      textView.layoutManager.delegate = context.coordinator

      return textView
  }
    
  func updateUIView(_ uiView: UITextView, context: Context) {
      uiView.text = text
  }

  func makeCoordinator() -> Coordinator {
      return Coordinator(dynamicHeightTextField: self)
  }
  
  class Coordinator: NSObject, UITextViewDelegate, NSLayoutManagerDelegate {

      var dynamicHeightTextField: DynamicHeightTextField
    weak var textView: UITextView?
      

      init(dynamicHeightTextField: DynamicHeightTextField) {
          self.dynamicHeightTextField = dynamicHeightTextField
      }

      func textViewDidChange(_ textView: UITextView) {
          self.dynamicHeightTextField.text = textView.text
      }

      func textView(
          _ textView: UITextView,
          shouldChangeTextIn range: NSRange,
          replacementText text: String) -> Bool {
//          if (text == "\n") {
//              textView.resignFirstResponder()
//              return false
//          }
          return true
      }

    
    func layoutManager(
        _ layoutManager: NSLayoutManager,
        didCompleteLayoutFor textContainer: NSTextContainer?,
        atEnd layoutFinishedFlag: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.textView else {
                return
            }
            let size = view.sizeThatFits(view.bounds.size)
            if self?.dynamicHeightTextField.height != size.height {
              if self!.dynamicHeightTextField.height < size.height {
                if self!.dynamicHeightTextField.rows < 2 {
                  self?.dynamicHeightTextField.rows += 1
                }
                self!.dynamicHeightTextField.rowsum += 1
              } else {
                if self!.dynamicHeightTextField.rows > 1 && self!.dynamicHeightTextField.rowsum <= 2 {
                  self?.dynamicHeightTextField.rows -= 1
                }
                self!.dynamicHeightTextField.rowsum -= 1
              }
              self?.dynamicHeightTextField.height = size.height
            }
        }

    }
  }
}
