//
//  UIViewController+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit

extension UIViewController {
    /// Left Bar Button Custom 하기
    func setupCustomBackButton() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        backButton.frame = .init(x: 0, y: 0, width: 24, height: 24)
        
        let barButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func customBackButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
}
