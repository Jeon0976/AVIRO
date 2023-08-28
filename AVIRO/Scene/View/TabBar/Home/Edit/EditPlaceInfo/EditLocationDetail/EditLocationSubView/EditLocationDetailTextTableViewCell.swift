//
//  EditLocationDetailTextTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import UIKit

final class EditLocationDetailTextTableViewCell: UITableViewCell {
    static let identifier = "EditLocationDetailTextTableViewCell"
    
    private lazy var zipNo: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var roadAddr: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var jibunAddr: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray2
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            zipNo,
            roadAddr,
            jibunAddr
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            zipNo.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            zipNo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            zipNo.widthAnchor.constraint(equalToConstant: 60),
            
            roadAddr.topAnchor.constraint(equalTo: zipNo.topAnchor),
            roadAddr.leadingAnchor.constraint(equalTo: zipNo.trailingAnchor, constant: 5),
            roadAddr.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            jibunAddr.topAnchor.constraint(equalTo: roadAddr.bottomAnchor, constant: 5),
            jibunAddr.leadingAnchor.constraint(equalTo: roadAddr.leadingAnchor),
            jibunAddr.trailingAnchor.constraint(equalTo: roadAddr.trailingAnchor),
            jibunAddr.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func dataBinding(juso: Juso,
                     attributedRoad: NSAttributedString?,
                     attributedJibun: NSAttributedString?
    ) {
        guard let roadAddr = juso.roadAddr,
              let jibunAddr = juso.jibunAddr else { return }
        
        self.zipNo.text = juso.zipNo
        self.roadAddr.attributedText = attributedRoad ?? NSAttributedString(string: roadAddr)
        self.jibunAddr.attributedText = attributedJibun ?? NSAttributedString(string: jibunAddr)
    }
    
    func selectedCell() -> String? {
        guard let address = roadAddr.text else { return nil }
        return address
    }
}

