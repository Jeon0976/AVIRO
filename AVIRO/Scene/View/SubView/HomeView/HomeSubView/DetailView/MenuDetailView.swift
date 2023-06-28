//
//  MenuDetailView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class MenuDetailView: UIView {
    let title: UILabel = {
        let label = UILabel()
        
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "메뉴 정보"

        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none

        return tableView
    }()
    
    let noMenuLabel: UILabel = {
        let label = UILabel()
       
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "등록된 메뉴가 없어요"
        
        return label
    }()
    
    let noMenuLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = .systemFont(ofSize: 14)
        label.text = "식당 정보 오류 및 삭제 요청을 통해 등록해주세요"
        
        return label
    }()

    // TODO: Test Layout Constraint
    var viewHeightConstraint: NSLayoutConstraint?
    var tableViewHeightConstraint: NSLayoutConstraint?
        
    var menuArray = [MenuArray]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        [
            title,
            tableView,
            noMenuLabel,
            noMenuLabel2
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            DetailMenuTableCell.self,
            forCellReuseIdentifier: DetailMenuTableCell.idendifier
        )
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
             
            // noMenuLabel
            noMenuLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            noMenuLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // noMenuLabel2
            noMenuLabel2.topAnchor.constraint(equalTo: noMenuLabel.bottomAnchor, constant: 5),
            noMenuLabel2.centerXAnchor.constraint(equalTo: noMenuLabel.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 메뉴 데이터가 없을 때
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if menuArray.isEmpty {
            let titleHeight = title.frame.height
            let noMenuLabelHeight = noMenuLabel.frame.height
            let noMenuLabel2Height = noMenuLabel2.frame.height
            let totalHeight = titleHeight + noMenuLabelHeight + noMenuLabel2Height + 70
            
            viewHeightConstraint?.constant = totalHeight
            tableView.isHidden = true
            noMenuLabel.isHidden = false
            noMenuLabel2.isHidden = false
        }
    }
    
    // MARK: 메뉴 데이터가 있을 때
    func bindingMenuData(_ menuData: [MenuArray]) {
        menuArray = menuData
        
        if !menuArray.isEmpty {
            tableView.reloadData()

            tableView.isHidden = false
            noMenuLabel.isHidden = true
            noMenuLabel2.isHidden = true

            let titleHeight = title.frame.height
            let tableHeight = tableView.contentSize.height
            
            tableViewHeightConstraint?.constant = tableHeight

            let totalHeight = titleHeight + tableHeight + CGFloat(menuArray.count * 2) + 45

            viewHeightConstraint?.constant = totalHeight

        }
    }
}

extension MenuDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DetailMenuTableCell.idendifier,
            for: indexPath
        ) as? DetailMenuTableCell
        
        let menuItem = menuArray[indexPath.row]
        cell?.selectionStyle = .none
        
        let currencyKR = String(menuItem.price).currenyKR()
        let howToRequest = menuItem.menuType == MenuType.vegan.value ? "비건" : menuItem.howToRequest
        
        cell?.makeData(menuItem.menu, currencyKR, howToRequest)
        cell?.isCheck(menuItem.isCheck)
        
        return cell ?? UITableViewCell()
    }
}

extension MenuDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

class DetailMenuTableCell: UITableViewCell {
    static let idendifier = "DetailMenuTableCell"

    var title = UILabel()
    var price = UILabel()
    var isVegan = UILabel()
    var view = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            title,
            price,
            isVegan,
            view
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        view.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // price
            price.topAnchor.constraint(equalTo: contentView.topAnchor),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // isVegan
            isVegan.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            isVegan.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        isVegan.font = .systemFont(ofSize: 14)
        isVegan.textColor = .allVegan
        title.textColor = .mainTitle
        price.textColor = .mainTitle
        title.font = .systemFont(ofSize: 16)
        price.font = .systemFont(ofSize: 16)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isCheck(_ isCheck: Bool) {
        if isCheck {
            isVegan.textColor = .requestVegan
        } else {
            isVegan.textColor = .allVegan
        }
    }
    
    func makeData(_ title: String, _ price: String, _ isVegan: String) {
        self.title.text = title
        self.price.text = price
        self.isVegan.text = isVegan
    }
}
