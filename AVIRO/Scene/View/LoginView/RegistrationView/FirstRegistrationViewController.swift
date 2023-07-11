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
    
    var nextButton = TutorRegisButton()
    
    var tapGesture = UITapGestureRecognizer()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension FirstRegistrationViewController: FirstRegistrationProtocol {
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
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTopDouble),
            
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
                equalTo: view.leadingAnchor, constant: 45),
            subInfo.trailingAnchor.constraint(equalTo: subInfo2.leadingAnchor, constant: -10),
            
            // subInfo2
            subInfo2.topAnchor.constraint(
                equalTo: subInfo.topAnchor),
            subInfo2.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -45),
            subInfo2.widthAnchor.constraint(equalToConstant: 45),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.Button.height)
        ])
    }
    
    func makeAttribute() {
        // view, naivgation, ..
        view.backgroundColor = .white
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
        subInfo.text = "어비로에서 사용할 닉네임을 정해주세요."
        subInfo.font = .systemFont(ofSize: 14)
        subInfo.numberOfLines = 0
        subInfo.textColor = .exampleRegistration
        
        // subInfo2
        subInfo2.text = "(0/15)"
        subInfo2.font = .systemFont(ofSize: 14)
        subInfo2.textColor = .exampleRegistration
        
        // nextButton
        nextButton.setTitle("다음으로", for: .normal)
        nextButton.isEnabled = false
    }
    
    // MARK: check Result
    func changeSubInfo(subInfo: String, isVaild: Bool) {
        self.subInfo.text = subInfo
    }
}

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
        let currentText = textField.text ?? ""

        if currentText.count > 15 {
            return
        }
        presenter.insertUserNicName(currentText)
        subInfo2.text = "(\(currentText.count)/15)"
        
        // 1초 후 nicname 확인 method 실행
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(checkDuplication),
                                     userInfo: nil,
                                     repeats: false
        )
    }
     
    @objc func checkDuplication() {
        presenter.checkDuplication()
    }
}
