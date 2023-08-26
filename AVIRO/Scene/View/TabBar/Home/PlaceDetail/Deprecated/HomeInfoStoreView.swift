//
//  HomeInfoStoreView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

class HomeInfoStoreView: UIView {
    
    var placeId: String?
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .mainTitle
        label.font = .systemFont(
            ofSize: CGFloat(Layout.SlideView.titleFont),
            weight: .bold
        )
        
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
        label.font = .systemFont(
            ofSize: CGFloat(Layout.SlideView.addressFont)
        )
        
        return label
    }()
    
    let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.SlideView.lineCornerRadius
        
        return view
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: Image.share), for: .normal)
        button.setTitle(StringValue.HomeView.share, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = Layout.SlideView.imageToTextInset

        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: Image.bookmark), for: .normal)
        button.setTitle(StringValue.HomeView.bookmark, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = Layout.SlideView.imageToTextInset

        button.contentHorizontalAlignment = .center

        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: Image.comment), for: .normal)
        button.setTitle(StringValue.HomeView.comments, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = Layout.SlideView.imageToTextInset

        button.contentHorizontalAlignment = .center

        return button
    }()
    
    let separator1: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.SlideView.lineCornerRadius
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let separator2: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.SlideView.lineCornerRadius
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        stackView.spacing = Layout.Inset.buttonStackViewSpacing
        
        return stackView
    }()
    
    let entireView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.alpha = 1
        
        view.layer.cornerRadius = CGFloat(Layout.SlideView.cornerRadius)
        view.layer.shadowColor = Layout.SlideView.shadowColor
        view.layer.shadowOffset = Layout.SlideView.shadowOffset
        view.layer.shadowRadius = CGFloat(Layout.SlideView.shadowRadius)
        view.layer.shadowOpacity = Float(Layout.SlideView.shadowOpacity)
        
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
        
        self.layer.cornerRadius = CGFloat(Layout.SlideView.cornerRadius)
        self.layer.shadowColor = Layout.SlideView.shadowColor
        self.layer.shadowOffset = Layout.SlideView.shadowOffset
        self.layer.shadowRadius = CGFloat(Layout.SlideView.shadowRadius)
        self.layer.shadowOpacity = Float(Layout.SlideView.shadowOpacity)
        
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
            handleView.topAnchor.constraint(equalTo: self.topAnchor, constant: Layout.Inset.leadingTopHalf),
            handleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 40),
            handleView.heightAnchor.constraint(equalToConstant: 5),
            
            // topImageView
            topImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Layout.Inset.leadingTop),
            topImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            
            // imageView
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            
            // title
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Layout.Inset.leadingTopSmall),
            
            // address
            address.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Layout.Inset.leadingTopHalf),
            
            // stackView
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            stackView.topAnchor.constraint(equalTo: address.bottomAnchor, constant: Layout.Inset.leadingTopPlus),
             
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
