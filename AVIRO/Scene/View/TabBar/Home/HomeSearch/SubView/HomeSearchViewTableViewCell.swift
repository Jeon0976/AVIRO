//
//  HomeSearhViewTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewTableViewCell: UITableViewCell {
    static let identifier = "HomeSearchViewTableViewCell"
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .pretendard(size: 18, weight: .medium)
        label.textColor = .gray0

        return label
    }()
    
    private lazy var address: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .pretendard(size: 15, weight: .regular)
        label.textColor = .gray3

        return label
    }()
    
    private lazy var distance: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 14, weight: .regular)
        label.textAlignment = .right
        label.textColor = .gray2
        
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
            // icon
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            // title
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: icon.topAnchor),
            title.trailingAnchor.constraint(equalTo: distance.leadingAnchor, constant: -20),
            
            // address
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 11),
            address.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            address.trailingAnchor.constraint(equalTo: distance.leadingAnchor, constant: -20),
            
            // distance
            distance.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            distance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func makeCellData(_ listData: MatchedPlaceListCell,
                      attributedTitle: NSAttributedString?,
                      attributedAddress: NSAttributedString?
    ) {
        icon.image = listData.icon
        title.attributedText = attributedTitle ?? NSAttributedString(string: listData.title)
        address.attributedText = attributedAddress ?? NSAttributedString(string: listData.address)
        distance.text = listData.distance.convertDistanceUnit()
    }
}
