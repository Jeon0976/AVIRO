//
//  LaunchScreenViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/10/03.
//

import UIKit

import Lottie

final class LaunchScreenViewController: UIViewController {
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.launchtitle
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let text = "가장 쉬운\n비건 맛집 찾기\n어비로"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: CFont.font.medium45,
            .foregroundColor: UIColor.launchTitleColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: text, attributes: normalAttributes)
        
        let heavyAttributes: [NSAttributedString.Key: Any] = [
            .font: CFont.font.heavy45,
            .foregroundColor: UIColor.gray7,
            .paragraphStyle: paragraphStyle
        ]
        
        if let range = text.range(of: "어비로") {
            attributedString.addAttributes(heavyAttributes, range: NSRange(range, in: text))
        }
        
        label.attributedText = attributedString
        label.textAlignment = .left
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.launchBG

        return imageView
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "Berry2")
        
        lottie.play()
        lottie.loopMode = .loop
        
        return lottie
    }()
    
    var isUpdateAlertShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .main
        
        [
            topImageView,
            titleLabel,
            bgImageView,
            animationView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 23),
            topImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 38),
            
            titleLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 37),
            
            bgImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        if UIScreen.main.bounds.height < 812.0 {
            NSLayoutConstraint.activate([
                bgImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
            ])
        } else {
            // 그 외 모델일 때의 제약 조건 설정
            NSLayoutConstraint.activate([
                bgImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        
        checkVersion()
    }
    
    private func checkVersion() {
        DispatchQueue.global().async { [weak self] in
            let latestVersion = SystemUtility().latestVersion() ?? "0.0"
            let currentVersion = SystemUtility.appVersion ?? "0.0"

            let splitLatestVersion = latestVersion.split(separator: ".").map { $0 }
            let splitCurrentVersion = currentVersion.split(separator: ".").map { $0 }
                
            DispatchQueue.main.async {
                if splitCurrentVersion[0] < splitLatestVersion[0] {
                    self?.showUpdateAlert(latestVersion)
                } else {
                    if splitCurrentVersion[1] < splitLatestVersion[1] {
                        self?.showUpdateAlert(latestVersion)
                    }
                }
            }
        }
    }
    
    private func showUpdateAlert(_ latestVersion: String) {
        isUpdateAlertShown = true
        
        let action: AlertAction = (title: "업데이트", style: .default, handler: {
            SystemUtility().openAppStore()
        })
        
        showAlert(
            title: "업데이트 알림",
            message: "어비로의 새로운 버전이 있습니다! \(latestVersion) 버전으로 업데이트 해주세요.",
            actions: [action]
        )
    }
}
