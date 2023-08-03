//
//  MenuTableView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class MenuTableView: UIView {
    let title: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "메뉴 등록하기"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray2
        label.text = "어떤 메뉴를 판매하나요? 1개 이상 등록해주세요."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        
        return label
    }()
    
    let normalTableView = UITableView()
    let requestTableView = UITableView()
    
    let menuPlusButton = MenuPlusButton()

    // MARK: Constraint 조절
    var menuPlusButtonTopConstraint: NSLayoutConstraint?
    var normalTableViewHeight: NSLayoutConstraint? // default 45
    var requestTableViewHeight: NSLayoutConstraint? // default 100
    var viewHeightConstraint: NSLayoutConstraint?
    
    var initialView = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if initialView {
            initViewHeight()
            
            initialView = !initialView
        }
    }
    
    func initViewHeight() {
        let titleHeight = title.frame.height
        let subTitleHeight = subTitle.frame.height
        let normalHeight = normalTableView.frame.height
        let buttonHeight = menuPlusButton.frame.height
        // 20, 7, 20, 20, 30
        let paddingValues: CGFloat = 97
        
        let totalHeight = titleHeight + subTitleHeight + normalHeight + buttonHeight + paddingValues
        
        viewHeightConstraint?.constant = totalHeight
    }
        
    private func makeLayout() {
        [
            title,
            subTitle,
            normalTableView,
            requestTableView,
            menuPlusButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: self.frame.height)
        viewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // subtitle
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            subTitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            
            // normalTableView
            normalTableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 20),
            normalTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            normalTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // requestTableView
            requestTableView.topAnchor.constraint(equalTo: normalTableView.topAnchor),
            requestTableView.leadingAnchor.constraint(equalTo: normalTableView.leadingAnchor),
            requestTableView.trailingAnchor.constraint(equalTo: normalTableView.trailingAnchor),
            
            // menuPlusButton
            menuPlusButton.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            menuPlusButton.trailingAnchor.constraint(equalTo: normalTableView.trailingAnchor),
            menuPlusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
        
        normalTableViewHeight = normalTableView.heightAnchor.constraint(equalToConstant: 55)
        normalTableViewHeight?.isActive = true
        
        requestTableViewHeight = requestTableView.heightAnchor.constraint(equalToConstant: 110)
        requestTableViewHeight?.isActive = true
        
    }
    
    private func makeAttribute() {
        normalTableView.register(
            NormalTableViewCell.self,
            forCellReuseIdentifier: NormalTableViewCell.identifier
        )
    
        normalTableView.separatorStyle = .none
        normalTableView.tag = 0
        normalTableView.isScrollEnabled = false
        normalTableView.isHidden = false
        
        requestTableView.register(
            RequestTableViewCell.self,
            forCellReuseIdentifier: RequestTableViewCell.identifier
        )
        
        requestTableView.separatorStyle = .none
        requestTableView.tag = 1
        requestTableView.isScrollEnabled = false
        requestTableView.isHidden = true
        
        menuPlusButton.setButton("메뉴 정보 추가하기")
    }
    
    func updateViewHeight(defaultTable: Bool, count: Int) {
        let titleHeight = title.frame.height
        let subTitleHeight = subTitle.frame.height
        let buttonHeight = menuPlusButton.frame.height
        // 20, 7, 20, 20, 30
        let defaultPadding: CGFloat = 97
                
        let defaultTotalHeight = titleHeight + subTitleHeight + buttonHeight + defaultPadding
        
        if defaultTable {
            let height = CGFloat(55 * count)
            normalTableViewHeight?.constant = height
            viewHeightConstraint?.constant = defaultTotalHeight + height
            self.layoutIfNeeded()
            
        } else {
            let height = CGFloat(110 * count)
            requestTableViewHeight?.constant = height
            viewHeightConstraint?.constant = defaultTotalHeight + height
            self.layoutIfNeeded()

        }
    }
}
