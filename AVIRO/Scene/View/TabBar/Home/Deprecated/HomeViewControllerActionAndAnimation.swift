////
////  HomeViewControllerButtonAction.swift
////  AVIRO
////
////  Created by 전성훈 on 2023/06/15.
////
//
//import UIKit
//
//import NMapsMap
//
//// MARK: 버튼 클릭 Animation & Action
//extension HomeViewController {
//
//    // MARK: 내 위치 최신화 버튼 클릭 시
//    @objc func refreshMyLocationTouchDown(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1, animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            sender.layer.opacity = 0.4
//        })
//    }
//    
//    @objc func refreshMyLocationOnlyPopUp(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.05, animations: {
//            sender.transform = CGAffineTransform.identity
//            sender.layer.opacity = 1
//        })
//    }
//    
//    @objc func refreshMyLocation(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.05, animations: {
//            sender.transform = CGAffineTransform.identity
//            sender.layer.opacity = 1
//        }, completion: { [weak self] _ in
//            self?.presenter.locationUpdate()
////            self?.presenter.loadVeganData()
////            self?.afterSaveAllPlace = false
//
//        })
//    }
//    
//    // MARK: firstPopupView Delete Animation
//    @objc func firstPopupViewDelete() {
//        UIView.animate(withDuration: 0.15, animations: {
//            self.blurEffectView.alpha = 0
//            self.firstPopupView.frame.origin.y = self.view.frame.height
//        }, completion: { [weak self] _ in
//            // 왜? hidden처리 안 하면,
//            // marker클릭할 때 firstPopupView도 같이 올라옴??
//            self?.firstPopupView.isHidden = true
//            self?.blurEffectView.isHidden = true
//        })
//    }
//    
//    // MARK: firstPopUpView Report Animation
//    @objc func firstPopupViewTouchDown(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1, animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            sender.layer.opacity = 0.4
//        })
//    }
//    
//    @objc func firstPopupViewReportOnlyPopUp(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.05, animations: {
//            sender.transform = CGAffineTransform.identity
//            sender.layer.opacity = 1
//        })
//    }
//    
//    @objc func firstPopupViewReport(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.05, animations: {
//            sender.transform = CGAffineTransform.identity
//            sender.layer.opacity = 1
//        }, completion: {  [weak self] _ in
//            self?.firstPopupView.isHidden = true
//            self?.blurEffectView.isHidden = true
//
//            self?.tabBarController?.selectedIndex = 2
//        })
//    }
//
////    // MARK: Pan Gesture 설정
////    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer) {
////        let translation = recognizer.translation(in: storeInfoView)
////        let velocity = recognizer.velocity(in: storeInfoView)
////        
////        let minHeight = view.frame.minY
////        let maxHeight = view.frame.maxY
////        
////        let currentHeight = storeInfoView.frame.height
////        
////        if recognizer.state == .changed {
////            let newHeight = currentHeight - translation.y
////            if newHeight >= minHeight && newHeight <= maxHeight {
////                storeInfoView.frame.size.height = newHeight
////                storeInfoView.frame.origin.y = self.view.frame.height - newHeight + 32
////                
////                recognizer.setTranslation(CGPoint.zero, in: self.storeInfoView)
////                
////                let newAlpha = (newHeight - minHeight) / (maxHeight - minHeight)
////                
////                storeInfoView.entireView.alpha = newAlpha
////                storeInfoView.activityIndicator.alpha = newAlpha
////            }
////        } else if recognizer.state == .ended {
////            UIView.animate(withDuration: 0.3, animations: {
////                if velocity.y >= 0 {
////                    self.storeInfoView.frame.origin.y = self.view.frame.size.height
////
////                    self.storeInfoView.entireView.alpha = 0
////                    self.storeInfoView.activityIndicator.alpha = 0
////                } else {
////                    self.storeInfoView.frame.size.height = maxHeight + 32
////                    self.storeInfoView.frame.origin.y = self.view.frame.origin.y
////
////                    self.storeInfoView.entireView.alpha = 1
////                    self.storeInfoView.activityIndicator.alpha = 1
////                }
////                self.view.layoutIfNeeded()
////            }, completion: { [weak self] _ in
////                if !(velocity.y >= 0) {
////                    guard let placeId = self?.storeInfoView.placeId else { return }
////                    self?.pushDetailViewController(placeId)
////                }
////            })
////        }
////    }
//}
