//
//  RequestTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/26.
//

import UIKit

final class RequestTableViewCell: UITableViewCell {
    static let identifier = "RequestTable"
    
    var menuField = MenuField()
    var priceField = MenuField()
    var fieldStackView = UIStackView()
    
    var requestCheckButton = UIButton()
    var requestField = MenuField()
    var minusButton = UIButton()
    
    var editingMenuField: ((String) -> Void)?
    var editingPriceField: ((String) -> Void)?
    var editingRequestField: ((String) -> Void)?
    var onRequestButtonTapped: ((Bool) -> Void)?
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
        
        menuField.removeTarget(nil, action: nil, for: .allEvents)
        priceField.removeTarget(nil, action: nil, for: .allEvents)
        minusButton.removeTarget(nil, action: nil, for: .allEvents)
        requestCheckButton.removeTarget(nil, action: nil, for: .allEvents)

    }
    
    private func makeLayout() {
        self.contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
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
            minusButton,
            requestField,
            requestCheckButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // field Stack View
            fieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            fieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            fieldStackView.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -7),
            fieldStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1, constant: -31),
            
            // requestCheckButton
            requestCheckButton.centerYAnchor.constraint(equalTo: requestField.centerYAnchor),
            requestCheckButton.leadingAnchor.constraint(equalTo: fieldStackView.leadingAnchor),
            
            // requestField
            requestField.topAnchor.constraint(equalTo: fieldStackView.bottomAnchor, constant: 10),
            requestField.leadingAnchor.constraint(equalTo: requestCheckButton.trailingAnchor, constant: 7),
            requestField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor),
            
            // minus Button
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        
        menuField.makePlaceHolder("메뉴 이름")
        menuField.delegate = self
        
        priceField.makePlaceHolder("가격")
        priceField.addRightButton()
        priceField.keyboardType = .numberPad
        priceField.delegate = self
        
        requestField.makePlaceHolder("계란 빼달라고 요청하기")
        requestField.isEnabled = false
        
        let image = UIImage(named: "Minus")?.withRenderingMode(.alwaysTemplate)
        
        minusButton.setImage(image, for: .normal)
        minusButton.tintColor = .gray2
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
        let emptyImage = UIImage(named: "EmptyFrame")
        let checkImage = UIImage(named: "RequestCheck")
        
        requestCheckButton.setImage(emptyImage, for: .normal)
        requestCheckButton.setImage(checkImage, for: .selected)
        requestCheckButton.addTarget(self, action: #selector(requestCheckButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func minusButtonTapped() {
        onMinusButtonTapped?()
        print("DD")
    }
    
    @objc func requestCheckButtonTapped() {
        requestCheckButton.isSelected.toggle()
        print("Change")

        if requestCheckButton.isSelected {
            requestField.isEnabled = true
            onRequestButtonTapped?(true)
            print("Change")
        } else {
            requestField.isEnabled = false
            onRequestButtonTapped?(false)
        }
    }
    
    func setData(menu: String, price: String, request: String) {
        menuField.text = menu
        priceField.text = price
        requestField.text = request
//        requestCheckButton.isSelected = isSelected
    }
}

extension RequestTableViewCell: UITextFieldDelegate {
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == menuField {
            editingMenuField?(textField.text ?? "")
        } else if textField == priceField {
            editingPriceField?(textField.text ?? "")
        } else {
            editingRequestField?(textField.text ?? "")
        }
    }
}
