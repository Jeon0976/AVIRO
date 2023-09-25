//
//  TutorialCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/06.
//

import UIKit

final class BottomCell: UICollectionViewCell {
    static let identifier = "BottomCell"

    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            imageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func makeAttribute() {        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    func setupData(image: UIImage?) {
        imageView.image = image
    }
}
