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
    private lazy var summaryView = PlaceSummaryView()
    
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
                summaryView.isLoadingTopView = isLoadingTopView
                summaryView.isUserInteractionEnabled = false
            } else {
                summaryView.isLoadingTopView = isLoadingTopView
                summaryView.isUserInteractionEnabled = true
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
    var whenFirstPopupView: ((CGFloat) -> Void)?
    var whenFullBack: (() -> Void)?
    var whenShareTapped: (([String]) -> Void)?
    var whenTopViewStarTapped: ((Bool) -> Void)?
    
    // MARK: SegmentedControl
    var afterPhoneButtonTappedWhenNoData: (() -> Void)?
    var afterTimePlusButtonTapped: (() -> Void)?
    var afterTimeTableShowButtonTapped: (() -> Void)?
    var afterHomePageButtonTapped: ((String) -> Void)?
    var afterEditInfoButtonTapped: (() -> Void)?
    
    var editMenu: (() -> Void)?
    
    var whenUploadReview: ((AVIROEnrollCommentDTO) -> Void)?
    var whenAfterEditReview: ((AVIROEditCommenDTO) -> Void)?
    
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
            summaryView,
            segmentedControlView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: self.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            segmentedControlView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            segmentedControlView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmentedControlView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            segmentedControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func topViewHeight() -> CGFloat {
        return summaryView.frame.height
    }
    
    // TODO: slide up 일때 세부내용 api 호출 후 데이터 바인딩 되는거 만들기
    func summaryDataBinding(placeModel: PlaceTopModel,
                            placeId: String,
                            isStar: Bool
    ) {
        self.placeId = placeId
        
        summaryView.dataBinding(placeModel, isStar)
        isLoadingTopView = false
    }
    
    func menuModelBinding(menuModel: PlaceMenuData?) {
        segmentedControlView.refreshMenuData(menuModel)
    }
    
    func updateMapPlace(_ mapPlace: MapPlace) {
        summaryView.updateMapPlace(mapPlace)
    }
  
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
        summaryView.placeViewStated = .PopUp
        segmentedControlView.whenViewPopup()
    }
    
    private func whenViewSlideUp() {
        summaryView.placeViewStated = .SlideUp
        segmentedControlView.scrollViewIsUserIneraction(false)
        
    }
    
    private func whenViewFullUp() {
        summaryView.placeViewStated = .Full
        segmentedControlView.scrollViewIsUserIneraction(true)
    }
    
    private func handleClosure() {
        // MARK: Top View
        summaryView.whenFirstPopupView = { [weak self] firstViewHeight in
            self?.whenFirstPopupView?(firstViewHeight)
        }
        
        summaryView.whenFullBackButtonTapped = { [weak self] in
            self?.whenFullBack?()
        }
        
        summaryView.whenShareButtonTapped = { [weak self] shareObject in
            self?.whenShareTapped?(shareObject)
        }
        
        summaryView.whenStarButtonTapped = { [weak self] selected in
            self?.whenTopViewStarTapped?(selected)
        }
        
        // MARK: Segmented
        // place info
        segmentedControlView.afterPhoneButtonTappedWhenNoData = { [weak self] in
            self?.afterPhoneButtonTappedWhenNoData?()
        }
        
        segmentedControlView.afterTimePlusButtonTapped = { [weak self] in
            self?.afterTimePlusButtonTapped?()
        }
        
        segmentedControlView.afterTimeTableShowButtonTapped = { [weak self] in
            self?.afterTimeTableShowButtonTapped?()
        }
        
        segmentedControlView.afterHomePageButtonTapped = { [weak self] url in
            self?.afterHomePageButtonTapped?(url)
        }
        
        segmentedControlView.afterEditInfoButtonTapped = { [weak self] in
            self?.afterEditInfoButtonTapped?()
        }
        
        // place menu
        segmentedControlView.editMenu = { [weak self] in
            self?.editMenu?()
        }
        
        // place review
        segmentedControlView.whenUploadReview = { [weak self] postReviewModel in
            self?.whenUploadReview?(postReviewModel)
        }
        
        segmentedControlView.whenAfterEditReview = { [weak self] postEditReviewModel in
            self?.whenAfterEditReview?(postEditReviewModel)
        }
        
        segmentedControlView.updateReviewsCount = { [weak self] reviewsCount in
            self?.summaryView.updateReviewsCount(reviewsCount)
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
