//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

import Lottie
import Toast_Swift

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
            noLoginButton
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            appleLoginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 26.5),
            appleLoginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -26.5),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // TODO: 추후 없애기
            noLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Make Attribute
    func makeAttribute() {
        view.backgroundColor = .gray7
        
        // titleLabel
        titleLabel.text = "어디서든 비건으로\n어비로 시작하기"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .main
        titleLabel.textAlignment = .center
        
        // appleLoginButton
        appleLoginButton.setTitle("Apple로 로그인하기", for: .normal)
        appleLoginButton.setTitleColor(.white, for: .normal)
        appleLoginButton.setImage(UIImage(named: "Logo"), for: .normal)
        
        appleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        
        appleLoginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        appleLoginButton.layer.borderColor = UIColor.black.cgColor
        appleLoginButton.layer.borderWidth = 2
        appleLoginButton.layer.cornerRadius = 26
        appleLoginButton.clipsToBounds = true
        appleLoginButton.backgroundColor = .black
        
        appleLoginButton.addTarget(self, action: #selector(tapAppleLogin), for: .touchUpInside)
        
        // noLoginButton
        noLoginButton.setTitle("테스트 아이디 로그인", for: .normal)
        noLoginButton.setTitleColor(.gray5, for: .normal)
        noLoginButton.titleLabel?.font = .systemFont(ofSize: 14)
        noLoginButton.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
    }
    
    func makeNaviAttribute() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: No Login Button Tapped
    @objc func tapNoLoginButton() {
        MyData.my.id = "test"
        MyData.my.nickname = "test"
        
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
    
    // MARK: Push TabBar Viewcontroller
    func pushTabBar() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Push Registration ViewController
    func pushRegistration(_ userModel: CommonUserModel) {
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.backButtonTitle = ""
        
        let viewController = FirstRegistrationViewController()
        
        let presenter = FirstRegistrationPresenter(viewController: viewController,
                                                   userModel: userModel)
        
        viewController.presenter = presenter

        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func afterLogoutAndMakeToastButton() {
        let title = "로그아웃이 완료되었습니다."
        
        var style = ToastStyle()
        style.cornerRadius = 14
        style.backgroundColor = .gray3
        
        style.titleColor = .gray7
        style.titleFont = .pretendard(size: 17, weight: .medium)
        
        let centerX = (self.view.frame.size.width) / 2
        let yPosition = self.view.frame.height - 150
                
        self.view.makeToast(title,
                            duration: 1.0,
                            point: CGPoint(x: centerX, y: yPosition),
                            title: nil,
                            image: nil,
                            style: style,
                            completion: nil
        )
    }
    
    func afterWithdrawalUserShowAlert() {
        let alertTitle = "회원탈퇴가 완료되었어요."
        let alertMessage = "함께한 시간이 아쉽지만,\n언제든지 돌아오는 문을 열어둘게요.\n어비로의 비건 여정은 계속될 거에요!"
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let checkAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(checkAction)
        
        present(alertController, animated: true)
    }
}

// MARK: Apple Login 처리 설정
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let appleUserModel = AppleUserModel(
                userIdentifier: userIdentifier,
                name: fullName,
                email: email
            )
            
            presenter.whenCheckAfterAppleLogin(appleUserModel)
        }
    }
    
    // TODO: Error 처리
    func authorizationController(
        controller: ASAuthorizationController,
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
