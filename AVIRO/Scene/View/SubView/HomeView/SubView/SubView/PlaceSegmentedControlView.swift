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
    private var homeHeightConstraint: NSLayoutConstraint?
    private var homeBottomConstraint: NSLayoutConstraint?
    
    // Menu Constraint
    private var menuHeightConstraint: NSLayoutConstraint?
    private var menuBottomConstraint: NSLayoutConstraint?
    
    // Review Constraint
    private var reviewHeightConstraint: NSLayoutConstraint?
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !afterInitViewConstrait {
            initViewConstraint()
        }

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
        
        homeView.backgroundColor = .red
        menuView.backgroundColor = .gray
        reviewView.backgroundColor = .magenta
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
            reviewView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        initViewConstraint()
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        
        segmentedControl.setAttributedTitle()
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
    }
    
    private func initViewConstraint() {
        // TODO: 각 각 view 설정 후 적용 예정
        initHomeViewConstrait()
        initMenuViewConstrait()
        initReviewViewConstrait()
        
        afterInitViewConstrait = true
    }
    
    private func initHomeViewConstrait() {
        let homeViewHeight = CGFloat(1500)

        homeHeightConstraint = homeView.heightAnchor.constraint(equalToConstant: homeViewHeight)
        homeHeightConstraint?.isActive = true
        
        homeBottomConstraint = homeView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        homeBottomConstraint?.isActive = true
    }
    
    private func initMenuViewConstrait() {
        let menuViewHeight = CGFloat(1000)

        menuHeightConstraint = menuView.heightAnchor.constraint(equalToConstant: menuViewHeight)
        menuHeightConstraint?.isActive = false
        
        menuBottomConstraint = menuView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        menuBottomConstraint?.isActive = false
    }
    
    private func initReviewViewConstrait() {
        let reviewViewHeight = CGFloat(100)

        reviewHeightConstraint = reviewView.heightAnchor.constraint(equalToConstant: reviewViewHeight)
        reviewHeightConstraint?.isActive = false
        
        reviewBottomConstraint = reviewView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
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
        menuHeightConstraint?.isActive = false
        menuBottomConstraint?.isActive = false
        
        reviewHeightConstraint?.isActive = false
        reviewBottomConstraint?.isActive = false
        
        menuView.isHidden = true
        reviewView.isHidden = true
        
        homeHeightConstraint?.isActive = true
        homeBottomConstraint?.isActive = true
        homeView.isHidden = false
    }
    
    private func activeMenuView() {
        homeHeightConstraint?.isActive = false
        homeHeightConstraint?.isActive = false
        
        reviewHeightConstraint?.isActive = false
        reviewBottomConstraint?.isActive = false
        
        homeView.isHidden = true
        reviewView.isHidden = true
        
        menuHeightConstraint?.isActive = true
        menuBottomConstraint?.isActive = true
        menuView.isHidden = false
    }
    
    private func activeReviewView() {
        menuHeightConstraint?.isActive = false
        menuBottomConstraint?.isActive = false
        
        homeHeightConstraint?.isActive = false
        homeHeightConstraint?.isActive = false
        
        menuView.isHidden = true
        homeView.isHidden = true
        
        reviewHeightConstraint?.isActive = true
        reviewBottomConstraint?.isActive = true
        reviewView.isHidden = false
    }
    
}
