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
    var nicNameField = UITextField()
    
    var subInfo = UILabel()
    var subInfo2 = UILabel()
    
    var nextButton = TutorialResButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
}

extension FirstRegistrationViewController: FirstRegistrationProtocol {
    func makeLayout() {
        [
            titleLabel,
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
            
            // nicNameField
            nicNameField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 50),
            nicNameField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTopDouble),
            nicNameField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottomDouble),
            
            // subInfo
            // TODO: 10이랑 비교해보기
            subInfo.topAnchor.constraint(
                equalTo: nicNameField.bottomAnchor, constant: 20),
            subInfo.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTopDouble),
            
            // subInfo2
            subInfo2.topAnchor.constraint(
                equalTo: subInfo.topAnchor),
            subInfo2.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottomDouble),
            
            // next Button
            nextButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Inset.trailingBottomPlus),
            nextButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor)
        ])
    }
    
    func makeAttribute() {
        // view, naivgation, ..
        view.backgroundColor = .white
        
        // titleLabel
        titleLabel.text = "반가워요!\n닉네임을 정해주세요."
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .allVegan
        titleLabel.numberOfLines = 2
        
        nicNameField.font = .systemFont(ofSize: 24)
        nicNameField.placeholder = "닉네임 입력하기"
        
        subInfo.text = "어비로에서 사용할 닉네임을 정해주세요."
        subInfo.font = .systemFont(ofSize: 14)
        subInfo.textColor = .subTitle
        
        subInfo2.text = "(0/15)"
        subInfo2.font = .systemFont(ofSize: 14)
        subInfo2.textColor = .subTitle

        nextButton.setTitle("다음으로", for: .normal)
        nextButton.isEnabled = false
    }
}
