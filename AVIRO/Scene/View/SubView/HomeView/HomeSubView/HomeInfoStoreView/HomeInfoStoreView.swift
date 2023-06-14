//
//  HomeInfoStoreView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

class HomeInfoStoreView: UIView {
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 20)
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
        
        return view
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Bookmark"), for: .normal)
        button.setTitle("북마크   ", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

        button.contentHorizontalAlignment = .center

        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.setTitle("댓글     ", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)

        button.contentHorizontalAlignment = .center

        return button
    }()
    
    let separator1: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let separator2: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        stackView.spacing = 5
        
        return stackView
    }()
    
    let entireView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.alpha = 1
        
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.startAnimating()
        indicator.alpha = 1
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        self.backgroundColor = .white
        self.layer.cornerRadius = 30
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.25
        
        entireView.backgroundColor = .white
        entireView.layer.cornerRadius = 30
        entireView.layer.shadowColor = UIColor.black.cgColor
        entireView.layer.shadowOffset = CGSize(width: -2, height: -2)
        entireView.layer.shadowRadius = 4
        entireView.layer.shadowOpacity = 0.25
        
        [
            shareButton,
            separator1,
            bookmarkButton,
            separator2,
            commentButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [
            title,
            imageView,
            address,
            handleView,
            stackView,
            topImageView,
            entireView,
            activityIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            // handleView
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 5),
            
            // topImageView
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            topImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // imageView
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            // title
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3),
            
            // address
            address.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            
            // stackView
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 20),
             
            // entireView
            entireView.topAnchor.constraint(equalTo: self.topAnchor),
            entireView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            entireView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            entireView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // indicator
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
