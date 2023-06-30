//
//  storeDetailView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class StoreDetailView: UIView {
    let storeDetailLabel: UILabel = {
       let label = UILabel()
        label.text = "식당 정보"
        label.font = Layout.Label.mainTitle
        label.textColor = .mainTitle
        label.numberOfLines = 0
        
        return label
    }()
    
    let addressIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "map")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.Label.placeInfoNormal
        label.textColor = .mainTitle
        label.numberOfLines = 0
        
        return label
    }()
    
    let firstSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.Inset.separatorCornerRadius
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    let phoneIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "call")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        
        label.font = Layout.Label.placeInfoNormal
        label.textColor = .mainTitle
        label.numberOfLines = 0

        return label
    }()
    
    let secondSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.Inset.separatorCornerRadius
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()

    let categoryIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "info")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.font = Layout.Label.placeInfoNormal
        label.textColor = .mainTitle
        label.numberOfLines = 0

        return label
    }()
    
    let thridSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = Layout.Inset.separatorCornerRadius
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()

    let requestDelete: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = Layout.Label.subTitle
        label.text = "식당 정보 오류 및 삭제 요청"
        
        return label
    }()
    
    var viewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        
        [
            storeDetailLabel,
            addressIcon,
            addressLabel,
            firstSeparator,
            phoneIcon,
            phoneLabel,
            secondSeparator,
            categoryIcon,
            categoryLabel,
            thridSeparator,
            requestDelete
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // storeDetailLabel
            storeDetailLabel.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            storeDetailLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            storeDetailLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),

            // addressIcon
            addressIcon.topAnchor.constraint(
                equalTo: storeDetailLabel.bottomAnchor, constant: Layout.DetailView.iconInset),
            addressIcon.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.DetailView.iconInset),
            
            // addressLabel
            addressLabel.centerYAnchor.constraint(
                equalTo: addressIcon.centerYAnchor),
            addressLabel.leadingAnchor.constraint(
                equalTo: addressIcon.trailingAnchor, constant: Layout.DetailView.iconToSeparator),
            addressLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // firstSeperator
            firstSeparator.topAnchor.constraint(
                equalTo: addressIcon.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            firstSeparator.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            firstSeparator.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // phoneIcon
            phoneIcon.topAnchor.constraint(
                equalTo: firstSeparator.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            phoneIcon.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.DetailView.iconInset),
            
            // phoneLabel
            phoneLabel.centerYAnchor.constraint(
                equalTo: phoneIcon.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(
                equalTo: phoneIcon.trailingAnchor, constant: Layout.DetailView.iconToSeparator),
            
            // secondSeparator
            secondSeparator.topAnchor.constraint(
                equalTo: phoneIcon.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            secondSeparator.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            secondSeparator.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // categoryIcon
            categoryIcon.topAnchor.constraint(
                equalTo: secondSeparator.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            categoryIcon.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.DetailView.iconInset),
            
            // categoryLabel
            categoryLabel.centerYAnchor.constraint(
                equalTo: categoryIcon.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(
                equalTo: categoryIcon.trailingAnchor, constant: Layout.DetailView.iconToSeparator),
            categoryLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),

            // thridSeparator
            thridSeparator.topAnchor.constraint(
                equalTo: categoryIcon.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            thridSeparator.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            thridSeparator.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // delete
            requestDelete.topAnchor.constraint(
                equalTo: thridSeparator.bottomAnchor, constant: Layout.DetailView.iconToSeparator),
            requestDelete.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let storeDetailHeight = storeDetailLabel.frame.height
        let addressHeight = addressLabel.frame.height
        let phoneHeight = phoneIcon.frame.height
        let categoryHeight = categoryLabel.frame.height
        let requestDeleteHeight = requestDelete.frame.height
        
        let totalHeight =
            storeDetailHeight +
            addressHeight +
            phoneHeight +
            categoryHeight +
            requestDeleteHeight +
            Layout.DetailView.storeDetailInset
        
        viewHeightConstraint?.constant = totalHeight
    }
}
