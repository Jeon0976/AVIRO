//
//  PlaceReviewWriteView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceReviewWriteView: UIView {
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage.enrollCharacter
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        let userId = MyData.my.nickname
        label.text = userId + "님의 후기를 들려주세요!"
        label.font = .pretendard(size: 17, weight: .semibold)
        label.textColor = .gray0
        label.textAlignment = .center
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var writeReviewButton: ReviewWriteButton = {
        let button = ReviewWriteButton()
        
        button.setButton()
        button.addTarget(self, action: #selector(writeReviewButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func writeReviewButtonTapped() {
        whenWriteReviewButtonTapped?()
    }
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var whenWriteReviewButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        makeViewHeight()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        
        [
            mainImage,
            title,
            writeReviewButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 375)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            mainImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            writeReviewButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            writeReviewButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            writeReviewButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func makeViewHeight() {
        let mainImageHeight = mainImage.frame.height
        let titleHeight = title.frame.height
        let writeReviewButtonHeight = writeReviewButton.frame.height
        
        // 30 20 20 30
        let inset: CGFloat = 100
        
        let totalHeight = mainImageHeight + titleHeight + writeReviewButtonHeight + inset
        
        viewHeightConstraint?.constant = totalHeight
    }
}
