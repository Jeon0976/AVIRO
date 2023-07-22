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
        label.font = Layout.Label.mainTitle
        label.text = StringValue.DetailView.commentInfoTitle

        return label
    }()
    
    var commentCount: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = Layout.Label.menuSubInfo
        label.text = "0" + StringValue.DetailView.commentCount

        return label
    }()
    
    var tableView: UITableView = {
       let tableView = UITableView()
        
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var noCommentLabel: UILabel = {
        let label = UILabel()
       
        label.textColor = .mainTitle
        label.font = Layout.Label.mainTitle
        label.text = StringValue.DetailView.noCommentInfo
        
        return label
    }()
    
    var noCommentLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .subTitle
        label.font = Layout.Label.noInfoSub
        label.text = StringValue.DetailView.noCommentDetail
        
        return label
    }()

    var commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .plusButton
        button.setTitle(StringValue.DetailView.commentButton, for: .normal)
        button.setTitleColor(.mainTitle, for: .normal)
        
        button.contentEdgeInsets = Layout.Button.buttonEdgeInset
        button.layer.cornerRadius = Layout.Button.cornerRadius
        
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
        tableView.register(CommentDetailTableCell.self,
                           forCellReuseIdentifier: CommentDetailTableCell.identifier
        )
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        viewHeightConstraint?.isActive = true
                
        NSLayoutConstraint.activate([
            // title
            title.topAnchor.constraint(
                equalTo: self.topAnchor, constant: Layout.Inset.leadingTopPlus),
            title.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            
            // commentCount
            commentCount.bottomAnchor.constraint(
                equalTo: title.bottomAnchor),
            commentCount.leadingAnchor.constraint(
                equalTo: title.trailingAnchor, constant: Layout.Inset.leadingTopSmall),
            
            // tableView
            tableView.topAnchor.constraint(
                equalTo: self.title.bottomAnchor, constant: Layout.Inset.leadingTopPlus),
            tableView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            tableView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // moreComment
            moreComment.topAnchor.constraint(
                equalTo: tableView.bottomAnchor, constant: Layout.DetailView.moreCommentInset),
            moreComment.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            
            // noCommentLabel
            noCommentLabel.topAnchor.constraint(
                equalTo: title.bottomAnchor, constant: Layout.Inset.leadingTopPlus),
            noCommentLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            
            // noCommentLabel2
            noCommentLabel2.topAnchor.constraint(
                equalTo: noCommentLabel.bottomAnchor, constant: Layout.Inset.menuSpacing),
            noCommentLabel2.centerXAnchor.constraint(
                equalTo: noCommentLabel.centerXAnchor),
            
            // commentButton
            commentButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: Layout.Inset.leadingTop),
            commentButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: Layout.Inset.trailingBottom),
            commentButton.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: Layout.Inset.trailingBottom)
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
            let totalHeight =
                titleHeight +
                noCommentLabelHeight +
                noCommentLabel2Height +
                buttonHeight +
                Layout.DetailView.whenNoComment
            
            viewHeightConstraint?.constant = totalHeight
        }
    }
    
    func bindingCommentData(_ commentData: [CommentArray]) {
        commentArray = commentData
        commentCount.text = String(commentArray.count) + StringValue.DetailView.commentCount

        let dummyCell = CommentDetailTableCell()
        cellHeights = commentArray.map { dummyCell.calculateHeight($0.content) }
                
        if !commentArray.isEmpty {
            var commentViewInset = Layout.DetailView.whenHaveCommentUnder5

            if cellHeights.count > 5 {
                cellHeights = Array(cellHeights[0..<5])
               
                moreComment.isHidden = false
                
                commentViewInset = Layout.DetailView.whenHaveCommentOver5
            }
            
            tableView.isHidden = false
            noCommentLabel.isHidden = true
            noCommentLabel2.isHidden = true

            tableView.reloadData()
            
            let titleHeight = title.frame.height
            let tableHaight = cellHeights.reduce(0, +)
            let buttonHeight = commentButton.frame.height
            
            tableViewHeightConstraint?.constant = tableHaight

            let totalHeight =
                    titleHeight +
                    tableHaight +
                    buttonHeight +
                    commentViewInset
                
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
            comment.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Layout.Inset.leadingTopHalf),
            comment.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: Layout.Inset.trailingBottomHalf),
            comment.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Layout.Inset.leadingTopHalf),
            comment.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: Layout.Inset.trailingBottomHalf)
          ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeData(_ text: String) {
        comment.text = text
    }
    
    func calculateHeight(_ text: String) -> CGFloat {
        let approximateWidthOfText = frame.width - 32
        let size = CGSize(width: approximateWidthOfText, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]

        let estimatedFrame = NSString(string: text)
            .boundingRect(
                with: size,
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            )

        // 40 -> comment inner top,bottom inset + comment outter top inset
        return estimatedFrame.height + CGFloat(40)
    }
}
