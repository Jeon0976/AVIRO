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
    
    private lazy var indicatorView = UIActivityIndicatorView()
    
    private lazy var scrollView = UIScrollView()
        
    // Home Constraint
//    private var homeBottomConstraint: NSLayoutConstraint?
        
    // Review Constraint
//    private var reviewBottomConstraint: NSLayoutConstraint?
    
    private var homeBottomConstraint: NSLayoutConstraint?

    private var afterInitViewConstrait = false
    
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
        
        
//        print(self.frame.height - segmentedControl.frame.height)
//        homeBottomConstraint?.constant = self.frame.height - segmentedControl.frame.height
    }
    
    private func makeLayout() {
        makeLayoutInScrollView()
        
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
            menuView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            reviewView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            reviewView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            reviewView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])

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
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -80)
        ])
        
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        scrollView.backgroundColor = .clear
        
        segmentedControl.setAttributedTitle()
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    var test = true
    // TODO: API 연결되면 수정 예정
    // Popup할 때, Slide up 할 때 구분 필요
    func dataBinding() {
        let mock = [
            MenuArray(menuType: "vegan", menu: "11", price: "11", howToRequest: "한줄\n두줄dawdawdawdawdawdawdawdklajwdlkjawdlkjawkdlwaj", isCheck: true),
            MenuArray(menuType: "vegan", menu: "22", price: "11", howToRequest: "한줄\n두줄dawdawdawdawdawdawdawdklajwdlkjawdlkjawkdlwaj", isCheck: true),
            MenuArray(menuType: "vegan", menu: "33", price: "11", howToRequest: "한줄\n두줄dawdawdawdawdawdawdawdklajwdlkjawdlkjawkdlwaj", isCheck: true),
            MenuArray(menuType: "vegan", menu: "44", price: "11", howToRequest: "한줄\n두줄dawdawdawdawdawdawdawdklajwdlkjawdlkjawkdlwaj", isCheck: true),
            MenuArray(menuType: "vegan", menu: "55", price: "11", howToRequest: "한줄\n두줄dawdawdawdawdawdawdawdklajwdlkjawdlkjawkdlwaj", isCheck: true),
            MenuArray(menuType: "needToRequest", menu: "포테이토 피자", price: "17,000", howToRequest: "테스트", isCheck: true),
            MenuArray(menuType: "needToRequest", menu: "포테이토 피자", price: "17,000", howToRequest: "테스트", isCheck: true),
            MenuArray(menuType: "needToRequest", menu: "포테이22토 피자", price: "17,000", howToRequest: "테스트", isCheck: true),
            MenuArray(menuType: "needToRequest", menu: "포테이토11 피자", price: "17,000", howToRequest: "테스트", isCheck: true),
            MenuArray(menuType: "needToRequest", menu: "포테33이토 피자", price: "17,000", howToRequest: "테스트", isCheck: true)
        ]
        
        menuView.dataBinding(mock)
        
        homeView.dataBinding(mock)
        
        segmentedControlLabelChange(65)
        
    }
    
    // TODO: API 완료 되면 변경 예정
    private func segmentedControlLabelChange(_ reviews: Int) {
        let reviews = "후기 (\(reviews))"
        
        segmentedControl.setTitle(reviews, forSegmentAt: 2)
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
        activeHomeView()
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
    
    private func scrollViewSetOffset(_ x: Double = 0.0,_ y: Double = 0.0, _ animated: Bool = false) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    func scrollViewIsUserIneraction(_ enabled: Bool) {
        scrollView.isUserInteractionEnabled = enabled
    }
}
