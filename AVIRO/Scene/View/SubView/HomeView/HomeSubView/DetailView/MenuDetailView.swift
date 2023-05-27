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
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
       
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "등록된 메뉴가 없어요"
        
        return label
    }()
    
    let noMenuLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "식당 정보 오류 및 삭제 요청을 통해 등록해주세요"
        
        return label
    }()

    var tableViewHeightConstraint: NSLayoutConstraint?
    var items: [DetailMenuTableModel]?

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
        tableView.register(
            DetailMenuTableCell.self,
            forCellReuseIdentifier: DetailMenuTableCell.idendifier
        )
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
             
            // noMenuLabel
            noMenuLabel.topAnchor.constraint(equalTo: self.centerYAnchor),
            noMenuLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // noMenuLabel2
            noMenuLabel2.topAnchor.constraint(equalTo: noMenuLabel.bottomAnchor, constant: 5),
            noMenuLabel2.centerXAnchor.constraint(equalTo: noMenuLabel.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        items?.sort(by: {
            if $0.isVean == "비건" && $1.isVean != "비건" {
                return true
            } else {
                return false
            }
        })

        tableView.reloadData()
        
        let height = tableView.contentSize.height
        tableViewHeightConstraint?.constant = height
        layoutIfNeeded()
        
        if items?[0].title == "" {
            noMenuLabel.isHidden = false
            noMenuLabel2.isHidden = false
            tableView.isHidden = true
        } else {
            noMenuLabel.isHidden = true
            noMenuLabel2.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func heightOfLabel(label: UILabel) -> CGFloat {
        let constraintRect = CGSize(width: label.frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = label.text?.boundingRect(
            with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: label.font!],
            context: nil
        )
        
        return ceil(boundingBox?.height ?? 0)
    }
}

extension MenuDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }

        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DetailMenuTableCell.idendifier,
            for: indexPath
        ) as? DetailMenuTableCell

        guard let items = items else { return UITableViewCell() }
        let item = items[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.makeData(item.title, item.price, item.isVean)
        cell?.isVeganColorChage(item.requestMenuVegan)
        
        return cell ?? UITableViewCell()
    }
}

class DetailMenuTableCell: UITableViewCell {
    static let idendifier = "DetailMenuTableCell"

    var title = UILabel()
    var price = UILabel()
    var isVegan = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            title,
            price,
            isVegan
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // price
            price.topAnchor.constraint(equalTo: contentView.topAnchor),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // isVegan
            isVegan.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            isVegan.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            isVegan.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func isVeganColorChage(_ change: Bool) {
        if !change {
            isVegan.textColor = .purple
        } else {
            isVegan.textColor = .blue
        }
    }
    
    func makeData(_ title: String, _ price: String, _ isVegan: String) {
        self.title.text = title
        self.price.text = price
        self.isVegan.text = isVegan
    }
}
