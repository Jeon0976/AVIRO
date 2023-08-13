//
//  PlaceTopView.swift
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

final class PlaceTopView: UIView {
    
    // MARK: When Pop Up
    lazy var guideBar: UIView = {
        let guide = UIView()
        
        guide.backgroundColor = .gray3
        guide.layer.cornerRadius = 2.5
        
        return guide
    }()
    
    lazy var placeIcon: UIImageView = {
        let icon = UIImageView()
        
        icon.backgroundColor = .gray3
        icon.layer.cornerRadius = 10
        
        return icon
    }()
    
    lazy var placeTitle: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 24, weight: .heavy)

        
        return label
    }()
    
    lazy var placeCategory: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray2
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .medium)

        
        return label
    }()

    lazy var distanceIcon: UIImageView = {
        let icon = UIImageView()
        
        icon.image = UIImage(named: "PlaceViewMap")
        
        return icon
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "0m"
        
        return label
    }()
    
    lazy var reviewsIcon: UIImageView = {
        let icon = UIImageView()
        
        icon.image = UIImage(named: "PlaceReview")
        
        return icon
    }()
    
    lazy var reviewsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.text = "0개"
        
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 3
        label.textAlignment = .left

        return label
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "star"), for: .normal)
        button.setImage(UIImage(named: "selectedStar"), for: .selected)
        
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "share"), for: .normal)
        
        return button
    }()
    
    // MARK: When Slide Up
    lazy var whenSlideTopLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    lazy var whenSlideMiddleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .gray0
        label.numberOfLines = 3
        
        return label
    }()
    
    lazy var whenSlideBottomLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    // MARK: When Full
    lazy var whenFullBackButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "DownBack"), for: .normal)
        
        return button
    }()
    
    lazy var whenFullTitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 3
        
        return label
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    private var isInit = true
    
    var placeViewStated: PlaceViewState = PlaceViewState.PopUp {
        didSet {
            switch placeViewStated {
            case .PopUp:
                whenSlideUpViewIsShowUI(show: false)
                whenFullHeightViewIsShowUI(show: false)
                whenPopUpViewIsShowUI(show: true)
                
                whenPopUpViewHeight()
            case .SlideUp:
                whenFullHeightViewIsShowUI(show: false)
                whenPopUpViewIsShowUI(show: false)
                whenSlideUpViewIsShowUI(show: true)

                whenSlideUpViewHeight()
            case .Full:
                whenSlideUpViewIsShowUI(show: false)
                whenPopUpViewIsShowUI(show: false)
                whenFullHeightViewIsShowUI(show: true)

                whenFullHeightViewHeight()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isInit {
            whenPopUpViewHeight()
            isInit = false
        }
    }
    
    private func makeLayout() {
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        viewHeightConstraint?.isActive = true
        
        whenPopUpViewLayout()
        whenSlideUpViewLayout()
        whenFullHeightViewLayout()
    }
    
    private func makeAttribute() {
        self.backgroundColor = .gray7
        
        switchViewCorners(true)
    }
    
    private func switchViewCorners(_ switch: Bool) {
        if `switch` {
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    // MARK: When Popup View Layout
    private func whenPopUpViewLayout() {
        [
            guideBar,
            placeIcon,
            placeTitle,
            placeCategory,
            distanceIcon,
            distanceLabel,
            reviewsIcon,
            reviewsLabel,
            addressLabel,
            starButton,
            shareButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // guide
            guideBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            guideBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            guideBar.heightAnchor.constraint(equalToConstant: 5),
            guideBar.widthAnchor.constraint(equalToConstant: 36),
            
            // placeIcon
            placeIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            placeIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            placeIcon.widthAnchor.constraint(equalToConstant: 52),
            placeIcon.heightAnchor.constraint(equalToConstant: 52),
            
            // placeTitle
            placeTitle.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            placeTitle.topAnchor.constraint(equalTo: placeIcon.topAnchor),

           // placeCategory
            placeCategory.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -16),
            placeCategory.centerYAnchor.constraint(equalTo: placeTitle.centerYAnchor),
            placeCategory.leadingAnchor.constraint(equalTo: placeTitle.trailingAnchor, constant: 5),
            
            // distanceIcon
            distanceIcon.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            distanceIcon.topAnchor.constraint(equalTo: placeTitle.bottomAnchor, constant: 7),
            
            // distanceLebel
            distanceLabel.leadingAnchor.constraint(equalTo: distanceIcon.trailingAnchor, constant: 4),
            distanceLabel.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
            
            // reviewsIcon
            reviewsIcon.leadingAnchor.constraint(equalTo: distanceLabel.trailingAnchor, constant: 10),
            reviewsIcon.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
            
            // reviewsLabel
            reviewsLabel.leadingAnchor.constraint(equalTo: reviewsIcon.trailingAnchor, constant: 4),
            reviewsLabel.centerYAnchor.constraint(equalTo: distanceIcon.centerYAnchor),
            
            // addressLabel
            addressLabel.topAnchor.constraint(equalTo: distanceIcon.bottomAnchor, constant: 7),
            addressLabel.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -16),
            
            // star Button
            starButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            starButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            starButton.widthAnchor.constraint(equalToConstant: 38),
            starButton.heightAnchor.constraint(equalToConstant: 38),

            // share Button
            shareButton.topAnchor.constraint(equalTo: starButton.bottomAnchor),
            shareButton.trailingAnchor.constraint(equalTo: starButton.trailingAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 38),
            shareButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    // MARK: When PopUp View is Show UI
    private func whenPopUpViewIsShowUI(show: Bool) {
        let show = !show
        
        guideBar.isHidden = show
        placeIcon.isHidden = show
        placeTitle.isHidden = show
        placeCategory.isHidden = show
        distanceIcon.isHidden = show
        distanceLabel.isHidden = show
        reviewsIcon.isHidden = show
        reviewsLabel.isHidden = show
        addressLabel.isHidden = show
        starButton.isHidden = show
        shareButton.isHidden = show
    }
    
    // MARK: When Popup View Height
    private func whenPopUpViewHeight() {
        let guideBarHeight = guideBar.frame.height
        let placeIconHeight = placeIcon.frame.height
        let addressHeight = addressLabel.frame.height
        // 5 + 20 + 7 + 7 + 15
        let inset: CGFloat = 74
        
        let totalHeight = guideBarHeight + placeIconHeight + addressHeight + inset
                
        viewHeightConstraint?.constant = totalHeight
    }
    
    // MARK: When Slideup View Layout
    private func whenSlideUpViewLayout() {
        [
            whenSlideTopLabel,
            whenSlideMiddleLabel,
            whenSlideBottomLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            whenSlideTopLabel.topAnchor.constraint(equalTo: placeIcon.topAnchor),
            whenSlideTopLabel.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            whenSlideTopLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -15),
            
            whenSlideMiddleLabel.topAnchor.constraint(equalTo: whenSlideTopLabel.bottomAnchor, constant: 5),
            whenSlideMiddleLabel.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            whenSlideMiddleLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -15),
            
            whenSlideBottomLabel.topAnchor.constraint(equalTo: whenSlideMiddleLabel.bottomAnchor, constant: 7.5),
            whenSlideBottomLabel.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 15),
            whenSlideBottomLabel.trailingAnchor.constraint(equalTo: starButton.leadingAnchor, constant: -15)
        ])
        
        whenSlideTopLabel.isHidden = true
        whenSlideMiddleLabel.isHidden = true
        whenSlideBottomLabel.isHidden = true
    }
    
    private func whenSlideUpViewIsShowUI(show: Bool) {
        let show = !show
        
        guideBar.isHidden = show
        placeIcon.isHidden = show
        starButton.isHidden = show
        shareButton.isHidden = show
        whenSlideTopLabel.isHidden = show
        whenSlideMiddleLabel.isHidden = show
        whenSlideBottomLabel.isHidden = show
    }
    
    private func whenSlideUpViewHeight() {
        let topHeight = whenSlideTopLabel.frame.height
        let middleHeight = whenSlideMiddleLabel.frame.height
        let bottomHeight = whenSlideBottomLabel.frame.height
        // 30 + 5 + 7.5 + 28
        let inset: CGFloat = 70.5
        
        let totalHeight = topHeight + middleHeight + bottomHeight + inset
        
        viewHeightConstraint?.constant = topHeight
    }
    
    // MARK: When Full Height View
    private func whenFullHeightViewLayout() {
        [
            whenFullBackButton,
            whenFullTitle
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            whenFullBackButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            whenFullBackButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            
            whenFullTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            whenFullTitle.topAnchor.constraint(equalTo: whenFullBackButton.topAnchor),
            whenFullTitle.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        whenFullBackButton.isHidden = true
        whenFullTitle.isHidden = true
    }
    
    private func whenFullHeightViewIsShowUI(show: Bool) {
        let show = !show

        whenFullBackButton.isHidden = show
        whenFullTitle.isHidden = show
    }
    
    private func whenFullHeightViewHeight() {
        let titleHeight = whenFullTitle.frame.height
        
        // 18 + 18
        let inset: CGFloat = 36
        
        let totalHeight = titleHeight + inset
        
        viewHeightConstraint?.constant = totalHeight
    }
}
