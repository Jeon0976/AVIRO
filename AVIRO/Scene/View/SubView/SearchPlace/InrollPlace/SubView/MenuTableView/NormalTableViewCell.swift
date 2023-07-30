//
//  NormalTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/26.
//

import UIKit

final class NormalTableViewCell: UITableViewCell {
    static let identifier = "NormalTable"
    
    var menuField = MenuField()
    var priceField = MenuField()
    var fieldStackView = UIStackView()
    var minusButton = UIButton()
    
    var editingMenuField: ((String) -> Void)?
    var editingPriceField: ((String) -> Void)?
    var onMinusButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        editingMenuField = nil
        editingPriceField = nil
        onMinusButtonTapped = nil
        priceField.variblePriceChanged = nil
    }
    
    // MARK: Set Data
    func setData(menu: String, price: String) {
        menuField.text = menu
        priceField.text = price
    }
    
    // MARK: Layout
    private func makeLayout() {
        [
            menuField,
            priceField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            fieldStackView.addArrangedSubview($0)
        }
        
        fieldStackView.axis = .horizontal
        fieldStackView.spacing = 7
        fieldStackView.distribution = .fillEqually
        
        [
            fieldStackView,
            minusButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // FieldStackView
            fieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fieldStackView.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -7),
            fieldStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1, constant: -31),
            fieldStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // minusButton
            minusButton.centerYAnchor.constraint(equalTo: fieldStackView.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        self.backgroundColor = .gray7
        
        menuField.makePlaceHolder("메뉴 이름")
        menuField.delegate = self
        
        priceField.makePlaceHolder("가격")
        priceField.addRightButton()
        priceField.keyboardType = .numberPad
        priceField.delegate = self
        
        let image = UIImage(named: "Minus")?.withRenderingMode(.alwaysTemplate)
        minusButton.setImage(image, for: .normal)
        minusButton.tintColor = .gray2
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Minus Button Tapped
    @objc func minusButtonTapped() {
        onMinusButtonTapped?()
    }
}

extension NormalTableViewCell: UITextFieldDelegate {
    // MARK: price field 로직
    /// 변동일 땐 입력 금지, 숫자 데이터 입력 받을 때 3번째 차리 ',' 추가
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        if textField == priceField {
            if textField.text == "변동" {
                textField.endEditing(true)
                return false
            } else if let result = textField.text, let textRange = Range(range, in: result) {
                let updateText = result.replacingCharacters(in: textRange, with: string)
                textField.text = updateText.formatNumber()
                return false
            }
        }
        return true
    }
    
    // MARK: Text 입력 되고 난 후
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == menuField {
            editingMenuField?(textField.text ?? "")
        } else {
            editingPriceField?(textField.text ?? "")
        }
    }
}
