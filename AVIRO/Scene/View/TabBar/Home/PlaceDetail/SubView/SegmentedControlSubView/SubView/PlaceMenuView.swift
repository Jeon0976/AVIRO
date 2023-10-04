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
        
        label.font = .pretendard(size: 20, weight: .bold)
        label.textColor = .gray0
        label.text = "메뉴"
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 13, weight: .regular)
        label.textAlignment = .left
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var updatedTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 13, weight: .regular)
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .gray5
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private lazy var editButton: EditInfoButton = {
        let button = EditInfoButton()
        
        button.setButton("메뉴 정보 수정하기")
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        return button
    }()

    private lazy var showMoreButton: ShowMoreButton = {
        let button = ShowMoreButton()
        
        button.setButton("메뉴 더보기")
        button.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var footerView: UIView = {
        let width = self.frame.width - 32
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        
        let xFrame = view.frame.width - 100

        editButton.frame = CGRect(x: 0, y: 20, width: 130, height: 20)
        showMoreButton.frame = CGRect(x: xFrame, y: 20, width: 100, height: 20)
        
        view.backgroundColor = .gray7
        view.addSubview(editButton)
        view.addSubview(showMoreButton)
        
        return view
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    private var menuTableHeightConstraint: NSLayoutConstraint?
    
    private var cellHeights: [IndexPath: CGFloat] = [:]

    private var menuArray = [AVIROMenu]()
    
    private var whenMenuView = false
    
    var editMenuButton: (() -> Void)?
    var showMoreMenu: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        
        [
            title,
            subTitle,
            updatedTimeLabel,
            menuTable
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            subTitle.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 7),
            
            updatedTimeLabel.topAnchor.constraint(equalTo: title.topAnchor),
            updatedTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            menuTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            menuTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            menuTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    func dataBinding(_ menuModel: AVIROPlaceMenus?) {
        guard let menuModel = menuModel else { return }
        
        whenMenuView = true
        
        self.subTitle.text = "\(menuModel.count)개"
        self.updatedTimeLabel.text = "업데이트 " + menuModel.updatedTime
        self.menuArray = menuModel.menuArray
                
        menuTable.isScrollEnabled = true
        menuTable.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        menuTable.reloadData()
        menuTable.layoutIfNeeded()
        
        showMoreButton.isHidden = true
    }
        
    func dataBindingWhenInHomeView(_ menuModel: AVIROPlaceMenus?) {
        
        guard let menuModel = menuModel else { return }
        
        self.subTitle.text = "\(menuModel.count)개"
        self.updatedTimeLabel.text = "업데이트 " + menuModel.updatedTime
        
        if menuModel.menuArray.count > 5 {
            self.menuArray = Array(menuModel.menuArray.prefix(5))
            showMoreButton.isHidden = false
        } else {
            self.menuArray = menuModel.menuArray
            showMoreButton.isHidden = true
        }
    
        menuTable.reloadData()

        menuTable.isScrollEnabled = false

        menuTableHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false

        menuTableHeightConstraint = menuTable.heightAnchor.constraint(equalToConstant: 800)
        menuTableHeightConstraint?.isActive = true
    }
    
    private func updateTableViewHeight() {
        let indexPathsToRemove = cellHeights.keys.filter { $0.row >= menuArray.count }
        
        indexPathsToRemove.forEach { cellHeights.removeValue(forKey: $0) }
        
        let height = cellHeights.values.reduce(0, +)
        let footerViewHeight: CGFloat = 60
        
        menuTableHeightConstraint?.constant = height + footerViewHeight

        let titleHeight = title.frame.height
        
        // 20 20
        let inset: CGFloat = 40
                
        let totalHeight = titleHeight + height + footerViewHeight + inset
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: totalHeight)
        viewHeightConstraint?.isActive = true
    }
    
    @objc private func editButtonTapped() {
        editMenuButton?()
    }
    
    @objc private func showMoreButtonTapped() {
        showMoreMenu?()
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
        
        guard menuArray.count > indexPath.row else {
            return UITableViewCell()
        }
        
        let menuData = menuArray[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.dataBinding(menuData)
        
        return cell ?? UITableViewCell()
    }
}

extension PlaceMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !whenMenuView {
            cellHeights[indexPath] = cell.frame.size.height
            
            if indexPath.row == menuArray.count - 1 {
                updateTableViewHeight()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }
}
