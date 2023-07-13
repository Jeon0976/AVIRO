//
//  ThridRegistrationTableCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

final class TermsTableCell: UITableViewCell {
    static let identifier = "TermsTableCell"
    
    var check = UIButton()
    var termsLabel = UILabel()
    
    var checkButtonTapped: (() -> Void) = { }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeAttribute() {
        check.addTarget(self, action: #selector(tappedCheck), for: .touchUpInside)
        check.setImage(UIImage(systemName: "checkmark"), for: .normal)
        check.tintColor = .subTitle
        
        termsLabel.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    func makeCellData(check: Bool, term: String) {
        let attributedString = NSMutableAttributedString(string: term)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: term.count)
        )
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.registrationColor,
                                      range: NSRange(location: 0, length: term.count)
        )
        
        termsLabel.attributedText = attributedString
        self.check.isSelected = check

        self.check.tintColor = check ? .allVegan : .subTitle
    }
    
    @objc func tappedCheck() {
        check.isSelected = !check.isSelected
        check.tintColor = check.isSelected ? .allVegan : .subTitle
        
        checkButtonTapped()
    }
}
