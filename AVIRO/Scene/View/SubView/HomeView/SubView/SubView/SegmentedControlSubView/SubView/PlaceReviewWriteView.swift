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
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var writeReviewButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var showMoreMenuButton: ShowMoreButton = {
        let button = ShowMoreButton()
        
        button.setButton("메뉴 더보기")
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func makeLayout() {
        
    }
}
