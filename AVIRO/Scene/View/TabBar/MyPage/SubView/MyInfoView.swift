//
//  MyInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/29.
//

import UIKit

final class MyInfoView: UIView {
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var nicnameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var editNicname: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var placeCheckButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var reviewCheckButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var starCheckButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var checkButtonStackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
