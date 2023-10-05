//
//  LoginViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

// MARK: Text
private enum Text: String {
    case apple = "Apple로 로그인하기"
    case logoutToast = "로그아웃이 완료되었습니다."
    case withdrawalTitle = "회원탈퇴가 완료되었어요."
    case withdrawalMessage = "함께한 시간이 아쉽지만,\n언제든지 돌아오는 문을 열어둘게요.\n어비로의 비건 여정은 계속될 거에요!"
    
    case error = "에러"
}

// MARK: Layout
private enum Layout {
    enum Margin: CGFloat {
        case appleToBottom = 40
        case buttonH = 26.5
    }
    
    enum Size: CGFloat {
        case buttonHeight = 50
    }
}

final class LoginViewController: UIViewController {
    lazy var presenter = LoginViewPresenter(viewController: self)
        
    // MARK: UI Property Definitions
    private lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.launchtitle
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        let text = "가장 쉬운\n비건 맛집 찾기\n어비로"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: CFont.font.medium45,
            .foregroundColor: UIColor.loginTitleColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: text, attributes: normalAttributes)
        
        let heavyAttributes: [NSAttributedString.Key: Any] = [
            .font: CFont.font.heavy45,
            .foregroundColor: UIColor.main,
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
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.loginCharacter
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
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        
        indicatorView.style = .large
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        indicatorView.color = .gray0
        
        return indicatorView
    }()
    
    private lazy var blurEffectView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .gray6.withAlphaComponent(0.3)
        view.frame = self.view.bounds
        
        return view
    }()
    
    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
}

extension LoginViewController: LoginViewProtocol {
    // MARK: Set up func
    func setupLayout() {
        [
            topImageView,
            titleLabel,
            mainImageView,
            appleLoginButton,
            blurEffectView,
            indicatorView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 23),
            topImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 38),
            
            titleLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 37),
            
            mainImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35),
            mainImageView.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -20),
            
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
            
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func setupAttribute() {
        view.backgroundColor = .gray7
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        applyGradientToLoginView()
    }
    
    // MARK: UI Interactions
    @objc private func tapAppleLogin() {
        presenter.clickedAppleLogin()
    }
    
    func switchIsLoading(with loading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.isHidden = !loading
            self?.blurEffectView.isHidden = !loading
        }
    }
    
    // MARK: Push Intercations
    func pushTabBar() {
        DispatchQueue.main.async { [weak self] in
            let viewController = TabBarViewController()
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func pushRegistrationWhenAppleLogin(_ userModel: AVIROAppleUserSignUpDTO) {
        DispatchQueue.main.async { [weak self] in
            let viewController = FirstRegistrationViewController()
            
            let presenter = FirstRegistrationPresenter(
                viewController: viewController,
                appleUserSignUpModel: userModel
            )
            
            viewController.presenter = presenter

            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: Alert Interactions
    func afterLogoutAndMakeToastButton() {
        showSimpleToast(with: Text.logoutToast.rawValue)
    }
    
    func afterWithdrawalUserShowAlert() {
        let alertTitle = Text.withdrawalTitle.rawValue
        let alertMessage = Text.withdrawalMessage.rawValue
        
        showAlert(title: alertTitle, message: alertMessage)
    }
    
    func showErrorAlert(with error: String, title: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            if let title = title {
                self?.showAlert(title: title, message: error)
            } else {
                self?.showAlert(title: Text.error.rawValue, message: error)
            }
        }
    }
}
