//
//  RequestTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/26.
//

import UIKit

enum RequestTableCellSection {
    case main
}

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
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        editingMenuField = nil
        editingPriceField = nil
        editingRequestField = nil
        onMinusButtonTapped = nil
        onRequestButtonTapped = nil
        priceField.variablePriceChanged = nil
    }

    // MARK: Set Data
    func setData(menu: String, price: String, request: String, isSelected: Bool, isEnabled: Bool) {
        menuField.text = menu
        priceField.text = price
        requestField.text = request
        requestField.isEnabled = isSelected
        requestCheckButton.isSelected = isSelected
        requestCheckButton.isUserInteractionEnabled = isEnabled
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
            requestCheckButton.heightAnchor.constraint(equalToConstant: 24),
            requestCheckButton.widthAnchor.constraint(equalToConstant: 24),
            
            // requestField
            requestField.topAnchor.constraint(equalTo: fieldStackView.bottomAnchor, constant: 10),
            requestField.leadingAnchor.constraint(equalTo: requestCheckButton.trailingAnchor, constant: 7),
            requestField.trailingAnchor.constraint(equalTo: fieldStackView.trailingAnchor),
            requestField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // minus Button
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
        priceField.variablePriceChanged = { [weak self] text in
            self?.editingPriceField?(text)
        }
        
        requestField.makePlaceHolder("계란 빼달라고 요청하기")
        requestField.delegate = self
        
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
    
    // MARK: Minus Button Tapped
    @objc func minusButtonTapped() {
        onMinusButtonTapped?()
    }
    
    // MARK: Active Request Field Button Tapped
    @objc func requestCheckButtonTapped() {
        requestCheckButton.isSelected.toggle()
        
        if requestCheckButton.isSelected {
            requestField.isEnabled = true
            onRequestButtonTapped?(true)
        } else {
            requestField.isEnabled = false
            onRequestButtonTapped?(false)
        }
    }
}

extension RequestTableViewCell: UITextFieldDelegate {
    // MARK: price field 로직
    /// 변동일 땐 입력 금지, 숫자 데이터 입력 받을 때 3번째 차리 ',' 추가
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        if textField == priceField {
            if textField.text == "변동가" {
                return false
            } else if let result = textField.text, let textRange = Range(range, in: result) {
                let updateText = result.replacingCharacters(in: textRange, with: string)
                textField.text = updateText.formatNumber()
                return false
            }
        }
        return true
    }
    
    // MARK: Text 입력 되고 난 후 실시간
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == menuField {
            editingMenuField?(textField.text ?? "")
        } else if textField == priceField {
            editingPriceField?(textField.text ?? "")
        } else if textField == requestField {
            editingRequestField?(textField.text ?? "")
        }
    }
}
