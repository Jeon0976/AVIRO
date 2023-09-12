//
//  PlaceListCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListCell: UITableViewCell {
    static let identifier = "PlaceListCell"
    
    private lazy var icon = UIImageView()
    private lazy var title = UILabel()
    private lazy var address = UILabel()
    private lazy var distance = UILabel()
    
    // MARK: 최초 불러드릴 때 작업
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    private func makeLayout() {
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
    private func makeAttribute() {
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 18, weight: .medium)
        
        address.numberOfLines = 0
        address.font = .systemFont(ofSize: 15, weight: .medium)
                
        distance.font = .systemFont(ofSize: 14, weight: .medium)
        distance.textAlignment = .right
        
        title.textColor = .gray0
        address.textColor = .gray3
        distance.textColor = .gray2
        
        icon.image = UIImage(named: "ListCellIcon")?.withRenderingMode(.alwaysTemplate)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .gray4
    }
    
    // MARK: cell data 바인딩
    
    func makeCellData(_ listData: PlaceListCellModel,
                      attributedTitle: NSAttributedString?,
                      attributedAddress: NSAttributedString?
    ) {
        title.attributedText = attributedTitle ?? NSAttributedString(string: listData.title)
        address.attributedText = attributedAddress ?? NSAttributedString(string: listData.address)
        distance.text = listData.distance.convertDistanceUnit()
    }
}
