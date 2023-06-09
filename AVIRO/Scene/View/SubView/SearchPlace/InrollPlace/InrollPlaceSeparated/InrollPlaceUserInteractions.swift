//
//  InrollPlaceUserInteraction.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/08.
//

import UIKit

enum VeganState {
    case allVeganClicked
    case onlySomeVeganClicked
    case onlyRequestVeganClicked
    case someAndReqeustVeganClicked
    case offAll
}

extension InrollPlaceViewController {
    // MARK: Button 클릭 시 UI 분기 처리
    func updateVeganState(_ state: VeganState) {
        let inactiveState = ("No", UIColor.separateLine, UIColor.white, UIColor.separateLine?.cgColor)
        let activeState = ("", UIColor.plusButton, UIColor.mainTitle!, UIColor.mainTitle?.cgColor)
        
        var allVeganState = inactiveState
        var someMenuVeganState = inactiveState
        var ifRequestVeganState = inactiveState
        
        switch state {
        case .allVeganClicked:
            allVeganState = activeState
            someMenuVeganState = inactiveState
            ifRequestVeganState = inactiveState
            
            presenter.buttonChecked(true, false, false)
        case .onlySomeVeganClicked:
            someMenuVeganState = activeState
            allVeganState = inactiveState
            ifRequestVeganState = inactiveState
            
            presenter.buttonChecked(false, true, false)
        case .onlyRequestVeganClicked:
            ifRequestVeganState = activeState
            allVeganState = inactiveState
            someMenuVeganState = inactiveState
            
            presenter.buttonChecked(false, false, true)
        case .someAndReqeustVeganClicked:
            someMenuVeganState = activeState
            ifRequestVeganState = activeState
            allVeganState = inactiveState
            
            presenter.buttonChecked(false, true, true)
        case .offAll:
            allVeganState = inactiveState
            someMenuVeganState = inactiveState
            ifRequestVeganState = inactiveState
            presenter.buttonChecked(false, false, false)
        }
        
        allVegan.setImage(UIImage(named: "올비건" + allVeganState.0), for: .normal)
        allVegan.setTitleColor(allVeganState.1, for: .normal)
        allVegan.backgroundColor = allVeganState.2
        allVegan.layer.borderColor = allVeganState.3
        
        someMenuVegan.setImage(UIImage(named: "썸비건" + someMenuVeganState.0), for: .normal)
        someMenuVegan.setTitleColor(someMenuVeganState.1, for: .normal)
        someMenuVegan.backgroundColor = someMenuVeganState.2
        someMenuVegan.layer.borderColor = someMenuVeganState.3
        
        ifRequestPossibleVegan.setImage(UIImage(named: "요청비건" + ifRequestVeganState.0), for: .normal)
        ifRequestPossibleVegan.setTitleColor(ifRequestVeganState.1, for: .normal)
        ifRequestPossibleVegan.backgroundColor = ifRequestVeganState.2
        ifRequestPossibleVegan.layer.borderColor = ifRequestVeganState.3
    }
    
    // MARK: 버튼 클릭 시 TableView Layout 처리
    func updateViewChanges(_ state: VeganState) {
        switch state {
        case .allVeganClicked, .onlySomeVeganClicked:
            showVeganTable()
        case .onlyRequestVeganClicked, .someAndReqeustVeganClicked:
            showHowToRequestVeganTable()
        case .offAll:
            resetTable()
        }
    }
    
    // MARK: Show Vegan Table
    private func showVeganTable() {
        activeHeaderView(true)
        activeTableViewLayout(request: false)
        resetTableView(request: false)
        view.layoutIfNeeded()
        hideTableView(howToRequestVeganMenuTableView) { [weak self] in
            self?.showViewWithAnimation(self?.veganMenuHeaderStackView ?? UIView(),
                                        self?.veganMenuTableView ?? UIView()
            )
        }

    }
    
