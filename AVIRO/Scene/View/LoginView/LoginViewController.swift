//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

import Lottie

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
        
    var titleLabel = UILabel()
    var appleLoginButton = UIButton()
    var noLoginButton = UIButton()
    
    let loginAnimation = LottieAnimationView(name: "LoginJson")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        presenter.viewWillAppear()
    }
    
}

extension LoginViewController: LoginViewProtocol {
    // MARK: Make Layout
    func makeLayout() {
        [
            titleLabel,
            appleLoginButton,
            noLoginButton,
            loginAnimation
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            // appleLoginButton
            appleLoginButton.bottomAnchor.constraint(
                equalTo: loginAnimation.topAnchor, constant: -35),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 220),
            appleLoginButton.heightAnchor.constraint(
                equalToConstant: Layout.Button.height),
            appleLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            
            // loginAnimation
            loginAnimation.widthAnchor.constraint(equalToConstant: view.frame.width),
            loginAnimation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            
            // TODO: 추후 없애기
            noLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Make Attribute
    func makeAttribute() {
        view.backgroundColor = .gray7
        
        // loginAnimation
        loginAnimation.play()
        loginAnimation.loopMode = .loop
        
        // titleLabel
        titleLabel.text = "어디서든 비건으로\n어비로 시작하기"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .main
        titleLabel.textAlignment = .center
        
        // appleLoginButton
        appleLoginButton.setTitle(StringValue.Login.apple, for: .normal)
        appleLoginButton.setTitleColor(.mainTitle, for: .normal)
        appleLoginButton.setImage(UIImage(named: "Logo"), for: .normal)
        appleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        
        appleLoginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        appleLoginButton.layer.borderColor = UIColor.mainTitle?.cgColor
        appleLoginButton.layer.borderWidth = 2
        appleLoginButton.layer.cornerRadius = 26
        appleLoginButton.addTarget(self, action: #selector(tapAppleLogin), for: .touchUpInside)
        appleLoginButton.adjustsImageWhenHighlighted = false
        
        // noLoginButton
        noLoginButton.setTitle(StringValue.Login.noLogin, for: .normal)
        noLoginButton.setTitleColor(.subTitle, for: .normal)
        noLoginButton.titleLabel?.font = .systemFont(ofSize: 14)
        noLoginButton.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
    }
    
    func makeNaviAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: No Login Button Tapped
    @objc func tapNoLoginButton() {
        pushRegistration(UserInfoModel(userToken: "test",
                                       userName: "",
                                       userEmail: "",
                                       nickname: "",
                                       birthYear: 0,
                                       gender: "",
                                       marketingAgree: false)
        )
    }
    
    // MARK: Apple Login Tapped
    @objc func tapAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
            as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    // MARK: Push TabBar Viewcontroller
    func pushTabBar() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Push Registration ViewController
    func pushRegistration(_ userInfo: UserInfoModel) {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.backButtonTitle = ""
        
        let viewController = FirstRegistrationViewController()
        
        let presenter = FirstRegistrationPresenter(viewController: viewController,
                                              userInfoModel: userInfo)
        
        viewController.presenter = presenter

        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: Apple Login 처리 설정
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let userInfo = UserInfoModel(userToken: userIdentifier,
                                         userName: fullName,
                                         userEmail: email,
                                         nickname: "",
                                         birthYear: 0,
                                         gender: "",
                                         marketingAgree: false
            )
            
            presenter.upLoadUserInfo(userInfo)
        }
    }
    
    // TODO: Error 처리
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error
    ) {
        
    }
}

// MARK: View Preview
#if DEBUG
import SwiftUI

struct LoginViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = LoginViewController()
        let presenter = LoginViewPresenter(viewController: vc)
        vc.presenter = presenter
        
        return vc
    }
}

struct LoginViewControllerPresentablePreviewProvider: PreviewProvider {
    static var previews: some View {
        LoginViewControllerPresentable()
    }
}
#endif
