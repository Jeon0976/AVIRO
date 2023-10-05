//
//  RegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

// MARK: Text
private enum Text: String {
    case title = "반가워요!\n닉네임을 정해주세요."
    case subtitle = "어비로에 불릴 닉네임이에요."
    case nicknamePlaceHolder = "닉네임을 입력해주세요"
    case subInfo = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
    case subInfo2 = "(0/8)"
    case next = "다음으로"
    
    case error = "에러"
}

// MARK: Layout
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

final class FirstRegistrationViewController: UIViewController {
    lazy var presenter = FirstRegistrationPresenter(viewController: self)
    
    // MARK: UI Property Definitions
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = Text.title.rawValue
        label.font = CFont.font.bold24
        label.textColor = .main
        label.numberOfLines = 2
        
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = Text.subtitle.rawValue
        label.font = CFont.font.regular14
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var nicknameField: RegistrationField = {
        let field = RegistrationField()
        
        field.makePlaceHolder(Text.nicknamePlaceHolder.rawValue)
        field.isPossible = nil
        field.delegate = self
        
        return field
    }()
    
    private lazy var subInfo: UILabel = {
        let label = UILabel()
        
        label.text = Text.subInfo.rawValue
        label.font = CFont.font.regular13
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var subInfo2: UILabel = {
        let label = UILabel()
        
        label.text = Text.subInfo2.rawValue
        label.font =  CFont.font.regular13
        label.textColor = .gray2
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var nextButton: NextPageButton = {
        let button = NextPageButton()
        
        button.setTitle(Text.next.rawValue, for: .normal)
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(tappedNextButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private var tapGesture = UITapGestureRecognizer()

    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension FirstRegistrationViewController: FirstRegistrationProtocol {
    // MARK: Set up func
    func setupLayout() {
        [
            titleLabel,
            subtitleLabel,
            nicknameField,
            subInfo,
            subInfo2,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Layout.Margin.largeToView.rawValue
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Layout.Margin.small.rawValue
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            
            nicknameField.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            nicknameField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            nicknameField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.large.rawValue
            ),
            
            subInfo.topAnchor.constraint(
                equalTo: nicknameField.bottomAnchor,
                constant: Layout.Margin.small.rawValue
            ),
            subInfo.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.largeToView.rawValue
            ),
            subInfo.trailingAnchor.constraint(
                equalTo: subInfo2.leadingAnchor,
                constant: -Layout.Margin.small.rawValue
            ),
            
            subInfo2.topAnchor.constraint(
                equalTo: subInfo.topAnchor),
            subInfo2.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.largeToView.rawValue
            ),
            subInfo2.widthAnchor.constraint(
                equalToConstant: Layout.Size.subInfo2Width.rawValue
            ),
            
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Layout.Margin.largeToView.rawValue
            ),
            nextButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.medium.rawValue
            ),
            nextButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.medium.rawValue
            ),
            nextButton.heightAnchor.constraint(
                equalToConstant: Layout.Size.nextButtonHeight.rawValue
            )
        ])
    }
    
    func setupAttribute() {
        view.backgroundColor = .gray7
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupGesture() {
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: UI Interactions
    func changeSubInfo(
        subInfo: String,
        isVaild: Bool
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.subInfo.text = subInfo
            
            self?.nextButton.isEnabled = isVaild
            self?.nicknameField.isPossible = isVaild
            self?.subInfo.textColor = isVaild ? .gray2 : .warning
            
            if !isVaild {
                self?.nicknameField.activeHshakeEffect()
            }
        }
    }
    
    @objc private func tappedNextButton() {
        presenter.pushUserInfo()
    }
    
    // MARK: Push Interactions
    func pushSecondRegistrationView(
        _ userInfoModel: AVIROAppleUserSignUpDTO
    ) {
        let viewController = SecondRegistrationViewController()
        
        let presenter = SecondRegistrationPresenter(
            viewController: viewController,
            userInfoModel: userInfoModel
        )
        
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: Alert Intercations
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

// MARK: UIGestureRecognizerDelegate
extension FirstRegistrationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if touch.view is UITextField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

// MARK: UITextFieldDelegate
extension FirstRegistrationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        initFieldAndButtonUI()
        
        if let count = textField.text?.count {
            changebleNickNameCount(with: count)
        }
        
        let currentText = textField.text ?? ""
        
        if currentText.count > 8 {
            textField.text = currentText.limitedNickname
            textField.activeHshakeEffect()
            return
        }
        
        presenter.insertUserNickName(currentText)
    }
    
    private func initFieldAndButtonUI() {
        nicknameField.isPossible = nil
        nextButton.isEnabled = false
    }
    
    private func changebleNickNameCount(with count: Int) {
        self.subInfo2.text = "(\(count)/8)"
    }
    
}
