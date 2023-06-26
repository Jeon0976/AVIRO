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
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "댓글"

        return label
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
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
       
        label.textColor = .mainTitle
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "아직 댓글이 없어요"
        
        return label
    }()
    
    var noCommentLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = .systemFont(ofSize: 14)
        label.text = "영광스러운 첫 댓글을 남겨주세요"
        
        return label
    }()

    var commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .plusButton
        button.setTitle("나도 댓글 달기", for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    var viewHeightConstraint: NSLayoutConstraint?
    var commentItems = [CommentArray]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            title,
            commentCount,
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
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
                
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            // commentCount
            commentCount.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            commentCount.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 4),
            
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
    
    // TODO: Menu Table, Comment Table height 불러오기 방식 다름 -> 향후 수정 해야할 부분
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if commentItems.isEmpty {
            let titleHeight = title.frame.height
            let noCommentLabelHeight = noCommentLabel.frame.height
            let noCommentLabel2Height = noCommentLabel2.frame.height
            let buttonHeight = commentButton.frame.height
            let totalHeight = titleHeight + noCommentLabelHeight + noCommentLabel2Height + buttonHeight + 86
            
            viewHeightConstraint?.constant = totalHeight
            
            tableView.isHidden = true
            noCommentLabel.isHidden = false
            noCommentLabel2.isHidden = false
        } else {
            let titleHeight = title.frame.height
            let tableViewHeight = tableView.frame.height
            let buttonHeight = commentButton.frame.height
            let totalHeight = titleHeight + tableViewHeight + buttonHeight + 76
            
            viewHeightConstraint?.constant = totalHeight
            tableView.isHidden = false
            noCommentLabel.isHidden = true
            noCommentLabel2.isHidden = true
            commentCount.text = "\(commentItems.count)개"
        }
    }
}

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if commentItems.count > 5 {
            return 5
        }
        
        return commentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentDetailTableCell.identifier,
            for: indexPath
        ) as? CommentDetailTableCell
        
        let item = commentItems[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.makeData(item.content)
        
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
    
    var comment = CommentsLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
