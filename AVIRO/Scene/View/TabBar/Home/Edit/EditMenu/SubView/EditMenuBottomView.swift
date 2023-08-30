//
//  EditMenuBottomView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import UIKit

final class EditMenuBottomView: UIView {
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.text = "메뉴 등록하기"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray2
        label.text = "어떤 메뉴를 판매하나요? 1개 이상 등록해주세요."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        
        return label
    }()
    
    private lazy var normalTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.tag = 0
        tableView.isScrollEnabled = false
        tableView.isHidden = false
        
        tableView.register(NormalTableViewCell.self, forCellReuseIdentifier: NormalTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var requestTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.tag = 1
        tableView.isScrollEnabled = false
        tableView.isHidden = false
        
        tableView.register(RequestTableViewCell.self, forCellReuseIdentifier: RequestTableViewCell.identifier)
        
        
        return tableView
    }()
    
    private lazy var menuPlusButton = BottomButton2()

    // MARK: Constraint 조절
    private var menuPlusButtonTopConstraint: NSLayoutConstraint?
    private var normalTableViewHeight: NSLayoutConstraint? // default 45
    private var requestTableViewHeight: NSLayoutConstraint? // default 100
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var initialView = true
    var constraintSet = true
    
    private var isDefaultTable = true
    private var count = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeAttribute()
        makeLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateViewHeight(defaultTable: isDefaultTable,
                         count: count
        )
    }
    
    // MARK: 데이터 바인딩 하고 들어올 예정이 추후 delete
    func initViewHeight() {
        let titleHeight = title.frame.height
        let subTitleHeight = subTitle.frame.height
        let normalHeight = normalTableView.frame.height
        let buttonHeight = menuPlusButton.frame.height
        // 20, 7, 20, 20, 30
        let paddingValues: CGFloat = 97
        
        let totalHeight = titleHeight + subTitleHeight + normalHeight + buttonHeight + paddingValues
        
        viewHeightConstraint?.constant = totalHeight
        requestTableView.isHidden = true
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
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 200)
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
            requestTableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 20),
            requestTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            requestTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // menuPlusButton
            menuPlusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            menuPlusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            menuPlusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
        
        normalTableViewHeight = normalTableView.heightAnchor.constraint(equalToConstant: 55)
        normalTableViewHeight?.isActive = true
        
        requestTableViewHeight = requestTableView.heightAnchor.constraint(equalToConstant: 110)
        requestTableViewHeight?.isActive = true
        
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray7
        
        menuPlusButton.setButton("메뉴 정보 추가하기")
    }
    
    func setTableViewDelegate(_ dataSource: UITableViewDataSource) {
        normalTableView.dataSource = dataSource
        requestTableView.dataSource = dataSource
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
    
    func changeMenuTable(_ isPresentingDefaultTable: Bool, _ count: Int) {
        
        self.isDefaultTable = isPresentingDefaultTable
        self.count = count
        
        normalTableView.isHidden = !isPresentingDefaultTable
        requestTableView.isHidden = isPresentingDefaultTable
    }
}
