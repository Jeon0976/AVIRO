//
//  PlaceInfoView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/10.
//

import UIKit

final class PlaceView: UIView {
    lazy var topView = PlaceTopView()
    
    lazy var segmetedControlView = PlaceSegmentedControlView()
        
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
    
    func dataBinding(_ placeModel: PlaceTopModel) {
        topView.dataBinding(placeModel)
    }
}
