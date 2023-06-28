//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

import KeychainSwift

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
    
    var scrollView = UIScrollView()
    var viewPageControl = UIPageControl()
    var appleLoginButton = UIButton()
    var noLoginButton = UIButton()
    
    let keychain = KeychainSwift()
    
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
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 52),
            
            noLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            noLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func makeAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        scrollView.backgroundColor = .brown
        
        viewPageControl.numberOfPages = 5
        viewPageControl.currentPageIndicatorTintColor = .plusButton
        viewPageControl.pageIndicatorTintColor = .gray
        
        appleLoginButton.setTitle("애플로 로그인", for: .normal)
        appleLoginButton.setTitleColor(.mainTitle, for: .normal)
        appleLoginButton.layer.borderColor = UIColor.mainTitle?.cgColor
        appleLoginButton.layer.borderWidth = 2
        appleLoginButton.layer.cornerRadius = 28
        appleLoginButton.addTarget(self, action: #selector(tapAppleLogin), for: .touchUpInside)
        
        noLoginButton.setTitle("로그인 없이 둘러보기", for: .normal)
        noLoginButton.setTitleColor(.subTitle, for: .normal)
        noLoginButton.titleLabel?.font = .systemFont(ofSize: 14)
        noLoginButton.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
    }
    
    @objc func tapNoLoginButton() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func tapAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            // MARK: 서버에 데이터 업로드
            // 1. 처음 앱 킬 때 서버와 데이터 비교 후 yes, no에 따라 보이는 화면 별도 구현
            print("1: \(userIdentifier), 2: \(fullName), 3: \(email)")
            
            keychain.set(userIdentifier, forKey: "userIdentifier")
            
            let viewController = TabBarViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
    private func saveUserInKeyChain(_ userIdentifier: String) {

    }
}
