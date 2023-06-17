//
//  HomeSearhViewTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewTableViewCell: UITableViewCell {
    static let identifier = "HomeSearhViewTableViewCell"
    
    var icon = UIImageView()
    var title = UILabel()
    var distance = UILabel()
    var address = UILabel()
    var category = UILabel()
    
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
            icon.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Layout.Inset.leadingTopPlus),
            icon.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Layout.Inset.leadingTop),
            icon.heightAnchor.constraint(
                equalToConstant: Layout.Inset.iconInest),
            icon.widthAnchor.constraint(
                equalTo: icon.heightAnchor, multiplier: 1),
            
            // title
            title.topAnchor.constraint(
                equalTo: icon.topAnchor),
            title.leadingAnchor.constraint(
                equalTo: icon.trailingAnchor, constant: Layout.Inset.iconToLabel),

            // distance
            distance.topAnchor.constraint(
                equalTo: icon.topAnchor),
            distance.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // address
            address.topAnchor.constraint(
                equalTo: title.bottomAnchor, constant: Layout.Inset.leadingTopHalf),
            address.leadingAnchor.constraint(
                equalTo: title.leadingAnchor),
            address.trailingAnchor.constraint(
                equalTo: title.trailingAnchor),
            
            // category
            category.topAnchor.constraint(
                equalTo: address.bottomAnchor, constant: Layout.Inset.leadingTopHalf),
            category.leadingAnchor.constraint(
                equalTo: title.leadingAnchor),
            category.trailingAnchor.constraint(
                equalTo: title.trailingAnchor),
            category.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: Layout.Inset.trailingBottomPlus)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeAttribute() {
        title.numberOfLines = 0
        title.font = Layout.Label.title
        
        address.numberOfLines = 0
        address.font = Layout.Label.nomal1
        
        category.numberOfLines = 0
        category.font = Layout.Label.nomal1
        
        distance.font = Layout.Label.nomal2
        
        title.textColor = .mainTitle
        address.textColor = .mainTitle
        category.textColor = .mainTitle
        distance.textColor = .mainTitle
    }
    
    func makeCellData(_ listData: HomeSearchData) {
        makeAttribute()
        icon.image = UIImage(named: listData.icon)
        icon.contentMode = .scaleAspectFit
        
        title.text = listData.title
        address.text = listData.address
        category.text = listData.category
        distance.text = listData.distance.convertDistanceUnit()
    }
}
