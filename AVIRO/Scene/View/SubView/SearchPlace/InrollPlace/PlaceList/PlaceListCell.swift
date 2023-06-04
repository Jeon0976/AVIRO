//
//  PlaceListCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListCell: UITableViewCell {
    static let identifier = "PlaceListCell"
    
    var icon = UIImageView()
    var title = UILabel()
    var address = UILabel()
    var category = UILabel()
    var distance = UILabel()
    
    // MARK: 최초 불러드릴 때 작업
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            icon,
            title,
            address,
            category,
            distance
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // icon
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.heightAnchor.constraint(equalToConstant: 25),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor, multiplier: 1),
            
            // title
            title.topAnchor.constraint(equalTo: icon.topAnchor),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            
            // distance
            distance.topAnchor.constraint(equalTo: icon.topAnchor),
            distance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // address
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            address.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            // category
            category.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 8),
            category.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            category.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            category.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Attribute
    private func makeAttribute() {
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 18, weight: .bold)
        
        address.numberOfLines = 0
        address.font = .systemFont(ofSize: 14, weight: .medium)
        
        category.numberOfLines = 0
        category.font = .systemFont(ofSize: 14, weight: .medium)
        
        distance.font = .systemFont(ofSize: 14, weight: .light)
        
        title.textColor = .mainTitle
        address.textColor = .mainTitle
        category.textColor = .mainTitle
        distance.textColor = .mainTitle
        
        icon.image = UIImage(named: "InrollSearchIcon")
        icon.contentMode = .scaleAspectFit
    }
    
    // MARK: cell data 바인딩
    func makeCellData(_ listData: PlaceListCellModel) {
        makeAttribute()
        title.text = listData.title
        address.text = listData.address
        category.text = listData.category
        distance.text = listData.distance.convertDistanceUnit()
    }
}
