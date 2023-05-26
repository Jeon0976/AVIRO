//
//  HomeInfoStoreView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

class HomeInfoStoreView: UIView {
     
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // 이것을 빼먹지 마세요! AutoLayout을 사용하려면 필요합니다.
        label.text = "Hello, world!"
        label.textColor = .black
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // 이것을 빼먹지 마세요! AutoLayout을 사용하려면 필요합니다.
        imageView.image = UIImage(named: "YourImageName")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        self.layer.cornerRadius = 10
        
        [
            label,
            imageView
        ].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
