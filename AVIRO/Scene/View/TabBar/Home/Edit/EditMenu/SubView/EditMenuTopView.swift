//
//  EditMenuTopView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import UIKit

final class EditMenuTopView: UIView {
    // MARK: Main Title
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "비건 메뉴 구성"
        label.font = .pretendard(size: 18, weight: .bold)
        
        return label
    }()
    
    // MARK: Sub Title
    private lazy var subTitleLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = .gray2
        label.text = "(중복 선택 가능)"
        label.font = .pretendard(size: 13, weight: .medium)
        
        return label
    }()
    
    // MARK: Vegan Options
    private lazy var allVeganButton = VeganOptionButton()
    private lazy var someVeganButton = VeganOptionButton()
    private lazy var requestVeganButton = VeganOptionButton()
    
    private lazy var veganOptions = [VeganOptionButton]()
    
    private lazy var buttonStackView = UIStackView()
    
    // MARK: Constraint 조절
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var veganOptionsTapped: ((String, Bool) -> Void)?
    
    // MARK: View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
            titleLabel,
            subTitleLabel,
            buttonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 200)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // title
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // subTitile
            subTitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 7),
            
            // buttonStackView
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
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
        
        allVeganButton.addTarget(self, action: #selector(tappedAllVegan(_:)), for: .touchUpInside)
        someVeganButton.addTarget(self, action: #selector(tappedSomeVegan(_:)), for: .touchUpInside)
        requestVeganButton.addTarget(self, action: #selector(tappedRequestVegan(_:)), for: .touchUpInside)
    }
    
    @objc private func tappedAllVegan(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }

        allVeganButton.isSelected.toggle()
        
        let selected = allVeganButton.isSelected
        
        if selected {
            someVeganButton.isSelected = false
            requestVeganButton.isSelected = false
        }
        
        veganOptionsTapped?(text, selected)
    }
    
    @objc private func tappedSomeVegan(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }

        someVeganButton.isSelected.toggle()
        
        let selected = someVeganButton.isSelected
        
        if selected {
            allVeganButton.isSelected = false
        }
        
        veganOptionsTapped?(text, selected)
    }
    
    @objc private func tappedRequestVegan(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }

        requestVeganButton.isSelected.toggle()
        
        let selected = requestVeganButton.isSelected
        
        if selected {
            allVeganButton.isSelected = false 
        }
        
        veganOptionsTapped?(text, selected)
    }
    
    // MARK: View Height
    private func makeViewHeight() {
        let titleHeight = titleLabel.frame.height
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
