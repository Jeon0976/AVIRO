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
        label.font = Layout.Label.bigTitile
        label.numberOfLines = 0
        
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = Layout.Label.bigNormal
        label.numberOfLines = 0
        
        return label
    }()
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
        
    let shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: Image.share), for: .normal)
        button.setTitle(StringValue.HomeView.share, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = Layout.SlideView.imageToTextInset

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

        return button
    }()
    
    let separator1: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.Inset.separatorCornerRadius
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let separator2: UIView = {
        let view = UIView()
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.Inset.separatorCornerRadius
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
    
    var viewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        
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
            imageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            
            // topImageView
            topImageView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTop),
            topImageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            
            // title
            title.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            title.topAnchor.constraint(
                equalTo: imageView.bottomAnchor, constant: Layout.Inset.leadingTopPlus),
            
            // address
            address.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            address.topAnchor.constraint(
                equalTo: title.bottomAnchor, constant: Layout.Inset.leadingTopHalf),
            
            // stackView
            stackView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            stackView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            stackView.topAnchor.constraint(
                equalTo: address.bottomAnchor, constant: Layout.Inset.leadingTop)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        viewHeightConstraint?.constant =
            imageView.frame.height +
            title.frame.height +
            address.frame.height +
            stackView.frame.height +
            Layout.DetailView.fisrtViewHeightInset
    }
}
