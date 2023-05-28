//
//  CommentDetailView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class CommentDetailView: UIView {
    var title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "댓글"

        return label
    }()
    
    var comentCount: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "0개"

        return label
    }()
    
    var tableView: UITableView = {
       let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var noCommentLabel: UILabel = {
        let label = UILabel()
       
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "아직 댓글이 없어요"
        
        return label
    }()
    
    var noCommentLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "영광스러운 첫 댓글을 남겨주세요"
        
        return label
    }()

    var commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorsList4
        button.setTitle("나도 댓글 달기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    var items: [CommentModel]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            title,
            comentCount,
            tableView,
            noCommentLabel,
            noCommentLabel2,
            commentButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentDetailTableCell.self,
                           forCellReuseIdentifier: CommentDetailTableCell.identifier
        )
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
                
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // commentCount
            comentCount.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            comentCount.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // noCommentLabel
            noCommentLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            noCommentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // noCommentLabel2
            noCommentLabel2.topAnchor.constraint(equalTo: noCommentLabel.bottomAnchor, constant: 6),
            noCommentLabel2.centerXAnchor.constraint(equalTo: noCommentLabel.centerXAnchor),
            
            // commentButton
            commentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            commentButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            commentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showData() {
        guard var items = items else { return }
        
        comentCount.text = "\(items.count)개"
        noCommentLabel.isHidden = true
        noCommentLabel2.isHidden = true
        
        items.sort(by: { $0.date > $1.date })
        
        tableView.reloadData()
        
        let height = tableView.contentSize.height
        tableViewHeightConstraint?.constant = height
        layoutIfNeeded()
    }
    
    func heightOfLabel(label: UILabel) -> CGFloat {
        let constraintRect = CGSize(width: label.frame.width, height: .greatestFiniteMagnitude)
        let boundingBox = label.text?.boundingRect(
            with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: label.font!],
            context: nil
        )
        
        return ceil(boundingBox?.height ?? 0)
    }
}

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        
        if items.count > 4 {
            return 4
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentDetailTableCell.identifier,
            for: indexPath
        ) as? CommentDetailTableCell
        
        guard let items = items else { return UITableViewCell() }
        let item = items[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.makeData(item.comment)
        
        return cell ?? UITableViewCell()
    }
}

extension CommentDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

class CommentDetailTableCell: UITableViewCell {
    static let identifier = "CommentDetailTableCell"
    
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
