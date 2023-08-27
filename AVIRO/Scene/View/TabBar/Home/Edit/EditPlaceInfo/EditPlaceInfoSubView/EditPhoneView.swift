//
//  EditPhoneView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditPhoneView: UIView {
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "가게 번호"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    private lazy var phoneField: EnrollField = {
        let field = EnrollField()
        
        let placeHolder = "대표 전화번호를 입력해주세요."
        
        field.makePlaceHolder(placeHolder)
        field.keyboardType = .numbersAndPunctuation
        
        return field
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setViewHeight()
    }
    
    private func makeLayout() {
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        viewHeightConstraint?.isActive = true
        
        [
            phoneLabel,
            phoneField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            phoneField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 15),
            phoneField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            phoneField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray7
    }
    
    private func setViewHeight() {
        let placeLabelHeight = phoneLabel.frame.height
        let placeFieldHeight = phoneField.frame.height
        // 20 * 2 15 * 1
        let inset: CGFloat = 55
        
        let totalHeight = placeLabelHeight + placeFieldHeight + inset
                
        viewHeightConstraint?.constant = totalHeight
    }
    
    func dataBinding(_ phone: String) {
        self.phoneField.text = phone
    }
}
