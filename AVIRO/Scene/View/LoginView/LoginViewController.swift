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
        
    var imageView = UIImageView()
    var titleLabel = UILabel()
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
            imageView,
            titleLabel,
            appleLoginButton,
            noLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // imageView
            // TODO: 추후 수정 예정
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            // titleLabel
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            
            // appleLoginButton
            appleLoginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            appleLoginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            appleLoginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            appleLoginButton.heightAnchor.constraint(
                equalToConstant: Layout.Button.height),

            // noLoginButton
            noLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 16),
            noLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Make Attribute
    func makeAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        imageView.backgroundColor = .gray
        
        titleLabel.text = "어디서든\n비건으로!"
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
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
        authorizationController.presentationContextProvider = self
            as? ASAuthorizationControllerPresentationContextProviding
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
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let userInfo = UserInfoModel(userToken: userIdentifier,
                                         userName: fullName,
                                         userEmail: email
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

extension LoginViewController: UICollectionViewDelegateFlowLayout {
    
}

extension LoginViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        return cell
    }
    
}
