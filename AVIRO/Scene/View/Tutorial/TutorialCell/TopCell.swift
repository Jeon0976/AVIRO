//
//  TutorialCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/06.
//

import UIKit

final class TopCell: UICollectionViewCell {
    private lazy var titleLabel: TutorialTopLabel = {
        let label = TutorialTopLabel()
        
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .gray0
        label.numberOfLines = 2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            titleLabel,
            subTitleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17),
            subTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func setupData(title: String, subtitle: String, subtitle2: String, isTop: Bool) {
        titleLabel.text = title
        
        setupSubtitleFont(isTop: isTop, subtitle: subtitle, subtitle2: subtitle2)
    }
    
    private func setupSubtitleFont(isTop: Bool, subtitle: String, subtitle2: String) {
        let subtitleFont = isTop ? CFont.font.heavy31 : CFont.font.semibold31
        let subtitle2Font = isTop ? CFont.font.semibold31 : CFont.font.heavy31
        
        let attributedSubtitle = NSMutableAttributedString(
            string: subtitle,
            attributes: [.font: subtitleFont]
        )
        let attributedSubtitle2 = NSMutableAttributedString(
            string: subtitle2,
            attributes: [.font: subtitle2Font]
        )
        
        attributedSubtitle.append(attributedSubtitle2)
        subTitleLabel.attributedText = attributedSubtitle
    }

}
