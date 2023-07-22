//
//  StoreInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class StoreInfoView: UIView {
    // Main Title
    let title: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 기본 정보"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let titleField = InrollField2()
    
    // Adderss
    let address: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 주소"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let addressField = InrollField2()
    
    // Number
    let number: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 번호"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let numberField = InrollField2()
    
    // Category
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "카테고리"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let restaurantButton = CategoryButton()
    let cafeButton = CategoryButton()
    let bakeryButton = CategoryButton()
    let barButton = CategoryButton()
    var category: Category?
    
    var categoryButtons = [CategoryButton]()
    
    let buttonStackView = UIStackView()
    
    // MARK: Constraint 조절
    var viewHeightConstraint: NSLayoutConstraint?
    var categoryTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 최초 view Height 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        if !barButton.isSelected {
            let titleHeight = title.frame.height
            let titleFieldHeight = titleField.frame.height
            let categoryHeight = categoryLabel.frame.height
            let buttonStackViewHeight = buttonStackView.frame.height
            
            // 20, 20, 20, 15, 20
            let totalHeight = titleHeight + titleFieldHeight + categoryHeight + buttonStackViewHeight + 95
            
            viewHeightConstraint?.constant = totalHeight
        }
    }
    
    // MARK: Layout
    private func makeLayout() {
        [
            restaurantButton,
            cafeButton,
            bakeryButton,
            barButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStackView.addArrangedSubview($0)
        }
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        [
            title,
            titleField,
            address,
            addressField,
            number,
            numberField,
            categoryLabel,
            buttonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // titleField
            titleField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // address
            address.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            // addressField
            addressField.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 15),
            addressField.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            addressField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            // number
            number.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 20),
            number.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            // number Field
            numberField.topAnchor.constraint(equalTo: number.bottomAnchor, constant: 15),
            numberField.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            numberField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            // category
            categoryLabel.topAnchor.constraint(equalTo: numberField.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            // buttonStackView
            buttonStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor)
        ])
        
        changeConstraint(false)
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        titleField.addLeftImage()
        titleField.makePlaceHolder("가게 이름 검색")
        
        restaurantButton.setButton(Category.restaurant.title)
        cafeButton.setButton(Category.cafe.title)
        bakeryButton.setButton(Category.bakery.title)
        barButton.setButton(Category.bar.title)

        categoryButtons = [restaurantButton, cafeButton, bakeryButton, barButton]
        
        categoryButtons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        showOtherDetail(false)
    }
    
    func showOtherDetail(_ show: Bool) {
        address.isHidden = !show
        addressField.isHidden = !show
        number.isHidden = !show
        numberField.isHidden = !show
    }
    
    func changeConstraint(_ change: Bool) {
        if let categoryTopConstraint = categoryTopConstraint {
            categoryTopConstraint.isActive = false
        }
        
        if change {
            categoryTopConstraint =         categoryLabel.topAnchor.constraint(
                equalTo: numberField.bottomAnchor, constant: 15)
        } else {
            categoryTopConstraint =         categoryLabel.topAnchor.constraint(
                equalTo: titleField.bottomAnchor, constant: 15)
        }
        categoryTopConstraint?.isActive = true
    }
    
    func expandStoreInformation() {
        if barButton.isSelected {
            
            showOtherDetail(true)
            changeConstraint(true)

            let titleHeight = title.frame.height
            let titleFieldHeight = titleField.frame.height
        
            let categoryHeight = categoryLabel.frame.height
            let buttonStackViewHeight = buttonStackView.frame.height
            
            let subtitleHeight = categoryHeight * 2
            let subtitleFieldHeight = titleFieldHeight * 2
            
            // 20 + 15 + 20 + 15
            let addInset: CGFloat = 70
            
            let plusInset = subtitleHeight + subtitleFieldHeight + addInset
            
            // 20, 20, 20, 15, 20
            let totalHeight = titleHeight + titleFieldHeight + categoryHeight + buttonStackViewHeight + 95 + plusInset
            
            viewHeightConstraint?.constant = totalHeight
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        for button in categoryButtons {
            button.isSelected = (button == sender)
        }
        
        guard let title = sender.currentAttributedTitle?.string else { return }
        
        switch title {
        case Category.restaurant.title:
            category = .restaurant
        case Category.cafe.title:
            category = .cafe
        case Category.bakery.title:
            category = .bakery
        case Category.bar.title:
            category = .bar
        default:
            category = nil
        }
    }
}
