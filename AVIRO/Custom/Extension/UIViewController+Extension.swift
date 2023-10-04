//
//  UIViewController+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/15.
//

import UIKit
import SafariServices
import MessageUI

import Toast_Swift

extension UIViewController {
    // MARK: Alert
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
    
    func showDeniedLocationAlert() {
        let cancelAction: AlertAction = (
            title: "취소",
            style: .default,
            handler: nil
        )
        
        let settingAction: AlertAction = (
            title: "설정하기",
            style: .default,
            handler: {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        )
        let title = "위치정보 이용에 대한 액세스 권한이 없어요"
        let message = "앱 설정으로 가서 액세스 권한을 수정 할 수 있어요. 이동하시겠어요?"
        
        showAlert(
            title: title,
            message: message,
            actions: [cancelAction, settingAction]
        )
    }
    
    // MARK: Share Alert
    func showShareAlert(with activityItems: [String]) {
        let vc = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        vc.popoverPresentationController?.permittedArrowDirections = []
        
        vc.popoverPresentationController?.sourceView = view
        self.present(vc, animated: true)
        
    }
    
    // MARK: Toast Alert
    func showSimpleToast(
        with title: String,
        position: ToastPosition = .bottom
    ) {
        var style = ToastStyle()
        
        style.cornerRadius = 14
        style.backgroundColor = .gray3.withAlphaComponent(0.9)
        style.titleColor = .gray6
        style.titleFont = CFont.font.medium17
        
        self.view.makeToast(
            title,
            duration: 0.5,
            position: position,
            title: nil,
            image: nil,
            style: style,
            completion: nil
        )
    }
    
    // MARK: Web View
    func showWebView(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .cancel
        present(safariViewController, animated: true)
    }

    // MARK: Mail View
    func showMailView() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["aviro.kr.official@gmail.com"])
            mail.setSubject("[AVIRO] \(MyData.my.nickname)님의 문의 및 의견")
            mail.setMessageBody(" ", isHTML: false)
            
            present(mail, animated: true)
        } else {
            showAlert(
                title: "등록된 메일 계정이 없습니다",
                message: "메일 계정을 설정해주세요."
            )
        }
    }
        
    // MARK: Back Button
    func setupBack(_ animatied: Bool = false) {
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
    
    // MARK: Gradient View
    func applyGradientToView(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
        transform: CATransform3D? = nil
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.transform = transform ?? CATransform3DIdentity
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.sublayers?.filter {
            $0 is CAGradientLayer
        }
        .forEach { $0.removeFromSuperlayer() }
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradientToLoginView() {
        let colors = [
            UIColor(red: 0.946, green: 0.981, blue: 1, alpha: 1),
            UIColor(red: 0.973, green: 0.99, blue: 1, alpha: 1),
            UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        ]
        
        applyGradientToView(colors: colors)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
