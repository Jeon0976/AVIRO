//
//  HistoryTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/06.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
       
        imageView.image = UIImage(named: "RecentlyTime")
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "X-Circle"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var cancelButtonTapped: (() -> Void)!
    
    @objc private func buttonTapped() {
        cancelButtonTapped()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() {
        [
            icon,
            titleLabel,
            cancelButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // icon
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            // titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: icon.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            
            // cancelButton
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func makeCellData(_ historyModel: HistoryTableModel) {
        let title = historyModel.title
        titleLabel.text = title
    }
}
