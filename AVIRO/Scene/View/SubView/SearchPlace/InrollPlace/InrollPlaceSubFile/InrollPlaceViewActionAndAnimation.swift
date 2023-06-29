//
//  InrollPlaceViewObjc.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/15.
//

import UIKit

extension InrollPlaceViewController {
    // MARK: Button touch down
    // Scroll View가 움직일때 .touchDown만 적용되고 나머지는 적용 안되는 버그 발생
    // ScrollViewDelegate 사용하려고했는데 안되서 아래와 같이 처리
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.layer.opacity = 0.4
        }, completion: { [weak self] _ in
            if sender == self?.allVegan {
                self?.clickedAllVeganButton(sender)
            } else if sender == self?.someMenuVegan {
                self?.clickedSomeMenuVeganButton(sender)
            } else {
                self?.clickedIfRequestPossibleVebanButton(sender)
            }
        })
    }
    
    // MARK: ALL 비건 클릭 시
    func clickedAllVeganButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        }, completion: { [weak self] _ in
            // ALL 비건 클릭 on
            if !(self?.presenter.allVegan ?? false) {
                self?.updateVeganState(.allVeganClicked)
                self?.updateViewChanges(.allVeganClicked)

                self?.isNegativeReportButton()
            } else {
            // ALL 비건 클릭 off
                self?.updateVeganState(.offAll)
                self?.updateViewChanges(.offAll)

                self?.isNegativeReportButton()
            }
        })
    }
    // MARK: 비건 메뉴 포함 클릭 시
    func clickedSomeMenuVeganButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        }, completion: { [weak self] _ in
            // 비건 메뉴 포함, 요청하면 비건 둘다 클릭 안 되어있을 때
            if !(self?.presenter.someMenuVegan ?? false) && !(self?.presenter.ifRequestVegan ?? false) {
                self?.updateVeganState(.onlySomeVeganClicked)
                self?.updateViewChanges(.onlySomeVeganClicked)
                
                self?.isNegativeReportButton()
                // 비건 메뉴 포함만 안 되있고, 요청하면 비건은 눌러져있을 때
            } else if !(self?.presenter.someMenuVegan ?? false ) && (self?.presenter.ifRequestVegan ?? false) {
                self?.updateVeganState(.someAndReqeustVeganClicked)
                self?.updateViewChanges(.someAndReqeustVeganClicked)

                self?.isNegativeReportButton()
                
                // 둘 다 눌러져 있을 때
            } else if (self?.presenter.someMenuVegan ?? false) && (self?.presenter.ifRequestVegan ?? false) {
                self?.updateVeganState(.onlyRequestVeganClicked)
                self?.updateViewChanges(.onlyRequestVeganClicked)

                self?.isNegativeReportButton()
                
                // 비건 메뉴만 눌러져 있을 때
            } else {
                self?.updateVeganState(.offAll)
                self?.updateViewChanges(.offAll)

                self?.isNegativeReportButton()
            }
        })
    }
    // MARK: 요청하면 비건 클릭 시
    func clickedIfRequestPossibleVebanButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        }, completion: { [weak self] _ in
            // 비건 메뉴 포함, 요청하면 비건 둘다 클릭 안 되어있을 때
            if !(self?.presenter.ifRequestVegan ?? false) && !(self?.presenter.someMenuVegan ?? false) {
                self?.updateVeganState(.onlyRequestVeganClicked)
                self?.updateViewChanges(.onlyRequestVeganClicked)

                self?.isNegativeReportButton()
                
                // 비건 메뉴 포함만 눌러져 있을 때
            } else if !(self?.presenter.ifRequestVegan ?? false) && (self?.presenter.someMenuVegan ?? false) {
                self?.updateVeganState(.someAndReqeustVeganClicked)
                self?.updateViewChanges(.someAndReqeustVeganClicked)

                self?.isNegativeReportButton()

                // 둘다 눌러져 있을 때
            } else if (self?.presenter.ifRequestVegan ?? false) && (self?.presenter.someMenuVegan ?? false) {
                self?.updateVeganState(.onlySomeVeganClicked)
                self?.updateViewChanges(.onlySomeVeganClicked)

                self?.isNegativeReportButton()

                // 혼자만 눌러져 있을 때
            } else {
                self?.updateVeganState(.offAll)
                self?.updateViewChanges(.offAll)

                self?.isNegativeReportButton()
            }
        })
    }
    
    // MARK: TableView Cell 데이터 입력 창 추가
    @objc func plusCell() {
        if veganMenuTableView.isHidden {
            
            presenter.plusCell(false)
            
            requestVeganTableHeightPlusValue +=
            Int(storeTitleField.intrinsicContentSize.height * 2 + Layout.InrollView.requestTableConstant)
            
            requestVeganTableViewHeightConstraint.constant +=
            storeTitleField.intrinsicContentSize.height * 2 + Layout.InrollView.requestTableConstant
            
            view.layoutIfNeeded()
        } else {
            
            presenter.plusCell(true)
            
            veganTableHeightPlusValue +=
            Int(storeTitleField.intrinsicContentSize.height + Layout.InrollView.notRequestTableConstant)
            
            veganTableViewHeightConstraint.constant +=
            storeTitleField.intrinsicContentSize.height + Layout.InrollView.notRequestTableConstant
            
            view.layoutIfNeeded()
        }
    }
    
    // MARK: Final Report Function
    @objc func reportStore() {
        presenter.reportData(storeTitleField.text ?? "",
                             storeLocationField.text ?? "",
                             storeCategoryField.text ?? "",
                             storePhoneField.text ?? ""
        ) { veganModel in
            presenter.postData(veganModel)
        }
        
        refreshData()
        resetTable()
        
        tabBarController?.selectedIndex = 0
    }
}
