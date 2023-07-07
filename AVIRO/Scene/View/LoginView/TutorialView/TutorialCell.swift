//
//  TutorialCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/06.
//

import UIKit

final class TutorialCell: UICollectionViewCell {
    static let identifier = "TutorialCell"
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        [
            titleLabel,
            subTitleLabel,
            imageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // titleLagel
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // subTitleLabel
            subTitleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -60),
            subTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // imageView
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.8),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.6)
        ])
    }
    
    private func makeAttribute() {
        // title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        // subtitle 
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subTitleLabel.numberOfLines = 3
        subTitleLabel.textAlignment = .center
        
        // image
        imageView.backgroundColor = .darkGray
    }
    
    func setupData(title: String, subTitle: String, image: UIImage?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        imageView.image = image 
    }
}
