//
//  PlaceReviewTableViewCell.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/17.
//

import UIKit

final class PlaceReviewTableViewCell: UITableViewCell {
    static let identifier = "PlaceReviewTableViewCell"
    
    private lazy var nickname: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 16, weight: .semibold)
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var createdTime: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 13, weight: .regular)
        label.textColor = .gray2
        
        return label
    }()
    
    private lazy var review: ReviewLabel = {
        let label = ReviewLabel()
        
        return label
    }()
    
    private lazy var topLabelStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 7
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        return stackView
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Dots"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var commentId = ""
    
    var reportButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            nickname,
            createdTime
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topLabelStack.addArrangedSubview($0)
        }
        
        [
            topLabelStack,
            reportButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topStackView.addArrangedSubview($0)
        }
        
        [
            topStackView,
            review
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor, constant: 0),
            topStackView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),

            review.topAnchor.constraint(
                equalTo: topLabelStack.bottomAnchor, constant: 10),
            review.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            review.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            review.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }
    
    func bindingData(comment: AVIROReviewRawData,
                     isAbbreviated: Bool,
                     isMyReview: Bool
    ) {
        commentId = comment.commentId
        nickname.text = comment.nickname
        createdTime.text = comment.updatedTime
        
        review.setLabel(
            text: comment.content,
            isAbbreviated: isAbbreviated,
            isMyReview: isMyReview)
    }
    
    // MARK: UpLoad 전 수정 -> nickname 수정 후
    @objc private func buttonTapped() {
        reportButtonTapped?()
    }
}
