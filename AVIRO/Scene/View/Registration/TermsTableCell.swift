//
//  ThridRegistrationTableCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

final class TermsTableCell: UITableViewCell {
    static let identifier = "TermsTableCell"
    
    private lazy var check: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(tappedCheck), for: .touchUpInside)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .gray4
        
        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 14, weight: .medium)
        
        return label
    }()
    
    var checkButtonTapped: (() -> Void) = { }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        [
            check,
            termsLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            check.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            check.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            check.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            termsLabel.leadingAnchor.constraint(equalTo: check.trailingAnchor, constant: 10),
            termsLabel.centerYAnchor.constraint(equalTo: check.centerYAnchor)
        ])
    }
    
    func makeCellData(check: Bool, term: String) {
        let attributedString = NSMutableAttributedString(string: term)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: term.count)
        )
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.gray0,
                                      range: NSRange(location: 0, length: term.count)
        )
        
        termsLabel.attributedText = attributedString
        
        self.check.isSelected = check
        self.check.tintColor = check ? .main : .gray4
    }
    
    @objc func tappedCheck() {
        check.isSelected = !check.isSelected
        check.tintColor = check.isSelected ? .main : .gray4
        
        checkButtonTapped()
    }
}
