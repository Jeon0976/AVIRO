//
//  PlaceListCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListCell: UITableViewCell {
    static let identifier = "PlaceListCell"
    
    var title = UILabel()
    var address = UILabel()
    var category = UILabel()
    var distance = UILabel()
    
    var itemInView = UIView()
    var emptyView = UIView()
    
    // MARK: 최초 불러드릴 때 작업
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            title,
            address,
            category,
            distance
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            itemInView.addSubview($0)
        }
        
        [
            itemInView,
            emptyView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        itemInView.layer.cornerRadius = 16
        itemInView.backgroundColor = .white
        
        emptyView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            // itemInView
            itemInView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemInView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemInView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemInView.bottomAnchor.constraint(equalTo: emptyView.topAnchor),
            
            // emptyView
            emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 16),
            
            // title
            title.topAnchor.constraint(equalTo: itemInView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: itemInView.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: distance.trailingAnchor, constant: -16),
            
            // address
            address.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            address.leadingAnchor.constraint(equalTo: itemInView.leadingAnchor, constant: 16),
            address.trailingAnchor.constraint(equalTo: itemInView.trailingAnchor, constant: -16),
            
            // category
            category.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 8),
            category.leadingAnchor.constraint(equalTo: itemInView.leadingAnchor, constant: 16),
            category.trailingAnchor.constraint(equalTo: itemInView.trailingAnchor, constant: -16),
            category.bottomAnchor.constraint(equalTo: itemInView.bottomAnchor, constant: -8),
            
            // distance
            distance.topAnchor.constraint(equalTo: title.topAnchor),
            distance.trailingAnchor.constraint(equalTo: itemInView.trailingAnchor, constant: -16)
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
