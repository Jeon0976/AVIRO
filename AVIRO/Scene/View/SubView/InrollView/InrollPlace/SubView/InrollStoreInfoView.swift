//
//  StoreInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class InrollStoreInfoView: UIView {
    // MARK: Main Title
    lazy var title: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 기본 정보"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    lazy var titleField = InrollField()
    
    // MARK: Adderss
    lazy var address: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 주소"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    lazy var addressField = InrollField()
    
    // MARK: Number
    lazy var number: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "가게 번호"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    lazy var numberField = InrollField()
    
    // MARK: Category
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .registrationColor
        label.text = "카테고리"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    lazy var restaurantButton = CategoryButton()
    lazy var cafeButton = CategoryButton()
    lazy var bakeryButton = CategoryButton()
    lazy var barButton = CategoryButton()
    
    lazy var buttonStackView = UIStackView()
    
    // 공통된 button action 작업을 위해 배열화
    lazy var categoryButtons = [CategoryButton]()

    // MARK: Constraint 조절
    private var categoryTopConstraint: NSLayoutConstraint?
    private var viewHeightConstraint: NSLayoutConstraint?
    
    // MARK: View init
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
        // TODO: 데이터 연결된거 구현하면 수정
        guard let titleText = titleField.text, titleText.isEmpty else {
            return
        }
        
        initStoreInfoViewHeight()
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
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 200)
        viewHeightConstraint?.isActive = true
        
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
            categoryLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            // buttonStackView
            buttonStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: titleField.trailingAnchor)
        ])
        
        changeCategoryTopConstraint(false)
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        titleField.addLeftImage()
        titleField.makePlaceHolder("가게 이름 검색")
        
        numberField.textColor = .gray3
        addressField.textColor = .gray3
        
        restaurantButton.setButton(Category.restaurant.title)
        cafeButton.setButton(Category.cafe.title)
        bakeryButton.setButton(Category.bakery.title)
        barButton.setButton(Category.bar.title)

        categoryButtons = [
            restaurantButton,
            cafeButton,
            bakeryButton,
            barButton
        ]
        
        showOtherDetail(false)
    }
    
    // MARK: View height 확장 메서드
    func expandStoreInfoView() {
        // TODO: 데이터 연결된거
        guard let titleText = titleField.text, !titleText.isEmpty else {
            showOtherDetail(false)
            changeCategoryTopConstraint(false)
            layoutSubviews()
            return
        }
        
        showOtherDetail(true)
        changeCategoryTopConstraint(true)
        
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
    
    // MARK: View hegit 초기화
    func initStoreInfoViewHeight() {
        showOtherDetail(false)
        changeCategoryTopConstraint(false)
        
        let titleHeight = title.frame.height
        let titleFieldHeight = titleField.frame.height
        let categoryHeight = categoryLabel.frame.height
        let buttonStackViewHeight = buttonStackView.frame.height
        // TODO: Static value 수정할 때 수정 요망
        // 20, 20, 20, 15, 20
        let paddingValues: CGFloat = 95

        let totalHeight = titleHeight + titleFieldHeight + categoryHeight + buttonStackViewHeight + paddingValues
        
        viewHeightConstraint?.constant = totalHeight
    }
    
    // MARK: 숨겨진 label, field 로직 처리
    private func showOtherDetail(_ show: Bool) {
        address.isHidden = !show
        addressField.isHidden = !show
        number.isHidden = !show
        numberField.isHidden = !show
    }
    
    // MARK: view height 변경에 따라 변하는 categoyLabel constraint
    private func changeCategoryTopConstraint(_ change: Bool) {
        if let categoryTopConstraint = categoryTopConstraint {
            categoryTopConstraint.isActive = false
        }
        
        if change {
            categoryTopConstraint = categoryLabel.topAnchor.constraint(
                equalTo: numberField.bottomAnchor, constant: 15)
        } else {
            categoryTopConstraint = categoryLabel.topAnchor.constraint(
                equalTo: titleField.bottomAnchor, constant: 15)
        }
        categoryTopConstraint?.isActive = true
    }
}
