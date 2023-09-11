//
//  PlaceInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/10.
//

import UIKit

// MARK: Place View State
enum PlaceViewState {
    case PopUp
    case SlideUp
    case Full
}

final class PlaceView: UIView {
    private lazy var topView = PlaceTopView()
    
    private lazy var segmentedControlView = PlaceSegmentedControlView()
    
    var placeViewStated: PlaceViewState = PlaceViewState.PopUp {
        didSet {
            switch placeViewStated {
            case .PopUp:
                whenViewPopUp()
            case .SlideUp:
                whenViewSlideUp()
            case .Full:
                whenViewFullUp()
            }
            self.layoutIfNeeded()
        }
    }
    
    var isLoadingTopView: Bool = true {
        didSet {
            if isLoadingTopView {
                topView.isLoadingTopView = isLoadingTopView
                topView.isUserInteractionEnabled = false
            } else {
                topView.isLoadingTopView = isLoadingTopView
                topView.isUserInteractionEnabled = true
            }
        }
    }
    
    var isLoadingDetail: Bool = true {
        didSet {
            if isLoadingDetail {
                segmentedControlView.isLoading = isLoadingDetail
            } else {
                segmentedControlView.isLoading = isLoadingDetail
            }
        }
    }
    
    private var placeId = ""
    
    // MARK: Top View
    var whenFullBack: (() -> Void)?
    var whenShareTapped: (([String]) -> Void)?
    var whenTopViewStarTapped: ((Bool) -> Void)?
    
    // MARK: SegmentedControl
    var editPlaceInfo: (() -> Void)?
    var afterTimePlusButtonTapped: (() -> Void)?
    
    var editMenu: (() -> Void)?
    
    var whenUploadReview: ((AVIROCommentPost) -> Void)?
    var whenAfterEditReview: ((AVIROEditCommentPost) -> Void)?
    
    var reportReview: ((String) -> Void)?
    var editMyReview: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        handleClosure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        self.backgroundColor = .clear
        
        [
            topView,
            segmentedControlView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            segmentedControlView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            segmentedControlView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControlView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            segmentedControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func topViewHeight() -> CGFloat {
        return topView.frame.height
    }
    
    // TODO: slide up 일때 세부내용 api 호출 후 데이터 바인딩 되는거 만들기
    func summaryDataBinding(placeModel: PlaceTopModel,
                            placeId: String,
                            isStar: Bool
    ) {
        self.placeId = placeId
        
        topView.dataBinding(placeModel, isStar)
        isLoadingTopView = false
    }
    
//    func infoModelBinding(infoModel: PlaceInfoData?) {
//
//    }
    
    func menuModelBinding(menuModel: PlaceMenuData?) {
        segmentedControlView.refreshMenuData(menuModel)
    }
    
    func updateMapPlace(_ mapPlace: MapPlace) {
        topView.updateMapPlace(mapPlace)
    }
    
//    func reviewsModelBinding(reviewsModel: PlaceReviewsData?) {
//
//    }
  
    func deleteMyReview(_ commentId: String) {
        segmentedControlView.deleteMyReview(commentId)
    }
    
    func allDataBinding(infoModel: PlaceInfoData?,
                        menuModel: PlaceMenuData?,
                        reviewsModel: PlaceReviewsData?
    ) {
        segmentedControlView.allDataBinding(
            placeId: self.placeId,
            infoModel: infoModel,
            menuModel: menuModel,
            reviewsModel: reviewsModel
        )
        isLoadingDetail = false
    }
    
    func editMyReview(_ commentId: String) {
        segmentedControlView.editMyReview(commentId)
    }
    
    private func whenViewPopUp() {
        topView.placeViewStated = .PopUp
        segmentedControlView.whenViewPopup()
    }
    
    private func whenViewSlideUp() {
        topView.placeViewStated = .SlideUp
        segmentedControlView.scrollViewIsUserIneraction(false)
        
    }
    
    private func whenViewFullUp() {
        topView.placeViewStated = .Full
        segmentedControlView.scrollViewIsUserIneraction(true)
    }
    
    private func handleClosure() {
        // MARK: Top View
        topView.whenFullBackButtonTapped = { [weak self] in
            self?.whenFullBack?()
        }
        
        topView.whenShareButtonTapped = { [weak self] shareObject in
            self?.whenShareTapped?(shareObject)
        }
        
        topView.whenStarButtonTapped = { [weak self] selected in
            self?.whenTopViewStarTapped?(selected)
        }
        
        // MARK: Segmented
        segmentedControlView.editPlaceInfo = { [weak self] in
            self?.editPlaceInfo?()
        }
        
        segmentedControlView.afterTimePlusButton = { [weak self] in
            self?.afterTimePlusButtonTapped?()
        }
        
        segmentedControlView.editMenu = { [weak self] in
            self?.editMenu?()
        }
        
        segmentedControlView.whenUploadReview = { [weak self] postReviewModel in
            self?.whenUploadReview?(postReviewModel)
        }
        
        segmentedControlView.whenAfterEditReview = { [weak self] postEditReviewModel in
            self?.whenAfterEditReview?(postEditReviewModel)
        }
        
        segmentedControlView.updateReviewsCount = { [weak self] reviewsCount in
            self?.topView.updateReviewsCount(reviewsCount)
        }
        
        segmentedControlView.reportReview = { [weak self] commentId in
            self?.reportReview?(commentId)
        }
        
        segmentedControlView.editMyReview = { [weak self] commentId in
            self?.editMyReview?(commentId)
        }
    }
    
    func keyboardWillShow(height: CGFloat) {
        segmentedControlView.keyboardWillShow(height: height)
    }
    
    func keyboardWillHide() {
        segmentedControlView.keyboardWillHide()
    }

}
