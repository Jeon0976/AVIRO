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

struct ButtonState {
    var imageString: String
    var titleColor: UIColor?
    var backgroundColor: UIColor?
    var borderColor: CGColor?
}

extension InrollPlaceViewController {
    // MARK: Button 클릭 시 UI 분기 처리
    func updateVeganState(_ state: VeganState) {
        
        let defaultAllVeganState = ButtonState(imageString: Image.InrollPageImage.allVeganNoSelected,
                                               titleColor: UIColor.separateLine,
                                               backgroundColor: UIColor.white,
                                               borderColor: UIColor.separateLine?.cgColor)
                                               
        let defaultSomeVeganState = ButtonState(imageString: Image.InrollPageImage.someMenuVeganNoSelected,
                                                titleColor: UIColor.separateLine,
                                                backgroundColor: UIColor.white,
                                                borderColor: UIColor.separateLine?.cgColor)
                                                
        let defaultRequestVeganState = ButtonState(imageString: Image.InrollPageImage.requestMenuVeganNoSelected,
                                                   titleColor: UIColor.separateLine,
                                                   backgroundColor: UIColor.white,
                                                   borderColor: UIColor.separateLine?.cgColor)
                                       
        var allVeganState = defaultAllVeganState
        var someMenuVeganState = defaultSomeVeganState
        var ifRequestVeganState = defaultRequestVeganState
        
        switch state {
        case .allVeganClicked:
            allVeganState = ButtonState(imageString: Image.InrollPageImage.allVeganSelected,
                                        titleColor: UIColor.white,
                                        backgroundColor: UIColor.allVegan,
                                        borderColor: UIColor.allVegan?.cgColor)
            presenter.buttonChecked(true, false, false)
            
        case .onlySomeVeganClicked:
            someMenuVeganState = ButtonState(imageString: Image.InrollPageImage.someMenuVeganSelected,
                                             titleColor: UIColor.white,
                                             backgroundColor: UIColor.someVegan,
                                             borderColor: UIColor.someVegan?.cgColor)
            presenter.buttonChecked(false, true, false)
            
        case .onlyRequestVeganClicked:
            ifRequestVeganState = ButtonState(imageString: Image.InrollPageImage.requestMenuVeganSelected,
                                              titleColor: UIColor.white,
                                              backgroundColor: UIColor.requestVegan,
                                              borderColor: UIColor.requestVegan?.cgColor)
            presenter.buttonChecked(false, false, true)
            
        case .someAndReqeustVeganClicked:
            someMenuVeganState = ButtonState(imageString: Image.InrollPageImage.someMenuVeganSelected,
                                             titleColor: UIColor.white,
                                             backgroundColor: UIColor.someVegan,
                                             borderColor: UIColor.someVegan?.cgColor)
            ifRequestVeganState = ButtonState(imageString: Image.InrollPageImage.requestMenuVeganSelected,
                                              titleColor: UIColor.white,
                                              backgroundColor: UIColor.requestVegan,
                                              borderColor: UIColor.requestVegan?.cgColor)
            presenter.buttonChecked(false, true, true)
            
        case .offAll:
            presenter.buttonChecked(false, false, false)
        }
        
        updateButtonState(allVegan, state: allVeganState)
        updateButtonState(someMenuVegan, state: someMenuVeganState)
        updateButtonState(ifRequestPossibleVegan, state: ifRequestVeganState)
    }
    
    func updateButtonState(_ button: UIButton, state: ButtonState) {
        button.setImage(UIImage(named: state.imageString), for: .normal)
        button.setTitleColor(state.titleColor, for: .normal)
        button.backgroundColor = state.backgroundColor
        button.layer.borderColor = state.borderColor
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
    func resetTable() {
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
        veganTableViewHeightConstraint.constant -= CGFloat(integerLiteral: veganTableHeightPlusValue)
        veganTableHeightPlusValue = 0
    }
    
    // MARK: Reset Request Table
    private func resetRequestTable() {
        presenter.requestMenu = [RequestMenu(menu: "", price: "", howToRequest: "", isCheck: false)]
        howToRequestVeganMenuTableView.reloadData()
        requestVeganTableViewHeightConstraint.constant -= CGFloat(integerLiteral: requestVeganTableHeightPlusValue)
        requestVeganTableHeightPlusValue = 0
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
