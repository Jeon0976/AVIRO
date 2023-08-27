//
//  EditHomePageView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditHomePageView: UIView {
    private lazy var homepageLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "홈페이지"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    private lazy var homepageField: EnrollField = {
        let field = EnrollField()
        
        let placeHolder = "대표 홈페이지 링크를 입력해주세요."
        
        field.makePlaceHolder(placeHolder)
        field.keyboardType = .URL
        
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
            homepageLabel,
            homepageField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            homepageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            homepageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            homepageField.topAnchor.constraint(equalTo: homepageLabel.bottomAnchor, constant: 15),
            homepageField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            homepageField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray7
    }
    
    private func setViewHeight() {
        let homepageLabelHeight = homepageLabel.frame.height
        let homepageFieldHeight = homepageField.frame.height
        // 20 * 2 15 * 1
        let inset: CGFloat = 55
        
        let totalHeight = homepageLabelHeight + homepageFieldHeight + inset
                
        viewHeightConstraint?.constant = totalHeight
    }
    
    func dataBinding(_ homePage: String) {
        homepageField.text = homePage
    }
}
