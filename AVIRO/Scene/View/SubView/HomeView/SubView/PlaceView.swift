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
    lazy var topView = PlaceTopView()
    
    lazy var segmetedControlView = PlaceSegmentedControlView()
        
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
    
    var isLoadingDetail: Bool = true {
        didSet {
            if isLoadingDetail {
                segmetedControlView.isLoading = true
            } else {
                segmetedControlView.isLoading = false
            }
        }
    }
    
    private var placeId = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        self.backgroundColor = .clear
        
        [
            topView,
            segmetedControlView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            segmetedControlView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            segmetedControlView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            segmetedControlView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            segmetedControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // TODO: slide up 일때 세부내용 api 호출 후 데이터 바인딩 되는거 만들기
    func summaryDataBinding(placeModel: PlaceTopModel,
                            placeId: String
    ) {
        topView.dataBinding(placeModel)
        self.placeId = placeId
    }
    
    func allDataBinding(infoModel: PlaceInfoData?,
                        menuModel: PlaceMenuData?,
                        reviewsModel: PlaceReviewsData?
    ) {
        
        segmetedControlView.allDataBinding(
            placeId: self.placeId,
            infoModel: infoModel,
            menuModel: menuModel,
            reviewsModel: reviewsModel
        )
        isLoadingDetail = false
    }
    
    private func whenViewPopUp() {
        topView.placeViewStated = .PopUp
        segmetedControlView.whenViewPopup()
    }
    
    private func whenViewSlideUp() {
        topView.placeViewStated = .SlideUp
        segmetedControlView.scrollViewIsUserIneraction(false)
    }
    
    private func whenViewFullUp() {
        topView.placeViewStated = .Full
        segmetedControlView.scrollViewIsUserIneraction(true)
    }
}
