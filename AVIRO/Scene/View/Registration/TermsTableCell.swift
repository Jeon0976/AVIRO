//
//  ThridRegistrationTableCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

private enum Layout: CGFloat {
    case cellToCell = 8
    case imageToText = 10
}

final class TermsTableCell: UITableViewCell {
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(
            UIImage.approveCondition.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .gray4
        button.addTarget(
            self,
            action: #selector(tappedCheck),
            for: .touchUpInside
        )

        return button
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        
        label.font = CFont.font.medium14
        label.textColor = .gray0
        
        return label
    }()
    
    var checkButtonTapped: (() -> Void) = { }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        [
            checkButton,
            termsLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            checkButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Layout.cellToCell.rawValue
            ),
            checkButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Layout.cellToCell.rawValue
            ),
            
            termsLabel.leadingAnchor.constraint(
                equalTo: checkButton.trailingAnchor,
                constant: Layout.imageToText.rawValue
            ),
            termsLabel.centerYAnchor.constraint(
                equalTo: checkButton.centerYAnchor)
        ])
    }
    
    func makeCellData(check: Bool, term: String) {
        let attributedString = NSMutableAttributedString(string: term)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: term.count)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.gray0,
            range: NSRange(location: 0, length: term.count)
        )
        
        termsLabel.attributedText = attributedString
        
        self.checkButton.isSelected = check
        self.checkButton.tintColor = check ? .main : .gray4
    }
    
    @objc func tappedCheck() {
        checkButton.isSelected = !checkButton.isSelected
        checkButton.tintColor = checkButton.isSelected ? .main : .gray4
        
        checkButtonTapped()
    }
}
