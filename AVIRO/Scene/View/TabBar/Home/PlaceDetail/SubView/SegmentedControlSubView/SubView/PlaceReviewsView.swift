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
        label.textColor = .gray2
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
    
    var whenUploadReview: ((AVIROCommentPost) -> Void)?
    var whenAfterEditMyReview: ((AVIROEditCommentPost) -> Void)?
    
    var whenReportReview: ((String) -> Void)?
    var whenBeforeEditMyReview: ((String) -> Void)?
    
    private var placeId = ""
    private var isEditedAfter = false
    private var editedReviewId = ""
    private var whenHomeViewReviewsCount = 0
    
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
            noReviews,
            reviewsTable,
            separatedLine,
            showMoreReviewsButton,
            reviewInputView
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
        
        /// edit중 창을 나갈 경우를 대비한 초기화
        isEditedAfter = false
        /// textView 초기화
        reviewInputView.initTextView()
        
        self.placeId = placeId
        
        self.subTitle.text = "\(reviews.count)개"
        whenReviewView = true

        reviewsTable.isScrollEnabled = true

        reviewsTable.bottomAnchor.constraint(equalTo: reviewInputView.topAnchor).isActive = true
        
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

        reviewsTable.reloadData()
    }
    
    private func whenNotHaveReviews() {
        self.reviewsArray = [ReviewData]()
        
        noReviews.isHidden = false
        reviewsTable.isHidden = true
    }
    
    func dataBindingWhenInHomeView(_ reviewsModel: PlaceReviewsData?) {
        guard let reviews = reviewsModel?.commentArray else { return }
        
        self.subTitle.text = "\(reviews.count)개"
        whenHomeViewReviewsCount = reviews.count
        if reviews.count > 0 {
            whenHaveReviewsInHomeView(reviews)
        } else {
            whenNotHaveReviewsInHomeView()
        }
        
        reviewInputView.isHidden = true
    
    }
    
    private func whenHaveReviewsInHomeView(_ reviews: [ReviewData]) {
        if reviews.count > 4 {
            self.reviewsArray = Array(reviews.prefix(4))
        } else {
            self.reviewsArray = reviews
        }
        
        noReviews.isHidden = true
        reviewsTable.isHidden = false
        showMoreReviewsButton.isHidden = false
        separatedLine.isHidden = false

        reviewsTable.reloadData()
        reviewsTable.isScrollEnabled = false
        
        reviewsHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false
        
        reviewsHeightConstraint = reviewsTable.heightAnchor.constraint(equalToConstant: 600)
        reviewsHeightConstraint?.isActive = true
    }
    
    private func whenNotHaveReviewsInHomeView() {
        self.reviewsArray = [ReviewData]()

        reviewsHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false
        
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
    
    func afterUpdateReviewAndUpdateInHomeView(_ reviewModel: AVIROCommentPost) {
        reviewsUpdateInHomeView(reviewModel)
        whenHaveReviewsInHomeView(self.reviewsArray)
    }
    
    private func reviewsUpdateInHomeView(_ reviewModel: AVIROCommentPost) {
        let nowDate = TimeUtility.nowDate()

        let reviewModel = ReviewData(
            commentId: reviewModel.commentId,
            userId: reviewModel.userId,
            content: reviewModel.content,
            updatedTime: nowDate)
        
        reviewsArray.insert(reviewModel, at: 0)
        reviewsTable.reloadData()
        
        subTitle.text = "\(whenHomeViewReviewsCount + 1)개"
    }
    
    func afterEditReviewAndUpdateInHomeView(_ reviewModel: AVIROEditCommentPost) {
        reviewsEditInHomeView(reviewModel)
        whenHaveReviewsInHomeView(self.reviewsArray)
    }
    
    private func reviewsEditInHomeView(_ reviewModel: AVIROEditCommentPost) {
        let nowDate = TimeUtility.nowDate()

        let reviewModel = ReviewData(
            commentId: reviewModel.commentId,
            userId: reviewModel.userId,
            content: reviewModel.content,
            updatedTime: nowDate)
        
        if let existingIndex = reviewsArray.firstIndex(where: { $0.commentId == reviewModel.commentId }) {

            reviewsArray[existingIndex] = reviewModel
        }
        
        reviewsTable.reloadData()
        
        subTitle.text = "\(whenHomeViewReviewsCount)개"
    }
    
    @objc private func showMoreButtonTapped() {
        whenTappedShowMoreButton?()
    }
    
    // MARK: Edit My Review
    func editMyReview(_ commentId: String) {
        var text = ""
        reviewsArray.forEach {
            if $0.commentId == commentId {
                text = $0.content
            }
        }
        
        isEditedAfter = true
        editedReviewId = commentId
        
        reviewInputView.editMyReview(text)
    }
    
    private func handleClosure() {
        reviewInputView.enrollReview = { [weak self] text in
            guard let placeId = self?.placeId else { return }
            
            self?.updateReviewArray(text)
        }
        
        reviewInputView.initView = { [weak self] in
            self?.isEditedAfter = false
        }
    }
    
    private func updateReviewArray(_ text: String) {
        if isEditedAfter {
           whenEditedAfterUpdateReviewArray(text)
        } else {
            whenUpdateReviewArray(text)
        }
        
    }
    
    private func whenEditedAfterUpdateReviewArray(_ text: String) {
        isEditedAfter = false
        
        let nowDate = TimeUtility.nowDate()

        guard let index = reviewsArray.firstIndex(where: {$0.commentId == editedReviewId}) else {
            return
        }
                
        var postModel = AVIROCommentPost(placeId: placeId, userId: UserId.shared.userId, content: text)
        postModel.commentId = editedReviewId
        
        let reviewModel = ReviewData(
            commentId: postModel.commentId,
            userId: postModel.userId,
            content: text,
            updatedTime: nowDate)
        
        reviewsArray[index] = reviewModel
        
        reviewsTable.reloadData()
        
        subTitle.text = "\(reviewsArray.count)개"
        editedReviewId = ""
        
        let editModel = AVIROEditCommentPost(
            commentId: reviewModel.commentId,
            content: text,
            userId: reviewModel.userId
        )
        
        self.whenAfterEditMyReview?(editModel)
    }
    
    private func whenUpdateReviewArray(_ text: String) {
        isEditedAfter = false
        
        let nowDate = TimeUtility.nowDate()
        
        let postModel = AVIROCommentPost(
            placeId: placeId,
            userId: UserId.shared.userId,
            content: text
        )
                
        let reviewModel = ReviewData(
            commentId: postModel.commentId,
            userId: postModel.userId,
            content: postModel.content,
            updatedTime: nowDate)
        
        if reviewsArray.count == 0 {
            noReviews.isHidden = true
            reviewsTable.isHidden = false
        }
        
        reviewsArray.insert(reviewModel, at: 0)
        reviewsTable.reloadData()
        
        subTitle.text = "\(reviewsArray.count)개"
        
        self.whenUploadReview?(postModel)
    }
    
    func keyboardWillShow(height: CGFloat) {
        reviewInputView.keyboardWillShow(height: height)
    }
    
    func keyboardWillHide() {
        reviewInputView.keyboardWillHide()
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
        cell?.reportButtonTapped = { [weak self] (commentId, userId) in
            if userId != UserId.shared.userId {
                self?.whenReportReview?(commentId)
            } else {
                self?.whenBeforeEditMyReview?(commentId)
            }
        }
        
        if whenReviewView {
            if UserId.shared.userId == reviewData.userId {
                cell?.bindingData(comment: reviewData, isAbbreviated: false, isMyReview: true)
            } else {
                cell?.bindingData(comment: reviewData, isAbbreviated: false, isMyReview: false)
            }
        } else {
            if UserId.shared.userId == reviewData.userId {
                cell?.bindingData(comment: reviewData, isAbbreviated: true, isMyReview: true)
            } else {
                cell?.bindingData(comment: reviewData, isAbbreviated: true, isMyReview: false)
            }
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
