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
        viewNaviButtonHidden(true)
        searchTextFieldTopConstraint?.constant = 16

        placeViewTopConstraint?.constant = 0
    }
    
    func placeViewPopUp() {
        placeView.placeViewStated = .PopUp
        homeButtonIsHidden(false)
        viewNaviButtonHidden(true)
        searchTextFieldTopConstraint?.constant = 16
        
        let height = -placeView.topView.frame.height
        
        placeViewTopConstraint?.constant = height
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewSlideUp() {
        moveToCameraWhenSlideUpView()
        homeButtonIsHidden(true)

        placeView.placeViewStated = .SlideUp
        placeView.isLoadingDetail = true
        
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
        placeView.placeViewStated = .PopUp
        
        searchTextFieldTopConstraint?.constant = 16

        let height = -placeView.topView.frame.height
        
        placeViewTopConstraint?.constant = height
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func placeViewFullUp() {
        placeView.placeViewStated = .Full

        viewNaviButtonHidden(true)
        
        placeViewTopConstraint?.constant = -self.view.safeAreaLayoutGuide.layoutFrame.height
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
