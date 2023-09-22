//
//  UIViewController+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit
import SafariServices

import Toast_Swift

extension UIViewController {
    
    typealias AlertAction = (
        title: String,
        style: UIAlertAction.Style,
        handler: (() -> Void)?
    )
    
    func showAlert(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style = .alert,
        actions: [AlertAction] = [("확인", .default, nil)]
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        for action in actions {
            let actionItem = UIAlertAction(
                title: action.title,
                style: action.style
            ) { _ in
                action.handler?()
            }
            
            if action.style == .destructive {
                actionItem.setValue(UIColor.warning, forKey: "titleTextColor")
            }
            
            alertController.addAction(actionItem)
        }
        
        present(alertController, animated: true)
    }
    
    func showActionSheet(
        title: String?,
        message: String?,
        actions: [AlertAction]
    ) {
        showAlert(
            title: title,
            message: message,
            preferredStyle: .actionSheet,
            actions: actions
        )
    }
    
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
    
    @objc private func customBackButtonTapped(_ sender: UIButton) {
        let animated = sender.tag == 1
        
        navigationController?.popViewController(animated: animated)
    }
    
    func applyGradientToView(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.sublayers?.filter {
            $0 is CAGradientLayer
        }
        .forEach { $0.removeFromSuperlayer() }
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func showSimpleToast(
        with title: String,
        position: ToastPosition = .bottom
    ) {
        var style = ToastStyle()
        
        style.cornerRadius = 14
        style.backgroundColor = .gray3
        style.titleColor = .gray7
        style.titleFont = CFont.font.medium17
        
        self.view.makeToast(
            title,
            duration: 1.0,
            position: position,
            title: nil,
            image: nil,
            style: style,
            completion: nil
        )
    }
    
    func showWebView(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .cancel
        present(safariViewController, animated: true)
    }
}
