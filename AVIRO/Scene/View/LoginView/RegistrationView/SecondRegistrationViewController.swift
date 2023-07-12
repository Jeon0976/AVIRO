//
//  SecondRegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

final class SecondRegistrationViewController: UIViewController {
    lazy var presenter = SecondRegistrationPresenter(viewController: self)
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var birthField = RegistrationField()
    var birthExample = UILabel()
    
    var genderButton: [GenderButton] = []
    var male = GenderButton()
    var female = GenderButton()
    var other = GenderButton()
    
    var genderStackView = UIStackView()
    var genderExample = UILabel()
    
    var nextButton = TutorRegisButton()
    
    var tapGesture = UITapGestureRecognizer()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
     }
}

extension SecondRegistrationViewController: SecondRegistrationProtocol {
    // MARK: Layout
    func makeLayout() {
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
            birthExample.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            birthExample.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            
            // genderStack
            genderStackView.topAnchor.constraint(equalTo: birthExample.bottomAnchor, constant: 30),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // genderExample
            genderExample.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 18),
            genderExample.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            genderExample.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 45),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // view ...
        view.backgroundColor = .white
        
        // titleLabel
        titleLabel.text = "곧 어비로를\n사용할 수 있어요!"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .allVegan
        titleLabel.numberOfLines = 2

        // subTitle
        subTitleLabel.text = "연도와 성별은 선택사항이에요."
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subTitleLabel.textColor = .subTitleColor
        
        // birthField
        birthField.keyboardType = .numberPad
        birthField.makePlaceHolder("YYYY.MM.DD")
        birthField.delegate = self

        // birthExample
        birthExample.text = "태어난 연도를 입력해주세요 (선택)"
        birthExample.font = .systemFont(ofSize: 14)
        birthExample.numberOfLines = 0
        birthExample.textColor = .exampleRegistration
        
        // genderbutton
        male.setTitle("남자", for: .normal)
        female.setTitle("여자", for: .normal)
        other.setTitle("기타", for: .normal)
        genderButton = [male, female, other]
        
        genderButton.forEach {
            $0.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        }
        genderStackView.backgroundColor = .white
        
        // genderExample
        genderExample.text = "성별을 선택해주세요 (선택)"
        genderExample.font = .systemFont(ofSize: 14)
        genderExample.numberOfLines = 0
        genderExample.textColor = .exampleRegistration
        
        // nextButton
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
    }
    
    // MARK: InvalidDate
    func invalidDate() {
        birthField.isPossible = false
        birthExample.textColor = .explainImPossible
        birthExample.text = "올바른 형식으로 입력해주세요"
    }
    
    // MARK: Birth Init
    func birthInit() {
        birthField.isPossible = nil
        birthExample.textColor = .exampleRegistration
        birthExample.text = "태어난 연도를 입력해주세요 (선택)"
    }
    
    @objc func genderButtonTapped(_ sender: GenderButton) {
        for button in genderButton {
            button.isSelected = (button == sender)
            
            if button.isSelected {
                switch button.currentAttributedTitle?.string {
                case "남자":
                    presenter.gender = .male
                case "여자":
                    presenter.gender = .female
                case "기타":
                    presenter.gender = .other
                default:
                    break
                }
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
    //MARK: 년, 월 단위로 . 찍기
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
