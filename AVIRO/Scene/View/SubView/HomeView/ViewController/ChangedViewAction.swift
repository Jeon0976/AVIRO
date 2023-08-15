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
        
        searchTextFieldTopConstraint?.constant = 16

        tabBarController.hiddenTabBar(false)
        settingPlaceView()
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func settingPlaceView() {
        homeButtonIsHidden(false)
        viewNaviButtonHidden(true)

        placeViewTopConstraint?.constant = 0
    }
    
    func placeViewPopUp() {
        placeView.topView.placeViewStated = .PopUp
        homeButtonIsHidden(false)
        viewNaviButtonHidden(true)
        searchTextFieldTopConstraint?.constant = 16

        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        
        let tabBarHeight = tabBarController.tabBar.frame.height
    
        tabBarController.hiddenTabBar(true)

        let height = -placeView.topView.frame.height
        updatePlacePopupViewHeight(height)
        
        placeViewTopConstraint?.constant = placePopupViewHeight + tabBarHeight
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewSlideUp() {
        moveToCameraWhenSlideUpView()
        homeButtonIsHidden(true)

        placeView.topView.placeViewStated = .SlideUp
        placeView.segmetedControlView.scrollView.isUserInteractionEnabled = false
        
        placeViewTopConstraint?.constant = -self.view.frame.height * 2/3
        
        searchTextFieldTopConstraint?.constant = -120
        viewNaviButtonHidden(false)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewPopUpAfterInitPlacePopViewHeight() {
        homeButtonIsHidden(false)
        viewNaviButtonHidden(true)
        moveToCameraWhenPopupView()
        placeView.topView.placeViewStated = .PopUp
        
        guard let tabBarController = self.tabBarController as? TabBarViewController else { return }
        
        let tabBarHeight = tabBarController.tabBar.frame.height
        
        searchTextFieldTopConstraint?.constant = 16

        placeViewTopConstraint?.constant = placePopupViewHeight + tabBarHeight
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewFullUp() {
        placeView.topView.placeViewStated = .Full
        placeView.segmetedControlView.scrollView.isUserInteractionEnabled = true

        viewNaviButtonHidden(true)

        placeViewTopConstraint?.constant = -self.view.safeAreaLayoutGuide.layoutFrame.height
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
