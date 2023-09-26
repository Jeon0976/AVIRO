//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

private enum Text: String {
    case apple = "Apple로 로그인하기"
    case logoutToast = "로그아웃이 완료되었습니다."
    case withdrawalTitle = "회원탈퇴가 완료되었어요."
    case withdrawalMessage = "함께한 시간이 아쉽지만,\n언제든지 돌아오는 문을 열어둘게요.\n어비로의 비건 여정은 계속될 거에요!"
}

private enum Layout {
    enum Margin: CGFloat {
        case titleToView = 80
        case shadowToMain = 15
        case appleToBottom = 40
        case buttonH = 26.5
    }
    
    enum Size: CGFloat {
        case buttonHeight = 50
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
        
        button.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -8,
            bottom: 0,
            right: 0
        )
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
                constant: Layout.Margin.titleToView.rawValue
            ),
            titleImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            mainImageView.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor, constant: 60
            ),
            mainImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            shadowImageView.topAnchor.constraint(
                equalTo: mainImageView.bottomAnchor,
                constant: Layout.Margin.shadowToMain.rawValue
            ),
            shadowImageView.centerXAnchor.constraint(
                equalTo: self.view.centerXAnchor
            ),
            
            appleLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Layout.Margin.appleToBottom.rawValue
            ),
            appleLoginButton.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: Layout.Margin.buttonH.rawValue
            ),
            appleLoginButton.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -Layout.Margin.buttonH.rawValue
            ),
            appleLoginButton.heightAnchor.constraint(
                equalToConstant: Layout.Size.buttonHeight.rawValue
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
        // 스와이프 뒤로가기 막기
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        applyGradientToLoginView()
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
        
        let presenter = FirstRegistrationPresenter(
            viewController: viewController,
            userModel: userModel
        )
        
        viewController.presenter = presenter

        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func afterLogoutAndMakeToastButton() {
        showSimpleToast(with: Text.logoutToast.rawValue)
    }
    
    func afterWithdrawalUserShowAlert() {
        let alertTitle = Text.withdrawalTitle.rawValue
        let alertMessage = Text.withdrawalMessage.rawValue
        
        let alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let checkAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(checkAction)
        
        present(alertController, animated: true)
    }
    
    func showErrorAlert(_ error: Error) {
        showAlert(
            title: "에러",
            message: error.localizedDescription
        )
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
