//
//  InrollPlaceViewNotification.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/15.
//

import UIKit

extension InrollPlaceViewController {
    // MARK: 키보드 나타남에 따라 view 동적으로 보여주기
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 32
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height - tabBarHeight))
                }
            )
        }
    }
    // MARK: 키보드 없어질 때 view refresh
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.transform = .identity
    }
}
