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
        
        label.font = .pretendard(size: 20, weight: .bold)
        label.textColor = .gray0
        label.numberOfLines = 1
        label.text = "후기"
        
        return label
    }()
    
    private lazy var subTitle: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 13, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .gray2
        label.text = "0개"
        
        return label
    }()
    
    private lazy var noReviewsImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.noResultCharacter
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private lazy var noReviews: NoResultLabel = {
        let label = NoResultLabel()
        
        let text = "아직 등록된 후기가 없어요.\n소중한 후기를 작성해주세요!"
        label.setupLabel(text)
        
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
        
        view.backgroundColor = .gray5
        
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
    
    private var reviewsArray = [AVIROReviewRawDataDTO]()
    
    private var whenReviewView = false
    
    var whenTappedShowMoreButton: (() -> Void)?
    
    var whenUploadReview: ((AVIROEnrollReviewDTO) -> Void)?
    var whenAfterEditMyReview: ((AVIROEditReviewDTO) -> Void)?
    
    var whenReportReview: ((AVIROReportReviewModel) -> Void)?
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
    
    func keyboardWillShow(notification: NSNotification, height: CGFloat) {
        reviewInputView.keyboardWillShow(notification: notification, height: height)
    }
    
    func keyboardWillHide() {
        reviewInputView.keyboardWillHide()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray7
        
        [
            title,
            subTitle,
            noReviewsImageView,
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
            
            noReviewsImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noReviewsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            noReviews.topAnchor.constraint(equalTo: noReviewsImageView.bottomAnchor, constant: 20),
            noReviews.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func dataBinding(placeId: String,
                     reviewsModel: AVIROReviewsArrayDTO?
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
    
    private func whenHaveReviews(_ reviews: [AVIROReviewRawDataDTO]) {
        self.reviewsArray = reviews
        
        noReviews.isHidden = true
        noReviewsImageView.isHidden = true
        reviewsTable.isHidden = false

        reviewsTable.reloadData()
    }
    
    private func whenNotHaveReviews() {
        self.reviewsArray = [AVIROReviewRawDataDTO]()
        
        noReviews.isHidden = false
        noReviewsImageView.isHidden = false
        reviewsTable.isHidden = true
    }
    
    func dataBindingWhenInHomeView(_ reviewsModel: AVIROReviewsArrayDTO?) {
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
    
    private func whenHaveReviewsInHomeView(_ reviews: [AVIROReviewRawDataDTO]) {
        if reviews.count > 4 {
            self.reviewsArray = Array(reviews.prefix(4))
            showMoreReviewsButton.isHidden = false
        } else {
            self.reviewsArray = reviews
            showMoreReviewsButton.isHidden = true
        }
        
        noReviews.isHidden = true
        noReviewsImageView.isHidden = true
        
        reviewsTable.isHidden = false
        separatedLine.isHidden = false

        reviewsTable.reloadData()
        reviewsTable.isScrollEnabled = false
        
        reviewsHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false
        
        reviewsHeightConstraint = reviewsTable.heightAnchor.constraint(equalToConstant: 600)
        reviewsHeightConstraint?.isActive = true
    }
    
    private func whenNotHaveReviewsInHomeView() {
        self.reviewsArray = [AVIROReviewRawDataDTO]()

        reviewsHeightConstraint?.isActive = false
        viewHeightConstraint?.isActive = false
        
        noReviews.isHidden = false
        noReviewsImageView.isHidden = false
        
        reviewsTable.isHidden = true
        separatedLine.isHidden = true
        showMoreReviewsButton.isHidden = true

        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 300)
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
    
    func afterUpdateReviewAndUpdateInHomeView(_ reviewModel: AVIROEnrollReviewDTO) {
        print(whenHomeViewReviewsCount)

        reviewsUpdateInHomeView(reviewModel)
        whenHaveReviewsInHomeView(self.reviewsArray)
    }
    
    private func reviewsUpdateInHomeView(_ reviewModel: AVIROEnrollReviewDTO) {
        let nowDate = TimeUtility.nowDate()

        let reviewModel = AVIROReviewRawDataDTO(
            commentId: reviewModel.commentId,
            userId: reviewModel.userId,
            content: reviewModel.content,
            updatedTime: nowDate,
            nickname: MyData.my.nickname
        )
        
        reviewsArray.insert(reviewModel, at: 0)
        reviewsTable.reloadData()
        
        whenHomeViewReviewsCount += 1
        subTitle.text = "\(whenHomeViewReviewsCount)개"
    }
    
    func afterEditReviewAndUpdateInHomeView(_ reviewModel: AVIROEditReviewDTO) {
        reviewsEditInHomeView(reviewModel)
        whenHaveReviewsInHomeView(self.reviewsArray)
    }
    
    private func reviewsEditInHomeView(_ reviewModel: AVIROEditReviewDTO) {
        let nowDate = TimeUtility.nowDate()

        let reviewModel = AVIROReviewRawDataDTO(
            commentId: reviewModel.commentId,
            userId: reviewModel.userId,
            content: reviewModel.content,
            updatedTime: nowDate,
            nickname: MyData.my.nickname
        )
        
        if let existingIndex = reviewsArray.firstIndex(where: { $0.commentId == reviewModel.commentId }) {

            reviewsArray[existingIndex] = reviewModel
        }
        
        reviewsTable.reloadData()
        
        subTitle.text = "\(whenHomeViewReviewsCount)개"
    }
    
    @objc private func showMoreButtonTapped() {
        whenTappedShowMoreButton?()
    }
    
    func autoStartWriteComment() {
        reviewInputView.autoStartWriteComment()
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
                
        var postModel = AVIROEnrollReviewDTO(
            placeId: placeId,
            userId: MyData.my.id,
            content: text
        )
        postModel.commentId = editedReviewId
        
        let reviewModel = AVIROReviewRawDataDTO(
            commentId: postModel.commentId,
            userId: postModel.userId,
            content: text,
            updatedTime: nowDate,
            nickname: MyData.my.nickname
        )
        
        reviewsArray[index] = reviewModel
        
        reviewsTable.reloadData()
        
        subTitle.text = "\(reviewsArray.count)개"
        editedReviewId = ""
        
        let editModel = AVIROEditReviewDTO(
            commentId: reviewModel.commentId,
            content: text,
            userId: reviewModel.userId
        )
        
        self.whenAfterEditMyReview?(editModel)
    }
    
    private func whenUpdateReviewArray(_ text: String) {
        isEditedAfter = false
        
        let nowDate = TimeUtility.nowDate()
        
        let postModel = AVIROEnrollReviewDTO(
            placeId: placeId,
            userId: MyData.my.id,
            content: text
        )
                
        let reviewModel = AVIROReviewRawDataDTO(
            commentId: postModel.commentId,
            userId: postModel.userId,
            content: postModel.content,
            updatedTime: nowDate,
            nickname: MyData.my.nickname
        )
        
        if reviewsArray.count == 0 {
            noReviews.isHidden = true
            reviewsTable.isHidden = false
        }
        
        reviewsArray.insert(reviewModel, at: 0)
        reviewsTable.reloadData()
        
        subTitle.text = "\(reviewsArray.count)개"
        
        self.whenUploadReview?(postModel)
    }
    
    func deleteMyReview(_ commentId: String) {
        if let index = reviewsArray.firstIndex(where: { $0.commentId == commentId}) {
            reviewsArray.remove(at: index)
        }
        
        reviewsTable.reloadData()
        
        if whenReviewView {
            subTitle.text = "\(reviewsArray.count)개"
        } else {
            whenHomeViewReviewsCount -= 1
            subTitle.text = "\(whenHomeViewReviewsCount)개"

            if whenHomeViewReviewsCount == 0 {
            } else {
                whenHaveReviewsInHomeView(self.reviewsArray)
            }
        }
    }
    
    // MARK: Closure 처리
    private func handleClosure() {
        reviewInputView.enrollReview = { [weak self] text in
            self?.updateReviewArray(text)
        }
        
        reviewInputView.initView = { [weak self] in
            self?.isEditedAfter = false
        }
    }
}

extension PlaceReviewsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsArray.count
    }
    
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
        cell?.reportButtonTapped = { [weak self] in
            let createTime = self?.reviewsArray[indexPath.row].updatedTime ?? ""
            let content = self?.reviewsArray[indexPath.row].content ?? ""
            let userNickname = self?.reviewsArray[indexPath.row].nickname ?? ""
            let commentId = self?.reviewsArray[indexPath.row].commentId ?? ""
            let userId = self?.reviewsArray[indexPath.row].userId
            
            if userId != MyData.my.id {
                let reportModel = AVIROReportReviewModel(
                    createdTime: createTime,
                    placeTitle: "",
                    id: commentId,
                    content: content,
                    nickname: userNickname
                )
              
                self?.whenReportReview?(reportModel)
            } else {
                self?.whenBeforeEditMyReview?(commentId)
            }
        }
        
        if whenReviewView {
            if MyData.my.id == reviewData.userId {
                cell?.bindingData(comment: reviewData, isAbbreviated: false, isMyReview: true)
            } else {
                cell?.bindingData(comment: reviewData, isAbbreviated: false, isMyReview: false)
            }
        } else {
            if MyData.my.id == reviewData.userId {
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
