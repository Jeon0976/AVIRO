//
//  StoreInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class EnrollStoreInfoView: UIView {
    // MARK: Main Title
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 기본 정보"
        label.font = .pretendard(size: 18, weight: .bold)
        
        return label
    }()
    
    lazy var titleField: EnrollField = {
        let field = EnrollField()
        
        return field
    }()
    
    // MARK: Adderss
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 주소"
        label.font = .pretendard(size: 16, weight: .semibold)
        
        return label
    }()
    
    lazy var addressField = EnrollField()
    
    // MARK: Number
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 번호"
        label.font = .pretendard(size: 16, weight: .semibold)
        
        return label
    }()
    
    lazy var numberField = EnrollField()
    
    // MARK: Category
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "카테고리"
        label.font =  .pretendard(size: 16, weight: .semibold)
        
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
        fatalError()
    }
    
    // MARK: 최초 view Height 설정
    override func layoutSubviews() {
        super.layoutSubviews()

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
            titleLabel,
            titleField,
            addressLabel,
            addressField,
            numberLabel,
            numberField,
            categoryLabel,
            buttonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // title
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // titleField
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // address
            addressLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // addressField
            addressField.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            addressField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            // number
            numberLabel.topAnchor.constraint(equalTo: addressField.bottomAnchor, constant: 20),
            numberLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // number Field
            numberField.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 15),
            numberField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            numberField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            // category
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            // buttonStackView
            buttonStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
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
        
        restaurantButton.setButton(PlaceCategory.restaurant.title)
        cafeButton.setButton(PlaceCategory.cafe.title)
        bakeryButton.setButton(PlaceCategory.bakery.title)
        barButton.setButton(PlaceCategory.bar.title)

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
        guard let titleText = titleField.text, !titleText.isEmpty else {
            showOtherDetail(false)
            changeCategoryTopConstraint(false)
            layoutSubviews()
            return
        }
        
        showOtherDetail(true)
        changeCategoryTopConstraint(true)
        
        let titleHeight = titleLabel.frame.height
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
        
        let titleHeight = titleLabel.frame.height
        let titleFieldHeight = titleField.frame.height
        let categoryHeight = categoryLabel.frame.height
        let buttonStackViewHeight = buttonStackView.frame.height
        // 20, 20, 20, 15, 20
        let paddingValues: CGFloat = 95

        let totalHeight = titleHeight + titleFieldHeight + categoryHeight + buttonStackViewHeight + paddingValues
        
        viewHeightConstraint?.constant = totalHeight
    }
    
    // MARK: 숨겨진 label, field 로직 처리
    private func showOtherDetail(_ show: Bool) {
        addressLabel.isHidden = !show
        addressField.isHidden = !show
        numberLabel.isHidden = !show
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
