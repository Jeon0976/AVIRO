//
//  CommentDetailView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class CommentDetailView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "메뉴 정보"

        return label
    }()
    
    let comentCount: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "0 개"

        return label
    }()
    
    let tableView: UITableView = {
       let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30.0
        
        return tableView
    }()
    
    let noCommentLabel: UILabel = {
        let label = UILabel()
       
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "아직 댓글이 없어요"
        
        return label
    }()
    
    let noCommentLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.text = "영광스러운 첫 댓글을 남겨주세요"
        
        return label
    }()

    let commentButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.backgroundColor = ColorsList4
        button.setTitle("나도 댓글 달기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
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
            noCommentLabel2
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        
    }
}

extension CommentDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

extension CommentDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 
    }
}


class CommentDetailTableCell: UITableViewCell {
    static let identifier = "CommentDetailTableCell"
    
    var comment = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            comment
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
