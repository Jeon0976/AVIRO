//
//  HomeSearhViewTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewTableViewCell: UITableViewCell {
    static let identifier = "HomeSearchViewTableViewCell"
    
    var icon = UIImageView()
    var title = UILabel()
    var address = UILabel()
    var distance = UILabel()
    
    // MARK: 최초 불러드릴 때 작업
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        setupLayout()
        setupAttribute()
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
    
    // MARK: Attribute
    private func setupAttribute() {
        title.numberOfLines = 2
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.lineBreakMode = .byCharWrapping
        
        address.numberOfLines = 2
        address.font = .systemFont(ofSize: 15, weight: .medium)
        address.lineBreakMode = .byCharWrapping
                
        distance.font = .systemFont(ofSize: 14, weight: .medium)
        distance.textAlignment = .right
        
        title.textColor = .gray0
        address.textColor = .gray3
        distance.textColor = .gray2
    }
    
    // MARK: cell data 바인딩
    
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
