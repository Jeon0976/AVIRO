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
}


