//
//  SecondRegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

// MARK: Text
private enum Text: String {
    case title = "곧 어비로를\n사용할 수 있어요!"
    case subtitle = "연도와 성별은 선택사항이에요."
    case birthPlaceHolder = "0000.00.00"
    case birthSub = "태어난 연도를 입력해주세요 (선택)"
    case birthSubWarning = "올바른 형식으로 입력해주세요"
    case male = "남자"
    case female = "여자"
    case otherGender = "기타"
    case genderSub = "성별을 선택해주세요 (선택)"
    case next = "다음으로"
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
        case nextButtonHeight = 50
    }
    
    enum Spacing: CGFloat {
        case gender = 10
    }
}

final class SecondRegistrationViewController: UIViewController {
    lazy var presenter = SecondRegistrationPresenter(viewController: self)
    
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
    
    private lazy var birthField: RegistrationField = {
        let field = RegistrationField()
        
        field.keyboardType = .numberPad
        field.makePlaceHolder(Text.birthPlaceHolder.rawValue)
        field.delegate = self
        
        return field
    }()
    private lazy var birthSubLabel: UILabel = {
        let label = UILabel()
        
        label.text = Text.birthSub.rawValue
        label.font = CFont.font.regular13
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var genderButton: [GenderButton] = []
    private lazy var genderStackView: UIStackView = {
        let stackView = UIStackView()
        
        [
            male,
            female,
            other
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = Layout.Spacing.gender.rawValue
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private lazy var male: GenderButton = {
        let button = GenderButton()
        
        button.setTitle(Text.male.rawValue, for: .normal)
        
        return button
    }()
    private lazy var female: GenderButton = {
        let button = GenderButton()
        
        button.setTitle(Text.female.rawValue, for: .normal)

        return button
    }()
    private lazy var other: GenderButton = {
        let button = GenderButton()
        
        button.setTitle(Text.otherGender.rawValue, for: .normal)
        
        return button
    }()
    private lazy var genderSubLabel: UILabel = {
        let label = UILabel()
        
        label.text = Text.genderSub.rawValue
        label.font = CFont.font.regular13
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var nextButton: NextPageButton = {
        let button = NextPageButton()
        
        button.setTitle(Text.next.rawValue, for: .normal)
        button.addTarget(
            self,
            action: #selector(tappedNextButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    // MARK: Override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
     }
}

extension SecondRegistrationViewController: SecondRegistrationProtocol {
    // MARK: Set up func
    func setupLayout() {
        [
            titleLabel,
            subtitleLabel,
            birthField,
            birthSubLabel,
            genderStackView,
            genderSubLabel,
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
            
            birthField.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            birthField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            birthField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.large.rawValue
            ),
            
            birthSubLabel.topAnchor.constraint(
                equalTo: birthField.bottomAnchor,
                constant: Layout.Margin.small.rawValue
            ),
            birthSubLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.largeToView.rawValue
            ),
            birthSubLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.largeToView.rawValue
            ),
            
            genderStackView.topAnchor.constraint(
                equalTo: birthSubLabel.bottomAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            genderStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.large.rawValue
            ),
            genderStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Layout.Margin.large.rawValue
            ),
            
            genderSubLabel.topAnchor.constraint(
                equalTo: genderStackView.bottomAnchor,
                constant: Layout.Margin.small.rawValue
            ),
            genderSubLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Layout.Margin.largeToView.rawValue
            ),
            genderSubLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Layout.Margin.largeToView.rawValue
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
        navigationController?.navigationBar.isHidden = false
        setupBack(true)
    }
    
    func setupGesture() {
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupGenderButton() {
        genderButton = [male, female, other]
        
        genderButton.forEach {
            $0.addTarget(
                self,
                action: #selector(genderButtonTapped(_:)),
                for: .touchUpInside
            )
        }
        genderStackView.backgroundColor = .gray7
    }
    
    // MARK: UI Interactions
    func isValidDate(with isValid: Bool) {
        birthField.isPossible = isValid
        birthSubLabel.textColor = isValid ? .gray2 : .warning
        birthSubLabel.text = isValid ? Text.birthSub.rawValue : Text.birthSubWarning.rawValue
    }
    
    private func birthInit() {
        birthField.isPossible = nil
        birthSubLabel.textColor = .gray2
        birthSubLabel.text = Text.birthSub.rawValue
    }
    
    @objc private func genderButtonTapped(_ sender: GenderButton) {
        for button in genderButton {
            button.isSelected = (button == sender)
            
            if button.isSelected {
                guard let gender = button.currentAttributedTitle?.string else { return }
                presenter.gender = Gender(rawValue: gender)
            }
        }
    }
    
    @objc private func tappedNextButton() {
        presenter.pushUserInfo()
    }
    
    // MARK: Push Interactions
    func pushThridRegistrationView(
        _ userInfoModel: AVIROAppleUserSignUpDTO
    ) {
        let viewController = ThridRegistrationViewController()
        
        let presenter = ThridRegistrationPresenter(
            viewController: viewController,
            userInfo: userInfoModel
        )
        
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: UIGestureRecognizerDelegate
extension SecondRegistrationViewController: UIGestureRecognizerDelegate {
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
extension SecondRegistrationViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard var text = textField.text else { return }

        birthInit()
        
        if text.count > 10 {
            text = String(text.prefix(10))
        }

        if presenter.birth.count < text.count && (text.count == 4 || text.count == 7) {
            text = "\(text)."
        }

        textField.text = text
        presenter.birth = text
    }
    
    /// text를 교체할때 발동 메서드
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        if let text = textField.text, text.count == 10, !string.isEmpty {
            let textArray = Array(text)
            var newText = ""
            for (index, character) in textArray.enumerated() {
                if index == range.location && character != "." {
                    newText += string
                } else {
                    newText += String(character)
                }
            }

            textField.text = newText
            presenter.birth = text

            /// 최대 개수 넘어가는 것을 방지
            let newCursorPosition = min(range.location + 1, newText.count)
            let cursorPosition = textField.position(
                from: textField.beginningOfDocument,
                offset: newCursorPosition
            )
            textField.selectedTextRange = textField.textRange(
                from: cursorPosition!,
                to: cursorPosition!
            )

            return false
        }

        return true
    }
}
