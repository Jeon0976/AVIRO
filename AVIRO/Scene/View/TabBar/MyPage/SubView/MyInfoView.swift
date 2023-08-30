//
//  MyInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/29.
//

import UIKit

final class MyInfoView: UIView {
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .gray5
        imageView.layer.cornerRadius = 40
        
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
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func makeLayout() {
        // TODO: 임시
        self.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        [
            userImage
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            userImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImage.heightAnchor.constraint(equalToConstant: 80),
            userImage.widthAnchor.constraint(equalToConstant: 80
                                            )
        ])
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
    }
}
