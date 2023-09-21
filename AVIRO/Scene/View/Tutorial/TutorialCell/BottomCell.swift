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
            // imageView
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentView.frame.height - 100),
            imageView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 100)
        ])
    }
    
    private func makeAttribute() {
        imageView.backgroundColor = .gray5
        imageView.clipsToBounds = false
        
    }
    
    // TODO: Image 들어올 때 image nil값 처리
    // TODO: image 생성되면 수정 코드
    func setupData(image: UIImage?) {
        imageView.image = image
    }
}
