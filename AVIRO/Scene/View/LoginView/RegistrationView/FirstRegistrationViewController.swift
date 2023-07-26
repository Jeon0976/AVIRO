//
//  RegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

final class FirstRegistrationViewController: UIViewController {
    lazy var presenter = FirstRegistrationPresenter(viewController: self)
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var nicNameField = RegistrationField()
    
    var subInfo = UILabel()
    var subInfo2 = UILabel()
    
    var nextButton = BottomButton()
    
    var tapGesture = UITapGestureRecognizer()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension FirstRegistrationViewController: FirstRegistrationProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            titleLabel,
            subTitleLabel,
            nicNameField,
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
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 30),
            
            // subTitle
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // nicNameField
            nicNameField.topAnchor.constraint(
                equalTo: subTitleLabel.bottomAnchor, constant: 30),
            nicNameField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 30),
            nicNameField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -30),
            
            // subInfo
            subInfo.topAnchor.constraint(
                equalTo: nicNameField.bottomAnchor, constant: 18),
            subInfo.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 40),
            subInfo.trailingAnchor.constraint(equalTo: subInfo2.leadingAnchor, constant: -10),
            
            // subInfo2
            subInfo2.topAnchor.constraint(
                equalTo: subInfo.topAnchor),
            subInfo2.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -40),
            subInfo2.widthAnchor.constraint(equalToConstant: 45),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // view, naivgation, ..
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""

        // TODO: 확인
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        // titleLabel
        titleLabel.text = "반가워요!\n닉네임을 정해주세요."
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .allVegan
        titleLabel.numberOfLines = 2
        
        // subTitle
        subTitleLabel.text = "어비로에 불릴 닉네임이에요."
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subTitleLabel.textColor = .subTitleColor
        
        // nicNameField
        nicNameField.font = .systemFont(ofSize: 18)
        nicNameField.makePlaceHolder("닉네임을 입력해주세요")
        nicNameField.isPossible = nil
        nicNameField.delegate = self
                
        // subInfo
        subInfo.text = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
        subInfo.font = .systemFont(ofSize: 13)
        subInfo.numberOfLines = 0
        subInfo.textColor = .exampleRegistration
        
        // subInfo2
        subInfo2.text = "(0/15)"
        subInfo2.font = .systemFont(ofSize: 13)
        subInfo2.textColor = .exampleRegistration
        
        // nextButton
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(tappedNextButton), for: .touchUpInside)
    }
    
    // MARK: check Result
    func changeSubInfo(subInfo: String, isVaild: Bool) {
        self.subInfo.text = subInfo
        
        if isVaild {
            nextButton.isEnabled = true
            nicNameField.isPossible = true
            self.subInfo.textColor = .exampleRegistration
        } else {
            nextButton.isEnabled = false
            nicNameField.isPossible = false
            self.subInfo.textColor = .explainImPossible
        }
    }
    
    // MARK: Push Second Registration View
    func pushSecondRegistrationView(_ userInfoModel: UserInfoModel) {
        let viewController = SecondRegistrationViewController()
        let presenter = SecondRegistrationPresenter(viewController: viewController,
                                                    userInfoModel: userInfoModel)
        
        viewController.presenter = presenter
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func tappedNextButton() {
        presenter.pushUserInfo()
    }
}

// MARK: 키보드 내리기
extension FirstRegistrationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UITextField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

extension FirstRegistrationViewController: UITextFieldDelegate {
    // MARK: TextField 값이 변하고 있을 때
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            presenter.insertUserNicName("")
            checkDuplication()
            subInfo2.text = "(0/15)"
            return
        }

        nicNameField.isPossible = nil

        let currentText = textField.text ?? ""
        
        // MARK: 최대 갯수 제한
        if currentText.count > 15 {
            let startIndex = currentText.startIndex
            let endIndex = currentText.index(startIndex, offsetBy: 15 - 1)
            let fixedText = String(currentText[startIndex...endIndex])
            textField.text = fixedText
            return
        }
        
        presenter.insertUserNicName(currentText)
        subInfo2.text = "(\(currentText.count)/15)"
        
        // 0.5초 후 nicname 확인 method 실행
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(checkDuplication),
                                     userInfo: nil,
                                     repeats: false
        )
    }
    
    // MARK: Nicname Check Timer 발동
    @objc func checkDuplication() {
        presenter.checkDuplication()
    }
}
