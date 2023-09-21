//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

import Toast_Swift

private enum Text: String {
    case apple = "Apple로 로그인하기"
    
}

private enum Layout {
    enum Margin: CGFloat {
        case small = 10
        case medium = 20
        case large = 30
        case largeToView = 40
    }
    
    enum Size: CGFloat {
        case subInfo2Width = 32
        case nextButtonHeight = 50
    }
}

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
        
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.loginTitle
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.loginCharacter
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var shadowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.loginCharacterEllipse
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Text.apple.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage.apple, for: .normal)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        
        button.titleLabel?.font = CFont.font.medium17
        
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 26
        button.clipsToBounds = true
        button.backgroundColor = .black
        
        button.addTarget(
            self,
            action: #selector(tapAppleLogin),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var noLoginButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("테스트 아이디 로그인", for: .normal)
        button.setTitleColor(.gray5, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(tapNoLoginButton), for: .touchUpInside)
        
        return button
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    @objc private func tapAppleLogin() {
        presenter.clickedAppleLogin()
    }
}

extension LoginViewController: LoginViewProtocol {
    func setupLayout() {
        [
            titleImageView,
            mainImageView,
            shadowImageView,
            appleLoginButton,
            noLoginButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 80
            ),
            titleImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            mainImageView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor
            ),
            mainImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            shadowImageView.topAnchor.constraint(
                equalTo: mainImageView.bottomAnchor,
                constant: 15
            ),
            shadowImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            appleLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -60
            ),
            appleLoginButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 26.5
            ),
            appleLoginButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -26.5
            ),
            appleLoginButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            
            // TODO: 추후 없애기
            noLoginButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            noLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
    func setupAttribute() {
        view.backgroundColor = .gray7
        navigationController?.navigationBar.isHidden = true

        applyGradientToView(colors: [UIColor.bgNavy, .gray7])
    }
    
    // MARK: No Login Button Tapped
    @objc func tapNoLoginButton() {
        MyData.my.id = "test"
        MyData.my.nickname = "테스트"
        
        pushTabBar()
    }
    
    // MARK: Push TabBar Viewcontroller
    func pushTabBar() {
        let viewController = TabBarViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Push Registration ViewController
    func pushRegistration(_ userModel: CommonUserModel) {
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
                
        self.view.makeToast(title,
                            duration: 1.0,
                            position: .bottom,
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
