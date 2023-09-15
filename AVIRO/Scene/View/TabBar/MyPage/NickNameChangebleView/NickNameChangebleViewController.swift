//
//  NickNameChangebleViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import UIKit

final class NickNameChangebleViewController: UIViewController {
    lazy var presenter = NickNameChangeblePresenter(viewController: self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임"
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    private lazy var nicNameField: RegistrationField = {
        let field = RegistrationField()
        
        field.text = UserId.shared.userNickName
        field.addRightCancelButton()
        
        return field
    }()
    
    private lazy var subInfo: UILabel = {
        let label = UILabel()
        
        label.text = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray2
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    private lazy var subInfo2: UILabel = {
        let label = UILabel()
        
        let nickNameCount = UserId.shared.userNickName.count
        
        label.text = "(\(nickNameCount)/8)"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .gray2
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var editNickNameButton: BottomButton1 = {
        let button = BottomButton1()
        
        button.setTitle("수정하기", for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension NickNameChangebleViewController: NickNameChangebleProtocol {
    func setupLayout() {
        [
            titleLabel,
            nicNameField,
            subInfo,
            subInfo2,
            editNickNameButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate( [
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            
            nicNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nicNameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            nicNameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            
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
            subInfo2.widthAnchor.constraint(equalToConstant: 50),
            
            // editButtton
            editNickNameButton.topAnchor.constraint(equalTo: subInfo.bottomAnchor, constant: 30),
            editNickNameButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            editNickNameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupAttribute() {
        self.view.backgroundColor = .gray7
        self.setupCustomBackButton(true)
        
        self.navigationItem.title = "닉네임 수정"
        
        nicNameField.delegate = self
    }
    
    func setupGesture() {
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func changebleNickNameCount(_ count: Int) {
        self.subInfo2.text = "(\(count)/8)"
    }
    
    func changeSubInfo(subInfo: String, isVaild: Bool) {
        self.subInfo.text = subInfo
        
        if isVaild {
            editNickNameButton.isEnabled = true
            nicNameField.isPossible = true
            self.subInfo.textColor = .gray2
        } else {
            editNickNameButton.isEnabled = false
            nicNameField.isPossible = false
            self.subInfo.textColor = .red
            nicNameField.activeShakeAfterNoSearchData()
        }
    }
    
    func initSubInfo() {
        self.subInfo.text = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
        self.subInfo.textColor = .gray2
        self.editNickNameButton.isEnabled = false
        nicNameField.isPossible = nil
        nicNameField.addRightCancelButton()
    }
}

extension NickNameChangebleViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nicNameField.rightButtonHidden = false
        editNickNameButton.isEnabled = false
        nicNameField.isPossible = nil
        
        if let text = textField.text,
           text == "" {
            nicNameField.rightButtonHidden = true
        }
        
        if let count = textField.text?.count {
            changebleNickNameCount(count)
        }
        
        let currentText = textField.text ?? ""
        
        if currentText.count > 8 {
            textField.text = limitText(currentText)
            textField.activeShakeAfterNoSearchData()
            return
        }
        
        presenter.insertUserNickName(currentText)
        
        checkNicknameDuplicationAfterDelay()
    }
    
    private func limitText(_ text: String) -> String {
        let startIndex = text.startIndex
        let endIndex = text.index(startIndex, offsetBy: 8 - 1)
        
        let fixedText = String(text[startIndex...endIndex])
                
        return fixedText
    }

    private func checkNicknameDuplicationAfterDelay() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5,
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

extension NickNameChangebleViewController: UIGestureRecognizerDelegate {
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
