//
//  EditLocationTopView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditLocationTopView: UIView {
    private lazy var placeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 이름"
        label.font = .pretendard(size: 16, weight: .semibold)
        
        return label
    }()
    
    private lazy var placeField: EnrollField = {
        let field = EnrollField()
        
        field.delegate = self
        
        return field
    }()
    
    // MARK: Category
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "카테고리"
        label.font = .pretendard(size: 16, weight: .semibold)
        
        return label
    }()
    
    private lazy var restaurantButton = CategoryButton()
    private lazy var cafeButton = CategoryButton()
    private lazy var bakeryButton = CategoryButton()
    private lazy var barButton = CategoryButton()
    
    private lazy var buttonStackView = UIStackView()
    
    // 공통된 button action 작업을 위해 배열화
    private lazy var categoryButtons = [CategoryButton]()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var afterChangedTitle: ((String) -> Void)?
    var afterChangedCategory: ((PlaceCategory) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setViewHeight()
    }
    
    private func makeLayout() {
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        viewHeightConstraint?.isActive = true
        
        [
            placeLabel,
            placeField,
            categoryLabel,
            buttonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            placeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            placeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            placeField.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 15),
            placeField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            placeField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            categoryLabel.topAnchor.constraint(equalTo: placeField.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            buttonStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        makeButtonStackViewLayout()
    }
    
    private func makeButtonStackViewLayout() {
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
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray7
        
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
        
        categoryButtons.forEach {
            $0.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private func setViewHeight() {
        let placeLabelHeight = placeLabel.frame.height
        let placeFieldHeight = placeField.frame.height
        let categoryLabelHeight = categoryLabel.frame.height
        let buttonStackViewHeight = buttonStackView.frame.height
        
        // 20 * 3 15 * 2
        let inset: CGFloat = 90
        
        let totalHeight = placeLabelHeight + placeFieldHeight + categoryLabelHeight + buttonStackViewHeight + inset
                
        viewHeightConstraint?.constant = totalHeight
    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        for button in categoryButtons {
            button.isSelected = (button == sender)
        }
        
        var selectedCategory: PlaceCategory?
        if sender == restaurantButton {
            selectedCategory = .restaurant
        } else if sender == cafeButton {
            selectedCategory = .cafe
        } else if sender == bakeryButton {
            selectedCategory = .bakery
        } else if sender == barButton {
            selectedCategory = .bar
        }
        
        if let category = selectedCategory {
            afterChangedCategory?(category)
        }
    }
        
    func dataBinding(title: String, category: String) {
        self.placeField.text = title
        
        if let category = PlaceCategory(title: category) {
            switch category {
            case .bakery:
                bakeryButton.isSelected.toggle()
            case .bar:
                barButton.isSelected.toggle()
            case .cafe:
                cafeButton.isSelected.toggle()
            case .restaurant:
                restaurantButton.isSelected.toggle()
            }
        }
    }
}

extension EditLocationTopView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let title = textField.text else { return }
        afterChangedTitle?(title)
    }
}
