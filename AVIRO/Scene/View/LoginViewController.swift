//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

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
    // MARK: Make Layout
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
            // scrollView
            scrollView.topAnchor.constraint(
                equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            // viewPageControl
            viewPageControl.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            viewPageControl.bottomAnchor.constraint(
                equalTo: appleLoginButton.topAnchor, constant: Layout.Inset.trailingBottom),
            viewPageControl.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor, constant: Layout.Inset.leadingTop),
            
            // appleLoginButton
            appleLoginButton.bottomAnchor.constraint(
                equalTo: noLoginButton.topAnchor, constant: Layout.Inset.trailingBottom),
            appleLoginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            appleLoginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            appleLoginButton.heightAnchor.constraint(
                equalToConstant: Layout.Button.height),
            
            // noLoginButton
            noLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Inset.trailingBottom),
            noLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Make Attribute
    func makeAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        scrollView.backgroundColor = .brown
        
        viewPageControl.numberOfPages = presenter.makeScrollView()
        viewPageControl.currentPageIndicatorTintColor = .plusButton
        viewPageControl.pageIndicatorTintColor = .gray
        
        appleLoginButton.setTitle(StringValue.Login.apple, for: .normal)
        appleLoginButton.setTitleColor(.mainTitle, for: .normal)
        appleLoginButton.layer.borderColor = UIColor.mainTitle?.cgColor
        appleLoginButton.layer.borderWidth = 2
        appleLoginButton.layer.cornerRadius = 28
        appleLoginButton.addTarget(self, action: #selector(tapAppleLogin), for: .touchUpInside)
        
        noLoginButton.setTitle(StringValue.Login.noLogin, for: .normal)
        noLoginButton.setTitleColor(.subTitle, for: .normal)
        noLoginButton.titleLabel?.font = .systemFont(ofSize: 14)
        noLoginButton.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
    }
    
    // MARK: No Login Button Tapped
    @objc func tapNoLoginButton() {
        pushTabBar()
    }
    
    // MARK: Apple Login Tapped
    @objc func tapAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    // MARK: Push TabBarViewcontroller
    func pushTabBar() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Apple Login 처리 설정
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let userInfo = UserInfoModel(userIdentifier: userIdentifier,
                                         fullName: fullName,
                                         email: email
            )
            
            presenter.upLoadUserInfo(userInfo)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
}
