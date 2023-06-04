//
//  topDetailView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class TopDetailView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = .systemFont(ofSize: 18)
        
        return label
    }()
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
        
    let shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Bookmark"), for: .normal)
        button.setTitle("북마크   ", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.textColor = .black
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.setTitle("댓글     ", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.titleLabel?.textColor = .black
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

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
    
    var viewHeight = CGFloat()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
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
            stackView,
            topImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // imageView
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            // topImageView
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            topImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // title
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            // address
            address.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            
            // stackView
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
