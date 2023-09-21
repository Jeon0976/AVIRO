//
//  UIViewController+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit

extension UIViewController {
    func setupCustomBackButton(_ animatied: Bool = false) {
        let backButton = UIButton()
        
        backButton.setImage(
            UIImage.back,
            for: .normal
        )
        backButton.addTarget(
            self,
            action: #selector(customBackButtonTapped(_:)),
            for: .touchUpInside
        )
        backButton.frame = .init(
            x: 0,
            y: 0,
            width: 24,
            height: 24
        )
        
        backButton.tag = animatied ? 1 : 0
        
        let barButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func customBackButtonTapped(_ sender: UIButton) {
        let animated = sender.tag == 1
        
        navigationController?.popViewController(animated: animated)
    }
}
