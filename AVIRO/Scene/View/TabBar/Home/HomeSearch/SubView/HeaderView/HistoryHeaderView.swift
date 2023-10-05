//
//  HistoryHeaderView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/07.
//

import UIKit

private enum Text: String {
    case title = "최근검색어"
    case button = "모두 지우기"
}

final class HistoryHeaderView: UIView {
    private lazy var recentlyLabel: UILabel = {
       let label = UILabel()
        
        label.text = Text.title.rawValue
        label.textColor = .gray0
        label.font = CFont.font.semibold15
        
        return label
    }()
    
    private lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        
        button.setTitle(Text.button.rawValue, for: .normal)
        button.titleLabel?.font = CFont.font.semibold14
        button.setTitleColor(.gray1, for: .normal)
        button.backgroundColor = .gray6

        button.contentEdgeInsets = UIEdgeInsets(
            top: 8,
            left: 12,
            bottom: 8,
            right: 12
        )
        
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
    var deleteAllCell: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        self.backgroundColor = .gray7
        self.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        [
            recentlyLabel,
            deleteAllButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            recentlyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recentlyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            deleteAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            deleteAllButton.centerYAnchor.constraint(equalTo: recentlyLabel.centerYAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        deleteAllCell?()
    }
    
}
