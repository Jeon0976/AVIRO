//
//  EditMenuTopView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import UIKit

final class EditMenuTopView: UIView {
    // MARK: Main Title
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "비건 메뉴 구성"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    // MARK: Sub Title
    private lazy var subTitle: UILabel = {
       let label = UILabel()
        
        label.textColor = .gray2
        label.text = "(중복 선택 가능)"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        
        return label
    }()
    
    // MARK: Vegan Options
    lazy var allVeganButton = VeganOptionButton()
    lazy var someVeganButton = VeganOptionButton()
    lazy var requestVeganButton = VeganOptionButton()
    
    lazy var veganOptions = [VeganOptionButton]()
    
    private lazy var buttonStackView = UIStackView()
    
    // MARK: Constraint 조절
    private var viewHeightConstraint: NSLayoutConstraint?
    
    // MARK: View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 최초 View Height 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeViewHeight()
    }

    // MARK: layout
    private func makeLayout() {
        [
            allVeganButton,
            someVeganButton,
            requestVeganButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.addArrangedSubview($0)
        }
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing
        
        [
            title,
            subTitle,
            buttonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 200)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // subTitile
            subTitle.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            subTitle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 7),
            
            // buttonStackView
            buttonStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        self.layer.cornerRadius = 10 
        self.backgroundColor = .gray7
        
        allVeganButton.setButton("모든 메뉴가\n비건", UIImage(named: "AllOption")!)
        someVeganButton.setButton("일부 메뉴만\n비건", UIImage(named: "SomeOption")!)
        requestVeganButton.setButton("비건 메뉴로\n요청 가능", UIImage(named: "RequestOption")!)
        
        allVeganButton.changedColor = .all
        someVeganButton.changedColor = .some
        requestVeganButton.changedColor = .request
        
        veganOptions = [
            allVeganButton,
            someVeganButton,
            requestVeganButton
        ]
    }
    
    // MARK: View Height
    private func makeViewHeight() {
        let titleHeight = title.frame.height
        let buttonStackViewHeight = buttonStackView.frame.height
        // TODO: Static value 수정할 때 수정 요망
        // 20, 20, 20
        let paddingValues: CGFloat = 60
        
        let totalHeight = titleHeight + buttonStackViewHeight + paddingValues
            
        viewHeightConstraint?.constant = totalHeight
    }
    
    func dataBinding(isAll: Bool, isSome: Bool, isRequest: Bool) {
        allVeganButton.isSelected = isAll
        someVeganButton.isSelected = isSome
        requestVeganButton.isSelected = isRequest
    }
}
