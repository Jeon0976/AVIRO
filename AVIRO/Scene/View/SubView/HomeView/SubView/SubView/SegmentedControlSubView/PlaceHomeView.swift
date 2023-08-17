//
//  PlaceHomeView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/11.
//

import UIKit

final class PlaceHomeView: UIView {
    private lazy var placeInfoView = PlaceInfoView()
    private lazy var placeMenuView = PlaceMenuView()
    private lazy var placeReviewWriteView = PlaceReviewWriteView()
    private lazy var placeReviewsView = PlaceReviewsView()
    
    private var viewHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initPlaceHomeView()
    }
    
    private func makeLayout() {
        self.backgroundColor = .gray6
        // 300 + 200 + 250 + 200
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 950)
        viewHeightConstraint?.isActive = true
        
        [
            placeInfoView,
            placeMenuView,
            placeReviewWriteView,
            placeReviewsView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            placeInfoView.topAnchor.constraint(equalTo: self.topAnchor),
            placeInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeMenuView.topAnchor.constraint(equalTo: placeInfoView.bottomAnchor, constant: 15),
            placeMenuView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeMenuView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeReviewWriteView.topAnchor.constraint(equalTo: placeMenuView.bottomAnchor, constant: 15),
            placeReviewWriteView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeReviewWriteView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            placeReviewsView.topAnchor.constraint(equalTo: placeReviewWriteView.bottomAnchor, constant: 15),
            placeReviewsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeReviewsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            // Test Coce
            
            placeReviewWriteView.heightAnchor.constraint(equalToConstant: 250),
            placeReviewsView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        placeMenuView.backgroundColor = .red
        placeReviewsView.backgroundColor = .brown
        placeReviewWriteView.backgroundColor = .blue
    }
    
    private func initPlaceHomeView() {
        let infoHeight = placeInfoView.frame.height
        let menuHeight = placeMenuView.frame.height
        let reviewWriteHeight = placeReviewWriteView.frame.height
        let reviewsHeight = placeReviewsView.frame.height
        
        // 15 15 15
        let inset: CGFloat = 45
        
        let totalHeight = infoHeight + menuHeight + reviewWriteHeight + reviewsHeight + inset
        viewHeightConstraint?.constant = totalHeight

    }
    
    func dataBinding() {
        placeInfoView.dataBinding()
    }
}
