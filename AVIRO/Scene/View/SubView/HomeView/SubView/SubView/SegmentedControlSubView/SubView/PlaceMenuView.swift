//
//  PlaceMenuView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceMenuView: UIView {
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray0
        label.text = "메뉴 정보"
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .right
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var menuTable: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            PlaceMenuTableViewCell.self,
            forCellReuseIdentifier: PlaceMenuTableViewCell.identifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .gray5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        return tableView
    }()
    
    private lazy var editMenuButton: EditButton = {
        let button = EditButton()
        
        button.setButton("메뉴 정보 수정하기")
        
        return button
    }()
    
    private lazy var moreShowMenuButton: ShowMoreButton = {
        let button = ShowMoreButton()
        
        button.setButton("메뉴 더보기")
        
        return button
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    private var menuTableHeightConstraint: NSLayoutConstraint?
    
    private var cellHeights: [IndexPath: CGFloat] = [:]

    private var menuArray = [MenuArray]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        
        [
            title,
            subTitle,
            menuTable,
            editMenuButton,
            moreShowMenuButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 150)
        viewHeightConstraint?.isActive = true
        
        menuTableHeightConstraint = menuTable.heightAnchor.constraint(equalToConstant: 2000)
        menuTableHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            subTitle.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            subTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            menuTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            menuTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            menuTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            editMenuButton.topAnchor.constraint(equalTo: menuTable.bottomAnchor, constant: 20),
            editMenuButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editMenuButton.widthAnchor.constraint(equalToConstant: 130),
            
            moreShowMenuButton.topAnchor.constraint(equalTo: editMenuButton.topAnchor),
            moreShowMenuButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            moreShowMenuButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        moreShowMenuButton.isHidden = false
    }
    
    func dataBinding(_ menu: [MenuArray]) {
        self.menuArray = menu
        
        menuTable.reloadData()
        
        updateTableViewHeight()
    }
    
    func updateTableViewHeight() {
        menuTable.layoutIfNeeded()
        let height = cellHeights.values.reduce(0, +)
        
        menuTableHeightConstraint?.constant = height

        let titleHeight = title.frame.height
        let subTitleHeight = subTitle.frame.height
        let editMenuHeight = editMenuButton.frame.height
        
        // 20 20 20 20
        let inset: CGFloat = 80

        let totalHeight = titleHeight + subTitleHeight + height + editMenuHeight + inset
        
        viewHeightConstraint?.constant = totalHeight
    }
}

extension PlaceMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceMenuTableViewCell.identifier,
            for: indexPath
        ) as? PlaceMenuTableViewCell
        
        let menuData = menuArray[indexPath.row]
        cell?.selectionStyle = .none
        
        cell?.dataBinding(menuData)
    
        return cell ?? UITableViewCell()
    }
}

extension PlaceMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}
