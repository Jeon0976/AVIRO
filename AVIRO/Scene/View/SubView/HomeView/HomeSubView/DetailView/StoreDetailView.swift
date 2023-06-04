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
        label.font = .systemFont(ofSize: 18, weight: .bold)
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
        label.font = .systemFont(ofSize: 15)
        label.textColor = .mainTitle
        label.numberOfLines = 0
        
        return label
    }()
    
    let firstSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
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
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .mainTitle
        label.numberOfLines = 0

        return label
    }()
    
    let secondSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
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
        
        label.font = .systemFont(ofSize: 15)
        label.textColor = .mainTitle
        label.numberOfLines = 0

        return label
    }()
    
    let thridSeparator: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        view.layer.cornerRadius = 2.5
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()

    let requestDelete: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = .systemFont(ofSize: 14)
        label.text = "식당 정보 오류 및 삭제 요청"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
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
            storeDetailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            storeDetailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // addressIcon
            addressIcon.topAnchor.constraint(equalTo: storeDetailLabel.bottomAnchor, constant: 30),
            addressIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            // addressLabel
            addressLabel.centerYAnchor.constraint(equalTo: addressIcon.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 10),
            
            // firstSeperator
            firstSeparator.topAnchor.constraint(equalTo: addressIcon.bottomAnchor, constant: 10),
            firstSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            firstSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // phoneIcon
            phoneIcon.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 10),
            phoneIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            // phoneLabel
            phoneLabel.centerYAnchor.constraint(equalTo: phoneIcon.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneIcon.trailingAnchor, constant: 10),
            
            // secondSeparator
            secondSeparator.topAnchor.constraint(equalTo: phoneIcon.bottomAnchor, constant: 10),
            secondSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            secondSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // categoryIcon
            categoryIcon.topAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: 10),
            categoryIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            // categoryLabel
            categoryLabel.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 10),
            
            // thridSeparator
            thridSeparator.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 10),
            thridSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            thridSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // delete
            requestDelete.topAnchor.constraint(equalTo: thridSeparator.bottomAnchor, constant: 10),
            requestDelete.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
