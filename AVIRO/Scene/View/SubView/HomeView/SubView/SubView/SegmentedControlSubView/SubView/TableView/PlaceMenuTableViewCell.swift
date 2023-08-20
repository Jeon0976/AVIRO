//
//  PlaceMenuTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class PlaceMenuTableViewCell: UITableViewCell {
    static let identifier = "PlaceMenuTableViewCell"
    
    private lazy var menuTypeLabel: MenuTypeLabel = {
        let label = MenuTypeLabel()
        
        return label
    }()
    
    private lazy var menuTitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 1
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var menuPrice: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var menuRequest: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray1
        label.numberOfLines = 2
//        label.
        
        return label
    }()
    
    private var menuPriceBottomConstraint: NSLayoutConstraint?
    private var menuRequestBottomConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            menuTypeLabel,
            menuTitle,
            menuPrice,
            menuRequest
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            menuTypeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            menuTypeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            
            menuTitle.topAnchor.constraint(equalTo: menuTypeLabel.bottomAnchor, constant: 10),
            menuTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            menuTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            menuPrice.topAnchor.constraint(equalTo: menuTitle.bottomAnchor, constant: 10),
            menuPrice.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            menuPrice.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            menuRequest.topAnchor.constraint(equalTo: menuPrice.bottomAnchor, constant: 10),
            menuRequest.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            menuRequest.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        menuPriceBottomConstraint = menuPrice.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        menuPriceBottomConstraint?.isActive = true
        
        menuRequestBottomConstraint =  menuRequest.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        menuRequestBottomConstraint?.isActive = false
        
        menuRequest.isHidden = true
    }
    
    func dataBinding(_ menu: MenuArray) {
        var type: MenuType?
        
        if menu.menuType == MenuType.vegan.rawValue {
            type = MenuType.vegan
        } else {
            type = MenuType.needToRequset
        }
        
        menuTypeLabel.type = type ?? MenuType.vegan
        menuTitle.text = menu.menu
        menuPrice.text = menu.price
        
        if menu.isCheck {
            menuRequest.isHidden = false
            menuRequest.text = menu.howToRequest
            
            menuPriceBottomConstraint?.isActive = false
            menuRequestBottomConstraint?.isActive = true
        } else {
            menuRequest.isHidden = true
            menuRequest.text = nil
            
            menuRequestBottomConstraint?.isActive = false
            menuPriceBottomConstraint?.isActive = true
        }
    }
    
}
