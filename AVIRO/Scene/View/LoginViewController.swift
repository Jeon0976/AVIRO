//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
    
    var scrollView = UIScrollView()
    var viewPageControl = UIPageControl()
    var appleLoginButton = UIButton()
    var noLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension LoginViewController: LoginViewProtocol {
    func makeLayout() {
        [
            scrollView,
            viewPageControl,
            appleLoginButton,
            noLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewPageControl.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -16),
            viewPageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            
            appleLoginButton.bottomAnchor.constraint(equalTo: noLoginButton.topAnchor, constant: -16),
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            noLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func makeAttribute() {
        
    }
}
