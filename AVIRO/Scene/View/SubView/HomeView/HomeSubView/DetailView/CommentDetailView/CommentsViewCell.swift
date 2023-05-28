//
//  CommentsViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/28.
//

import UIKit

class CommentsViewCell: UITableViewCell {
    static let identifier = "CommentsViewCell"
    
    var comment = PaddingLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        comment.numberOfLines = 0
        comment.lineBreakMode = .byWordWrapping
        comment.layer.cornerRadius = 15
        comment.textColor = ColorsList3
        comment.backgroundColor = UIColor(red: 239/255, green: 240/255, blue: 240/255, alpha: 1)
        comment.layer.masksToBounds = true
        comment.font = .systemFont(ofSize: 16)
        
        [
            comment
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
              comment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
              comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
              comment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
              comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
          ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeData(_ text: String) {
        comment.text = text
    }
}
