//
//  EditLocationTopView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditLocationTopView: UIView {
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 이름"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    // MARK: Category
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
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
    
    private var viewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    private func makeAttribute() {
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
    }
}
