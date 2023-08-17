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
                topView.placeViewStated = .PopUp
            case .SlideUp:
                topView.placeViewStated = .SlideUp
            case .Full:
                topView.placeViewStated = .Full
            }
            self.layoutIfNeeded()
        }
    }
    
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
            segmetedControlView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    // TODO: slide up 일때 세부내용 api 호출 후 데이터 바인딩 되는거 만들기
    func dataBinding(_ placeModel: PlaceTopModel) {
        topView.dataBinding(placeModel)
        segmetedControlView.dataBinding()
    }
}
