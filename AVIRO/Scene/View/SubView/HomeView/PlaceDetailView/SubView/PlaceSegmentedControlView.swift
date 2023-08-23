//
//  PlaceSegmentedControlView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceSegmentedControlView: UIView {
    private let home = "홈"
    private let menu = "메뉴"
    private var reviews = "후기 (0)"
    
    private lazy var items = [self.home, self.menu, self.reviews]
    
    private lazy var segmentedControl = UnderlineSegmentedControl(items: items)
    
    private lazy var homeView = PlaceHomeView()
    private lazy var menuView = PlaceMenuView()
    private lazy var reviewView = PlaceReviewsView()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        
        indicatorView.color = .gray1
        indicatorView.style = UIActivityIndicatorView.Style.large
        indicatorView.startAnimating()
        
        return indicatorView
    }()
    
    private lazy var scrollView = UIScrollView()
    
    private var homeBottomConstraint: NSLayoutConstraint?

    private var afterInitViewConstrait = false
    
    private var placeId = ""
    
    private var reviewsCount = 0 {
        didSet {
            segmentedControlLabelChange(reviewsCount)
            updateReviewsCount?(reviewsCount)
        }
    }
    
    var isLoading = true {
        didSet {
            if isLoading {
                whenIsLoading()
            } else {
                whenIsEndLoading()
            }
        }
    }
    
    var whenUploadReview: ((AVIROCommentPost) -> Void)?
    var updateReviewsCount: ((Int) -> Void)?
    var reportReview: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
        handleClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        
        [
            segmentedControl,
            scrollView,
            menuView,
            reviewView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.topAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 12),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            menuView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            reviewView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            reviewView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            reviewView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])

        makeLayoutInScrollView()
        makeLayoutIndicatorView()
    }
    
    private func makeLayoutInScrollView() {
        [
            homeView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            homeView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            homeView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    private func makeLayoutIndicatorView() {
        [
            indicatorView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 32),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        scrollView.backgroundColor = .clear
        
        segmentedControl.setAttributedTitle()
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
        
    // TODO: API 연결되면 수정 예정
    // Popup할 때, Slide up 할 때 구분 필요
    func allDataBinding(placeId: String,
                        infoModel: PlaceInfoData?,
                        menuModel: PlaceMenuData?,
                        reviewsModel: PlaceReviewsData?
    ) {
        self.placeId = placeId
        
        homeView.dataBinding(infoModel: infoModel,
                             menuModel: menuModel,
                             reviewsModel: reviewsModel
        )
        
        menuView.dataBinding(menuModel)
        
        reviewView.dataBinding(placeId: placeId,
                               reviewsModel: reviewsModel
        )
        
        guard let reviewsCount = reviewsModel?.commentArray.count else { return }
        
        self.reviewsCount = reviewsCount
    }
    
    private func segmentedControlLabelChange(_ reviews: Int) {
        let reviews = "후기 (\(reviews))"
        
        segmentedControl.setTitle(reviews, forSegmentAt: 2)
    }
    
    private func whenIsLoading() {
        homeView.isHidden = true
        menuView.isHidden = true
        reviewView.isHidden = true
        segmentedControl.isUserInteractionEnabled = false
        indicatorView.isHidden = false
    }
    
    private func whenIsEndLoading() {
        homeView.isHidden = false
        segmentedControl.isUserInteractionEnabled = true
        indicatorView.isHidden = true
    }
    
    @objc private func segmentedChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            activeHomeView()
        case 1:
            activeMenuView()
        case 2:
            activeReviewView()
        default:
            break
        }
    }
    
    func whenViewPopup() {
        segmentedControl.selectedSegmentIndex = 0
        scrollViewSetOffset()
    }
    
    private func activeHomeView() {
        scrollViewSetOffset()
        
        menuView.isHidden = true
        reviewView.isHidden = true
        
        homeView.isHidden = false
    }
    
    private func activeMenuView() {
        homeView.isHidden = true
        reviewView.isHidden = true
        
        menuView.isHidden = false
    }
    
    private func activeReviewView() {
        menuView.isHidden = true
        homeView.isHidden = true
        
        reviewView.isHidden = false
    }
    
    private func scrollViewSetOffset(_ x: Double = 0.0,
                                     _ y: Double = 0.0,
                                     _ animated: Bool = false
    ) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    func scrollViewIsUserIneraction(_ enabled: Bool) {
        scrollView.isUserInteractionEnabled = enabled
        menuView.isUserInteractionEnabled = enabled
        reviewView.isUserInteractionEnabled = enabled
    }
    
    private func handleClosure() {
        homeView.showMoreReviews = { [weak self] in
            self?.segmentedControl.selectedSegmentIndex = 2
            self?.activeReviewView()
        }
        
        reviewView.whenUploadReview = { [weak self] postReviewModel in
            // TODO: HomeView 내부에있는 review view도 layout update 해야할까??
            self?.reviewsCount += 1
            self?.homeView.updateReview(postReviewModel)
            self?.whenUploadReview?(postReviewModel)
        }
        
        reviewView.whenReportReview = { [weak self] commentId in
            self?.reportReview?(commentId)
        }
        
        homeView.reportReview = { [weak self] commentId in
            self?.reportReview?(commentId)
        }
    }
}
