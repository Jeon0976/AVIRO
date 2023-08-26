//
//  HistoryHeaderView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import UIKit

final class HistoryHeaderView: UIView {
    private lazy var recentlyLabel: UILabel = {
       let label = UILabel()
        
        label.text = "최근검색어"
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    private lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("모두 지우기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.gray1, for: .normal)
        button.backgroundColor = .gray6

        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var deleteAllCell: (() -> Void)!
    
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
            recentlyLabel,
            deleteAllButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            recentlyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recentlyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            recentlyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            deleteAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deleteAllButton.centerYAnchor.constraint(equalTo: recentlyLabel.centerYAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        deleteAllCell()
    }
    
}
