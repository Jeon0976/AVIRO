//
//  NoHistoryLabelView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.
//

import UIKit

final class NoHistoryLabelView: UIView {
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = CFont.font.medium14
        label.textColor = .gray3
        
        return label
    }()
    
    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.font = CFont.font.bold16
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViewHeight()
    }
    
    private func setupLayout() {
        [
            topLabel,
            bottomLabel,
            iconImage
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 100)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            iconImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            topLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            
            bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 6),
            bottomLabel.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor)
        ])
    }
    
    private func setupViewHeight() {
        let topHeight = topLabel.frame.height
        let bottomHeight = bottomLabel.frame.height
        // 15 + 15 + 6
        let padding: CGFloat = 36
        
        let totalHeight = topHeight + bottomHeight + padding
        
        viewHeightConstraint?.constant = totalHeight
    }
    
    func setupData(
        topText: String,
        bottomText: String,
        icon: UIImage
    ) {
        topLabel.text = topText
        bottomLabel.text = bottomText
        iconImage.image = icon
    }
}
