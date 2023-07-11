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
    
    var men = UIButton()
    var girl = UIButton()
    var other = UIButton()
    var genderStackView = UIStackView()
    var genderExample = UILabel()
    
    var nextButton = TutorRegisButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
     }
}

extension SecondRegistrationViewController: SecondRegistrationProtocol {
    func makeLayout() {
        [
            men,
            girl,
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
            genderStackView.heightAnchor.constraint(equalToConstant: birthField.frame.height),
            
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
    
    func makeAttribute() {
        // view ...
        view.backgroundColor = .white
        
        titleLabel.text = "test"
        subTitleLabel.text = "test"
        birthExample.text = "Test"
        genderExample.text = "test2"
        men.setTitle("tes", for: .normal)
        girl.setTitle("tt", for: .normal)
        other.setTitle("dwd", for: .normal)
        
        birthField.makePlaceHolder("YYYY.MM.DD")
    
        men.setTitleColor(.black, for: .normal)
        girl.setTitleColor(.black, for: .normal)
        other.setTitleColor(.black, for: .normal)
    }
}
