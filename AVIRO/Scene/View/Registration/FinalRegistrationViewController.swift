//
//  FinalRegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

import Lottie

final class FinalRegistrationViewController: UIViewController {
    
    var fanfareAnimation = LottieAnimationView(name: "RegistrationCompleted")
    var titleLabel = UILabel()
    var finalButton = NextPageButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLayout()
        makeAttribute()
    }
    
    private func makeLayout() {
        [
            fanfareAnimation,
            titleLabel,
            finalButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            fanfareAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fanfareAnimation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            finalButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            finalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finalButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func makeAttribute() {
        // view ...
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        // titleLabel
        titleLabel.text = "가입 완료\n환영합니다!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .main
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        // fanfareAnimation
        fanfareAnimation.play()
        fanfareAnimation.loopMode = .loop
        
        // finalButton
        finalButton.setTitle("어비로 바로 시작하기", for: .normal)
        finalButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
