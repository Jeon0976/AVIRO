//
//  VeganMenuTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/25.
//

import UIKit

final class VeganMenuTableViewCell: UITableViewCell {
    static let identifier = "VeganMenu"
    
    var menuTextField = InrollTextField()
    var priceTextField = InrollTextField()
    var textFieldStackView = UIStackView()
    
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
        
        menuTextField.removeTarget(nil, action: nil, for: .allEvents)
        priceTextField.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    private func makeLayout() {
        [
            menuTextField,
            priceTextField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            textFieldStackView.addArrangedSubview($0)
        }
        
        textFieldStackView.axis = .horizontal
        textFieldStackView.spacing = 12
        textFieldStackView.distribution = .fillEqually
        
        [
            textFieldStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            textFieldStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func makeAttribute() {
        menuTextField.placeholder = "메뉴"
        menuTextField.textColor = .mainTitle
        
        priceTextField.placeholder = "가격"
        priceTextField.textColor = .mainTitle
    }
    
    func dataBinding(_ name: String, _ price: String) {
        menuTextField.text = name
        priceTextField.text = price
    }
}
