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
    
    var moreComment: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(systemName: "ellipsis")
        image.tintColor = .separateLine
        
        return image
    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    var viewHeightConstraint: NSLayoutConstraint?
    
    var commentArray = [CommentArray]()
    var cellHeights = [CGFloat]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [
            title,
            commentCount,
            tableView,
            noCommentLabel,
            noCommentLabel2,
            moreComment,
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
            
            // moreComment
            moreComment.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -16),
            moreComment.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // noCommentLabel
            noCommentLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            noCommentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // noCommentLabel2
            noCommentLabel2.topAnchor.constraint(equalTo: noCommentLabel.bottomAnchor, constant: 6),
            noCommentLabel2.centerXAnchor.constraint(equalTo: noCommentLabel.centerXAnchor),
            
            // commentButton
            commentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            commentButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            commentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if commentArray.isEmpty {
            tableView.isHidden = true
            moreComment.isHidden = true
            noCommentLabel.isHidden = false
            noCommentLabel2.isHidden = false
            
            let titleHeight = title.frame.height
            let noCommentLabelHeight = noCommentLabel.frame.height
            let noCommentLabel2Height = noCommentLabel2.frame.height
            let buttonHeight = commentButton.frame.height
            let totalHeight = titleHeight + noCommentLabelHeight + noCommentLabel2Height + buttonHeight + 86
            
            viewHeightConstraint?.constant = totalHeight
        }
    }
    
    func bindingCommentData(_ commentData: [CommentArray]) {
        commentArray = commentData
        commentCount.text = String(commentArray.count) + "개"

        let dummyCell = CommentDetailTableCell()
        cellHeights = commentArray.map { dummyCell.calculateHeight($0.content) }
        
        if cellHeights.count > 5 {
            cellHeights = Array(cellHeights[0..<5])
            moreComment.isHidden = false
        }
        
        if !commentArray.isEmpty {
            tableView.isHidden = false
            noCommentLabel.isHidden = true
            noCommentLabel2.isHidden = true

            tableView.reloadData()
            
            let titleHeight = title.frame.height
            let tableHaight = cellHeights.reduce(0, +)
            let buttonHeight = commentButton.frame.height
            
            tableViewHeightConstraint?.constant = tableHaight

            let totalHeight = titleHeight + tableHaight + buttonHeight + 72
            
            viewHeightConstraint?.constant = totalHeight
        }
    }

}

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if commentArray.count > 5 {
            return 5
        }
        
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentDetailTableCell.identifier,
            for: indexPath
        ) as? CommentDetailTableCell
        
        let item = commentArray[indexPath.row]
        
        cell?.selectionStyle = .none
        cell?.makeData(item.content)
        
        return cell ?? UITableViewCell()
    }
}

extension CommentDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    func calculateHeight(_ text: String) -> CGFloat {
        let approximateWidthOfText = frame.width - 16  // Assuming padding of 8 on each side
        let size = CGSize(width: approximateWidthOfText, height: 1000)  // Large height
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]  // Assuming font size of 14

        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return estimatedFrame.height + CGFloat(40)
    }
}
