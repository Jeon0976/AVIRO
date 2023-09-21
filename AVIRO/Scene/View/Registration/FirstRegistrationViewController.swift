//
//  RegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

private enum Text: String {
    case title = "반가워요!\n닉네임을 정해주세요."
    case subtitle = "어비로에 불릴 닉네임이에요."
    case nicknamePlaceHolder = "닉네임을 입력해주세요"
    case subInfo = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
    case subInfo2 = "(0/8)"
    case next = "다음으로"
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

final class FirstRegistrationViewController: UIViewController {
    lazy var presenter = FirstRegistrationPresenter(viewController: self)
    
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
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension FirstRegistrationViewController: FirstRegistrationProtocol {
    // MARK: Layout
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
            // titleLabel
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Layout.Margin.largeToView.rawValue
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            
            // subTitle
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Layout.Margin.small.rawValue
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),
            
            // nicNameField
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
            
            // subInfo
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
            
            // subInfo2
            subInfo2.topAnchor.constraint(
                equalTo: subInfo.topAnchor),
            subInfo2.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.largeToView.rawValue
            ),
            subInfo2.widthAnchor.constraint(
                equalToConstant: Layout.Size.subInfo2Width.rawValue
            ),
            
            // next Button
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
        // view, naivgation, ..
        view.backgroundColor = .gray7
        navigationItem.backButtonTitle = ""
        setupCustomBackButton(true)
    }
    
    func setupGesture() {
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func changeSubInfo(
        subInfo: String,
        isVaild: Bool
    ) {
        self.subInfo.text = subInfo
        
        if isVaild {
            nextButton.isEnabled = true
            nicknameField.isPossible = true
            self.subInfo.textColor = .gray2
        } else {
            nextButton.isEnabled = false
            nicknameField.isPossible = false
            self.subInfo.textColor = .warning
            nicknameField.activeHshakeEffect()
        }
    }
    
    func pushSecondRegistrationView(
        _ userInfoModel: AVIROUserSignUpDTO
    ) {
        let viewController = SecondRegistrationViewController()
        
        let presenter = SecondRegistrationPresenter(
            viewController: viewController,
            userInfoModel: userInfoModel
        )
        
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func tappedNextButton() {
        presenter.pushUserInfo()
    }
}

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

extension FirstRegistrationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nicknameField.isPossible = nil
        nextButton.isEnabled = false
        
        if let count = textField.text?.count {
            changebleNickNameCount(count)
        }
        
        let currentText = textField.text ?? ""
        
        // TODO: 분기 두 개 들어가서 리펙토링 필요
        if currentText.count > 8 {
            textField.text = currentText.limitedNickname
            textField.activeHshakeEffect()
            return
        }
        
        presenter.insertUserNickName(currentText)
        
        checkNicknameDuplicationAfterDelay()
    }
    
    private func changebleNickNameCount(_ count: Int) {
        self.subInfo2.text = "(\(count)/8)"
    }
    
    private func checkNicknameDuplicationAfterDelay() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(checkDuplication),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func checkDuplication() {
        presenter.checkDuplication()
    }
}
