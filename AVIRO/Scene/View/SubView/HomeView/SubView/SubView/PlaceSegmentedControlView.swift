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
    
    lazy var scrollView = UIScrollView()
        
    // Home Constraint
    private var homeBottomConstraint: NSLayoutConstraint?
    
    // Menu Constraint
    private var menuBottomConstraint: NSLayoutConstraint?
    
    // Review Constraint
    private var reviewBottomConstraint: NSLayoutConstraint?
    
    private var afterInitViewConstrait = false
    
    var whenFullView: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        makeLayoutInScrollView()
        
        [
            segmentedControl,
            scrollView
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
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func makeLayoutInScrollView() {
        [
            homeView,
            menuView,
            reviewView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            homeView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            menuView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            menuView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        
            reviewView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            reviewView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            reviewView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // test
            menuView.heightAnchor.constraint(equalToConstant: 400),
            reviewView.heightAnchor.constraint(equalToConstant: 1000)
        ])
        
        menuView.backgroundColor = .red
        reviewView.backgroundColor = .gray
        
        initViewConstraint()
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        scrollView.backgroundColor = .clear
        
        segmentedControl.setAttributedTitle()
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func dataBinding() {
        homeView.dataBinding()
        
        segmentedControlChange(65)
    }
    
    private func segmentedControlChange(_ reviews: Int) {
        let reviews = "후기 (\(reviews))"
        
        segmentedControl.setTitle(reviews, forSegmentAt: 2)
    }
    
    private func initViewConstraint() {
        // TODO: 각 각 view 설정 후 적용 예정
        initHomeViewConstrait()
        initMenuViewConstrait()
        initReviewViewConstrait()
        
        menuView.isHidden = true
        reviewView.isHidden = true
    }
    
    private func initHomeViewConstrait() {
        
        homeBottomConstraint = homeView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -80)
        homeBottomConstraint?.isActive = true
    }
    
    private func initMenuViewConstrait() {
        menuBottomConstraint = menuView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -80)
        menuBottomConstraint?.isActive = false
    }
    
    private func initReviewViewConstrait() {
        reviewBottomConstraint = reviewView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -80)
        reviewBottomConstraint?.isActive = false
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
    
    private func activeHomeView() {
        menuBottomConstraint?.isActive = false
        reviewBottomConstraint?.isActive = false
        
        menuView.isHidden = true
        reviewView.isHidden = true
        
        homeBottomConstraint?.isActive = true
        homeView.isHidden = false
    }
    
    private func activeMenuView() {
        homeBottomConstraint?.isActive = false
        reviewBottomConstraint?.isActive = false
        
        homeView.isHidden = true
        reviewView.isHidden = true
        
        menuBottomConstraint?.isActive = true
        menuView.isHidden = false
    }
    
    private func activeReviewView() {
        menuBottomConstraint?.isActive = false
        homeBottomConstraint?.isActive = false
        
        menuView.isHidden = true
        homeView.isHidden = true
        
        reviewBottomConstraint?.isActive = true
        reviewView.isHidden = false
    }
    
}
