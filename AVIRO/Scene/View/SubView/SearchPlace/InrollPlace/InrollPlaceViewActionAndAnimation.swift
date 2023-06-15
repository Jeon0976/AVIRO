//
//  InrollPlaceViewObjc.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/15.
//

import UIKit

extension InrollPlaceViewController {
    // MARK: ALL 비건 클릭 시
    @objc func clickedAllVeganButton() {
        // ALL 비건 클릭 on
        if !presenter.allVegan {
            updateVeganState(.allVeganClicked)
            updateViewChanges(.allVeganClicked)
            
            isNegativeReportButton()
        } else {
        // ALL 비건 클릭 off
            updateVeganState(.offAll)
            updateViewChanges(.offAll)
            
            isNegativeReportButton()
        }
    }
    // MARK: 비건 메뉴 포함 클릭 시
    @objc func clickedSomeMenuVeganButton() {
        // 비건 메뉴 포함, 요청하면 비건 둘다 클릭 안 되어있을 때
        if !presenter.someMenuVegan && !presenter.ifRequestVegan {
            updateVeganState(.onlySomeVeganClicked)
            updateViewChanges(.onlySomeVeganClicked)
            
            isNegativeReportButton()
            // 비건 메뉴 포함만 안 되있고, 요청하면 비건은 눌러져있을 때
        } else if !presenter.someMenuVegan && presenter.ifRequestVegan {
            updateVeganState(.someAndReqeustVeganClicked)
            updateViewChanges(.someAndReqeustVeganClicked)

            isNegativeReportButton()
            
            // 둘 다 눌러져 있을 때
        } else if presenter.someMenuVegan && presenter.ifRequestVegan {
            updateVeganState(.onlyRequestVeganClicked)
            updateViewChanges(.onlyRequestVeganClicked)

            isNegativeReportButton()
            
            // 비건 메뉴만 눌러져 있을 때
        } else {
            updateVeganState(.offAll)
            updateViewChanges(.offAll)

            isNegativeReportButton()
        }
    }
    // MARK: 요청하면 비건 클릭 시
    @objc func clickedIfRequestPossibleVebanButton() {
        // 비건 메뉴 포함, 요청하면 비건 둘다 클릭 안 되어있을 때
        if !presenter.ifRequestVegan && !presenter.someMenuVegan {
            updateVeganState(.onlyRequestVeganClicked)
            updateViewChanges(.onlyRequestVeganClicked)

            isNegativeReportButton()
            
            // 비건 메뉴 포함만 눌러져 있을 때
        } else if !presenter.ifRequestVegan && presenter.someMenuVegan {
            updateVeganState(.someAndReqeustVeganClicked)
            updateViewChanges(.someAndReqeustVeganClicked)

            isNegativeReportButton()

            // 둘다 눌러져 있을 때
        } else if presenter.ifRequestVegan && presenter.someMenuVegan {
            updateVeganState(.onlySomeVeganClicked)
            updateViewChanges(.onlySomeVeganClicked)

            isNegativeReportButton()

            // 혼자만 눌러져 있을 때
        } else {
            updateVeganState(.offAll)
            updateViewChanges(.offAll)

            isNegativeReportButton()
        }
    }
    
    // MARK: TableView Cell 데이터 입력 창 추가
    @objc func plusCell() {
        if veganMenuTableView.isHidden {
            presenter.plusCell(false)
            requestVeganTableHeightPlusValueTotal += Int(storeTitleField.intrinsicContentSize.height * 2 + 25)
            requestVeganTableViewHeightConstraint.constant += storeTitleField.intrinsicContentSize.height * 2 + 25
            view.layoutIfNeeded()
        } else {
            presenter.plusCell(true)
            veganTableHeightPlusValueTotal += Int(storeTitleField.intrinsicContentSize.height + 15)
            veganTableViewHeightConstraint.constant += storeTitleField.intrinsicContentSize.height + 15
            view.layoutIfNeeded()
        }
    }
    
    // MARK: Final Report Function
    @objc func reportStore() {
        presenter.reportData(storeTitleField.text ?? "",
                             storeLocationField.text ?? "",
                             storeCategoryField.text ?? "",
                             storePhoneField.text ?? ""
        )
        
        refreshData()
        resetTable()
        
        tabBarController?.selectedIndex = 0
    }
}
