//
//  PlaceReviewsView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceReviewsView: UIView {
    private lazy var title: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray0
        label.numberOfLines = 1
        label.text = "후기"
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .gray0
        label.text = "0개"
        
        return label
    }()
    
    private lazy var noReviews: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .gray3
        label.text = "등록된 후기가 없어요"
        
        return label
    }()
    
    private lazy var reviewsTable: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            PlaceReviewTableViewCell.self,
            forCellReuseIdentifier: PlaceReviewTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        
        return tableView
    }()
    
    private lazy var separatedLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .separateLine
        
        return view
    }()
    
    private lazy var showMoreReviewsButton: ShowMoreButton = {
        let button = ShowMoreButton()
        
        button.setButton("후기 더보기")
        button.addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var reviewInputView = PushCommentView()
        
    private var viewHeightConstraint: NSLayoutConstraint?
    private var reviewsHeightConstraint: NSLayoutConstraint?
    
    private var cellHeights: [IndexPath: CGFloat] = [:]
    
    private var reviewsArray = [ReviewData]()
    
    private var whenReviewView = false
    
    var whenTappedShowMoreButton: (() -> Void)?
    var whenEnrollReview: ((String) -> Void)?
    
    private var placeId = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        handleClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        
        [
            title,
            subTitle,
            reviewsTable,
            separatedLine,
            showMoreReviewsButton,
            reviewInputView,
            noReviews
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            subTitle.bottomAnchor.constraint(equalTo: self.title.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 7),
            
            reviewsTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            reviewsTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reviewsTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separatedLine.topAnchor.constraint(equalTo: reviewsTable.bottomAnchor, constant: 15),
            separatedLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            separatedLine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            separatedLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            showMoreReviewsButton.topAnchor.constraint(equalTo: separatedLine.bottomAnchor, constant: 20),
            showMoreReviewsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            showMoreReviewsButton.widthAnchor.constraint(equalToConstant: 100),
            
            reviewInputView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            reviewInputView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reviewInputView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            noReviews.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noReviews.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func dataBinding(placeId: String,
                     reviewsModel: PlaceReviewsData?
    ) {
        guard let reviews = reviewsModel?.commentArray else { return }
        
        self.subTitle.text = "\(reviews.count)개"
        whenReviewView = true

        if reviews.count > 0 {
            whenHaveReviews(reviews)
        } else {
            whenNotHaveReviews()
        }
        
        separatedLine.isHidden = true
        showMoreReviewsButton.isHidden = true
        reviewInputView.isHidden = false
        
    }
    
    private func whenHaveReviews(_ reviews: [ReviewData]) {
        self.reviewsArray = reviews
        
        noReviews.isHidden = true
        reviewsTable.isHidden = false
        
        reviewsTable.isScrollEnabled = true
        reviewsTable.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

        reviewsTable.bottomAnchor.constraint(equalTo: reviewInputView.topAnchor).isActive = true

        reviewsTable.reloadData()
    }
    
    private func whenNotHaveReviews() {
        noReviews.isHidden = false
        reviewsTable.isHidden = true
        
    }
    
    func dataBindingWhenInHomeView(_ reviewsModel: PlaceReviewsData?) {
        guard let reviews = reviewsModel?.commentArray else { return }
        
        self.subTitle.text = "\(reviews.count)개"
        
        if reviews.count > 0 {
            whenHaveReviewsInHomeView(reviews)
        } else {
            whenNotHaveReviewsInHomeView()
        }
        
        reviewInputView.isHidden = true
    
    }
    
    private func whenHaveReviewsInHomeView(_ reviews: [ReviewData]) {
        noReviews.isHidden = true
        reviewsTable.isHidden = false
        showMoreReviewsButton.isHidden = false
        separatedLine.isHidden = false
        
        if reviews.count > 4 {
            self.reviewsArray = Array(reviews.prefix(4))
        } else {
            self.reviewsArray = reviews
        }
        
        reviewsTable.reloadData()
        reviewsTable.isScrollEnabled = false
        
        reviewsHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false
        
        reviewsHeightConstraint = reviewsTable.heightAnchor.constraint(equalToConstant: 600)
        reviewsHeightConstraint?.isActive = true
    }
    
    private func whenNotHaveReviewsInHomeView() {
        noReviews.isHidden = false
        reviewsTable.isHidden = true
        showMoreReviewsButton.isHidden = true
        separatedLine.isHidden = true
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 250)
        viewHeightConstraint?.isActive = true
        
    }
    
    private func updateTableViewHeight() {
        let indexPathsToRemove = cellHeights.keys.filter { $0.row >= reviewsArray.count }
        
        indexPathsToRemove.forEach {
            cellHeights.removeValue(forKey: $0)
        }
        
        let tableViewHeight = cellHeights.values.reduce(0, +)
        
        reviewsHeightConstraint?.constant = tableViewHeight
        
        let titleHeight = title.frame.height
        let separtedLineHeight = separatedLine.frame.height
        let showMoreButtonHeight = showMoreReviewsButton.frame.height
        
        // 20 20 15 20 20
        let inset: CGFloat = 95
        
        let totalHeight = tableViewHeight + titleHeight + separtedLineHeight + showMoreButtonHeight + inset
        
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: totalHeight)
        viewHeightConstraint?.isActive = true
    }
    
    @objc private func showMoreButtonTapped() {
        whenTappedShowMoreButton?()
    }
    
    private func handleClosure() {
        reviewInputView.enrollReview = { [weak self] text in
            guard let placeId = self?.placeId else { return }
            let reviewModel = AVIROCommentPost(
                placeId: placeId,
                userId: UserId.shared.userId,
                content: text
            )
            
        }
    }
}

extension PlaceReviewsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsArray.count
    }
    
    // TODO: Place ID에 맞춰서 색상 변경하는거 업데이트!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceReviewTableViewCell.identifier,
            for: indexPath
        ) as? PlaceReviewTableViewCell
        
        guard reviewsArray.count > indexPath.row else {
            return UITableViewCell()
        }
        
        let reviewData = reviewsArray[indexPath.row]
        
        cell?.selectionStyle = .none
        
        if whenReviewView {
            cell?.bindingData(comment: reviewData, isAbbreviated: false, isMyReview: false)
        } else {
            cell?.bindingData(comment: reviewData, isAbbreviated: true, isMyReview: false)
        }
        
        return cell ?? UITableViewCell()
    }
}

extension PlaceReviewsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !whenReviewView {
            cellHeights[indexPath] = cell.frame.size.height
            
            if indexPath.row == reviewsArray.count - 1 {
                updateTableViewHeight()
            }
        }
    }
}