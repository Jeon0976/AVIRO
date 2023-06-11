//
//  HomeFirstPopUpView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//
import UIKit

class HomeFirstPopUpView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bigGilraim")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .plusButton
        button.setTitle("비건 식당 제보하러가기", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = 28
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.backgroundColor = .white
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 20
        
        [
            imageView,
            cancelButton,
            reportButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // imageView
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: reportButton.topAnchor, constant: -10),
            
            // cancelButton
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            reportButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            reportButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reportButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