    // MARK: Show How To Request Vegan Table
    private func showHowToRequestVeganTable() {
        activeHeaderView(true)
        activeTableViewLayout(request: true)
        resetTableView(request: true)
        view.layoutIfNeeded()
        hideTableView(veganMenuTableView) { [weak self] in
            self?.showViewWithAnimation(self?.veganMenuHeaderStackView ?? UIView(),
                                        self?.howToRequestVeganMenuTableView ?? UIView()
            )
        }
    }
    
    // MARK: Reset Table
    private func resetTable() {
        hideHeaderView()
        hideTableView(veganMenuTableView) { [weak self] in
            self?.hideTableView(self?.howToRequestVeganMenuTableView ?? UITableView()) {
                self?.resetTableView(request: nil)
                self?.activeHeaderView(false)
                self?.activeTableViewLayout(request: nil)
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: Hide View Animation 함수
    private func hideTableView(_ view: UIView, completion: @escaping (() -> Void)) {
        UIView.animate(withDuration: 0.15, animations: {
            view.alpha = 0
        }, completion: {( finished)  in
            if finished {
                view.isHidden = true
                completion()
            }
        })
    }
    
    // MARK: Hide Header View
    private func hideHeaderView() {
        UIView.animate(withDuration: 0.1) {
            self.veganMenuHeaderStackView.alpha = 0
        }
        veganMenuHeaderStackView.isHidden = true
    }
    
    // MARK: Show View Animation 함수
    private func showViewWithAnimation(_ headerView: UIView, _ tableView: UIView) {
        headerView.alpha = 0
        tableView.alpha = 0
        headerView.isHidden = false
        tableView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            headerView.alpha = 1
            tableView.alpha = 1
        }
    }
    
    // MARK: vegan Menu Header StaclView Animation Logic
    private func activeHeaderView(_ active: Bool) {
        if active {
            veganDetailStackViewBottomL.isActive = false
            tableHeaderViewL.forEach {
                $0.isActive = true
            }
        } else {
            veganDetailStackViewBottomL.isActive = true
            tableHeaderViewL.forEach {
                $0.isActive = false
            }
        }
    }
    
    // MARK: 동적 테이블 view Layout 설정
    private func activeTableViewLayout(request: Bool?) {
        guard let request = request else {
            howToRequestVeganMenuTableViewL.forEach {
                $0.isActive = false
            }
            
            allAndVeganMenuL.forEach {
                $0.isActive = false
            }
            return
        }
        
        if !request {
            howToRequestVeganMenuTableViewL.forEach {
                $0.isActive = false
            }
            
            allAndVeganMenuL.forEach {
                $0.isActive = true
            }
        } else if request {
            howToRequestVeganMenuTableViewL.forEach {
                $0.isActive = true
            }
            
            allAndVeganMenuL.forEach {
                $0.isActive = false
            }
        }
    }
    
    // MARK: Reset Not Request Table
    private func resetNotRequestTable() {
        presenter.notRequestMenu = [NotRequestMenu(menu: "", price: "")]
        veganMenuTableView.reloadData()
        veganTableViewHeightConstraint.constant -= CGFloat(integerLiteral: veganTableHeightPlusValueTotal)
        veganTableHeightPlusValueTotal = 0
    }
    
    // MARK: Reset Request Table
    private func resetRequestTable() {
        presenter.requestMenu = [RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)]
        howToRequestVeganMenuTableView.reloadData()
        requestVeganTableViewHeightConstraint.constant -= CGFloat(integerLiteral: requestVeganTableHeightPlusValueTotal)
        requestVeganTableHeightPlusValueTotal = 0
    }
    
    // MARK: Reset TableView
    private func resetTableView(request: Bool?) {
        guard let request = request else {
            resetRequestTable()
            resetNotRequestTable()
            return
        }

        if request {
            resetNotRequestTable()
        } else {
            resetRequestTable()
        }
    }
}
