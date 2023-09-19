//
//  SecondRegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

final class SecondRegistrationViewController: UIViewController {
    lazy var presenter = SecondRegistrationPresenter(viewController: self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "곧 어비로를\n사용할 수 있어요!"
        label.font = .pretendard(size: 24, weight: .bold)
        label.textColor = .main
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "연도와 성별은 선택사항이에요."
        label.font = .pretendard(size: 14, weight: .regular)
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var birthField: RegistrationField = {
        let field = RegistrationField()
        
        field.keyboardType = .numberPad
        field.makePlaceHolder("0000.00.00")
        field.delegate = self
        
        return field
    }()
    
    private lazy var birthExample: UILabel = {
        let label = UILabel()
        
        // birthExample
        label.text = "태어난 연도를 입력해주세요 (선택)"
        label.font = .pretendard(size: 13, weight: .regular)
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var genderButton: [GenderButton] = []
    private lazy var genderStackView = UIStackView()

    private lazy var male: GenderButton = {
        let button = GenderButton()
        
        button.setTitle("남자", for: .normal)
        
        return button
    }()
    
    private lazy var female: GenderButton = {
        let button = GenderButton()
        
        button.setTitle("여자", for: .normal)

        return button
    }()
    
    private lazy var other: GenderButton = {
        let button = GenderButton()
        
        button.setTitle("기타", for: .normal)
        
        return button
    }()
    
    private lazy var genderExample: UILabel = {
        let label = UILabel()
        
        label.text = "성별을 선택해주세요 (선택)"
        label.font = .pretendard(size: 13, weight: .regular)
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var nextButton: NextPageButton = {
        let button = NextPageButton()
        
        button.setTitle("다음으로", for: .normal)
        button.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
     }
}

extension SecondRegistrationViewController: SecondRegistrationProtocol {
    func setupLayout() {
        [
            male,
            female,
            other
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            genderStackView.addArrangedSubview($0)
        }
        
        genderStackView.axis = .horizontal
        genderStackView.spacing = 10
        genderStackView.distribution = .equalSpacing
        
        [
            titleLabel,
            subTitleLabel,
            birthField,
            birthExample,
            genderStackView,
            genderExample,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            // subTitleLabel
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // birthFiled
            birthField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            birthField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            birthField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // birthExample
            birthExample.topAnchor.constraint(equalTo: birthField.bottomAnchor, constant: 18),
            birthExample.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            birthExample.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // genderStack
            genderStackView.topAnchor.constraint(equalTo: birthExample.bottomAnchor, constant: 30),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // genderExample
            genderExample.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 18),
            genderExample.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            genderExample.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 40),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupAttribute() {
        // view ...
        view.backgroundColor = .gray7
        navigationItem.backButtonTitle = ""
        setupCustomBackButton(true)
    
        // genderbutton
        genderButton = [male, female, other]
        
        genderButton.forEach {
            $0.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        }
        genderStackView.backgroundColor = .gray7
        
    }
    
    func setupGesture() {
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: InvalidDate
    func isInvalidDate() {
        birthField.backgroundColor = .bgRed
        birthExample.textColor = .warning
        birthExample.text = "올바른 형식으로 입력해주세요"
        presenter.isWrongBirth = true
    }
    
    func isValidDate() {
        birthField.backgroundColor = .bgNavy
        birthExample.textColor = .gray2
        birthExample.text = "태어난 연도를 입력해주세요 (선택)"
        presenter.isWrongBirth = false
    }
    
    // MARK: Birth Init
    func birthInit() {
        birthField.backgroundColor = .bgNavy
        birthExample.textColor = .gray2
        birthExample.text = "태어난 연도를 입력해주세요 (선택)"
        presenter.isWrongBirth = false
    }
    
    // MARK: Push Thrid RegistrationView
    func pushThridRegistrationView(_ userInfoModel: AVIROUserSignUpDTO) {
        let viewController = ThridRegistrationViewController()
        let presenter = ThridRegistrationPresenter(viewController: viewController,
                                                   userInfo: userInfoModel)
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func genderButtonTapped(_ sender: GenderButton) {
        for button in genderButton {
            button.isSelected = (button == sender)
            
            if button.isSelected {
                guard let gender = button.currentAttributedTitle?.string else { return }
                presenter.gender = Gender(rawValue: gender)
            }
        }
    }
    
    @objc func tappedNextButton() {
        presenter.pushUserInfo()
    }
}

// MARK: 키보드 내리기
extension SecondRegistrationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

extension SecondRegistrationViewController: UITextFieldDelegate {
    // MARK: 년, 월 단위로 . 찍기
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

        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkInvalidDate),
                                     userInfo: nil,
                                     repeats: false
        )

    }
    
    // MARK: 다음 숫자 덮어쓰기
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

            // 최대 개수 넘어가는 것을 방지
            let newCursorPosition = min(range.location + 1, newText.count)
            let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition)
            textField.selectedTextRange = textField.textRange(from: cursorPosition!, to: cursorPosition!)
            return false
        }
        
        return true
    }

    // MARK: String to Int (DateFormatter 활용)
    @objc func checkInvalidDate() {
        presenter.checkInvalidDate()
    }
}
