//
//  HomeSearhViewTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewTableViewCell: UITableViewCell {
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = CFont.font.medium18
        label.textColor = .gray0

        return label
    }()
    
    private lazy var address: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = CFont.font.regular15
        label.textColor = .gray3

        return label
    }()
    
    private lazy var distance: UILabel = {
        let label = UILabel()
        
        label.font = CFont.font.regular14
        label.textColor = .gray2
        label.textAlignment = .right

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        
        [
            icon,
            title,
            address,
            distance
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: distance.leadingAnchor, constant: -20),
            title.topAnchor.constraint(equalTo: icon.topAnchor),
            
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 11),
            address.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            address.trailingAnchor.constraint(equalTo: distance.leadingAnchor, constant: -20),

            distance.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            distance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupCellData(
        _ listData: MatchedPlaceCellModel,
        attributedTitle: NSAttributedString?,
        attributedAddress: NSAttributedString?
    ) {
        
        icon.image = listData.icon
        title.attributedText = attributedTitle ?? NSAttributedString(string: listData.title)
        address.attributedText = attributedAddress ?? NSAttributedString(string: listData.address)
        distance.text = listData.distance.convertDistanceUnit()
    }
}
