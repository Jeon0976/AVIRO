//
//  HistoryTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/06.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
       
        imageView.image = UIImage.timeIcon
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        label.textColor = .gray1
        label.font = CFont.font.semibold16
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.closeCircle, for: .normal)
        button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    var cancelButtonTapped: (() -> Void)!
    
    @objc private func buttonTapped() {
        cancelButtonTapped()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        [
            icon,
            titleLabel,
            cancelButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: icon.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -10),
            
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupCellData(_ historyModel: HistoryTableModel) {
        let title = historyModel.title
        titleLabel.text = title
    }
}
