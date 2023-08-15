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
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            
            // title
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: icon.topAnchor),
            title.widthAnchor.constraint(equalToConstant: contentView.frame.width - 125),
            // address
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 11),
            address.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            address.widthAnchor.constraint(equalTo: title.widthAnchor, multiplier: 1),
            
            // distance
            distance.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            distance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

        ])
        
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        
        address.numberOfLines = 0
        address.font = .systemFont(ofSize: 15, weight: .medium)
                
        distance.font = .systemFont(ofSize: 14, weight: .medium)
        distance.textAlignment = .right
        
        title.textColor = .gray0
        address.textColor = .gray3
        distance.textColor = .gray3
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
