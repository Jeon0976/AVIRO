//
//  RegistrationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

final class FirstRegistrationViewController: UIViewController {
    lazy var presenter = FirstRegistrationPresenter(viewController: self)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "반가워요!\n닉네임을 정해주세요."
        label.font = .pretendard(size: 24, weight: .bold)
        label.textColor = .main
        label.numberOfLines = 2
        
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "어비로에 불릴 닉네임이에요."
        label.font = .pretendard(size: 14, weight: .regular)
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var nicNameField: RegistrationField = {
        let field = RegistrationField()
        
        field.makePlaceHolder("닉네임을 입력해주세요")
        field.isPossible = nil
        field.delegate = self
        
        return field
    }()
    
    private lazy var subInfo: UILabel = {
        let label = UILabel()
        
        label.text = "이모지, 특수문자(-, _ 제외)를 사용할 수 없습니다."
        label.font = .pretendard(size: 13, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var subInfo2: UILabel = {
        let label = UILabel()
        
        label.text = "(0/8)"
        label.font = .pretendard(size: 13, weight: .regular)
        label.textColor = .gray2
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var nextButton: NextPageButton = {
        let button = NextPageButton()
        
        button.setTitle("다음으로", for: .normal)
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
            subInfo2.widthAnchor.constraint(equalToConstant: 32),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // view, naivgation, ..
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        setupCustomBackButton(true)
    }
    
    func makeGesture() {
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: check Result
    func changeSubInfo(subInfo: String, isVaild: Bool) {
        self.subInfo.text = subInfo
        
        if isVaild {
            nextButton.isEnabled = true
            nicNameField.isPossible = true
            self.subInfo.textColor = .gray2
        } else {
            nextButton.isEnabled = false
            nicNameField.isPossible = false
            self.subInfo.textColor = .warning
            nicNameField.activeShakeAfterNoSearchData()
        }
    }
    
    // MARK: Push Second Registration View
    func pushSecondRegistrationView(_ userInfoModel: AVIROUserSignUpDTO) {
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
        nicNameField.isPossible = nil
        nextButton.isEnabled = false
        
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
    
    private func changebleNickNameCount(_ count: Int) {
        self.subInfo2.text = "(\(count)/8)"
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

// MARK: View Preview
#if DEBUG
import SwiftUI

struct FirstRegistrationViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc =  FirstRegistrationViewController()
        
        let presenter = FirstRegistrationPresenter(viewController: vc)
        vc.presenter = presenter
        
        return vc
    }
}

struct  FirstRegistrationViewControllerPresentablePreviewProvider: PreviewProvider {
    static var previews: some View {
        FirstRegistrationViewControllerPresentable()
    }
}
#endif
