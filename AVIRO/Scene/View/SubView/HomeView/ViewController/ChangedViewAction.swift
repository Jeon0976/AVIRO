//
//  ChangedViewAction.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/14.
//

import UIKit

extension HomeViewController {
    func whenViewWillAppearInitPlaceView() {
        settingPlaceView()
    }
    
    func whenClosedPlaceView() {
        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        
        presenter.resetPreviouslyTouchedMarker()
        tabBarController.hiddenTabBar(false)
        settingPlaceView()
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func settingPlaceView() {
        homeButtonIsHidden(false)
        
        placeViewTopConstraint?.isActive = false
        placeViewTopConstraint = placeView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        placeViewTopConstraint?.isActive = true
    }
    
    func placeViewPopUp() {
        placeView.topView.placeViewStated = .PopUp
        
        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        
        let tabBarHeight = tabBarController.tabBar.frame.height
    
        tabBarController.hiddenTabBar(true)

        placePopupViewHeight = -placeView.topView.frame.height
        placeViewTopConstraint?.constant = placePopupViewHeight + tabBarHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewSlideUp() {
        moveToCameraWhenSlideUpView()
        homeButtonIsHidden(true)

        placeView.topView.placeViewStated = .SlideUp
        placeView.segmetedControlView.scrollView.isUserInteractionEnabled = false
        placeViewTopConstraint?.constant = -self.view.frame.height * 2/3
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewPopUpAfterInitPlacePopViewHeight() {
        homeButtonIsHidden(false)

        placeView.topView.placeViewStated = .PopUp
        
        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        
        let tabBarHeight = tabBarController.tabBar.frame.height
        
        placeViewTopConstraint?.constant = placePopupViewHeight + tabBarHeight
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewFullUp() {
        placeView.topView.placeViewStated = .Full
        placeView.segmetedControlView.scrollView.isUserInteractionEnabled = true

        placeViewTopConstraint?.constant = -self.view.safeAreaLayoutGuide.layoutFrame.height
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
