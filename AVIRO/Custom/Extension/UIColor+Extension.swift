//
//  ColorCustom.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/04.
//

import UIKit

extension UIColor {
    class var mainTitle: UIColor? {
        UIColor(named: "mainTitle") }
    
    class var plusButton: UIColor? {
        UIColor(named: "plusButton") }
    
    class var separateLine: UIColor? {
        UIColor(named: "separateLine")
    }
    
    class var subTitle: UIColor? {
        UIColor(named: "subTitle")
    }
    
    class var allVegan: UIColor? {
        UIColor(named: "allVegan")
    }
    
    class var requestVegan: UIColor? {
        UIColor(named: "requestVegan")
    }
    
    class var someVegan: UIColor? {
        UIColor(named: "someVegan")
    }
}

// MARK: Registration & Tutorial
extension UIColor {
    class var backField: UIColor? {
        UIColor(named: "BackField")
    }
    
    class var possibleColor: UIColor? {
        UIColor(named: "PossibleColor")
    }
    
    class var impossibleColor: UIColor? {
        UIColor(named: "ImPossibleColor")
    }
    
    class var allVeganGradient: UIColor? {
        UIColor(named: "allVeganGradient")
    }
    
    class var registrationColor: UIColor? {
        UIColor(named: "RegistrationColor")
    }
    
    class var registrationPlaceHolder: UIColor? {
        UIColor(named: "RegistrationPlaceHolder")
    }
    
    class var subTitleColor: UIColor? {
        UIColor(named: "subTitleColor")
    }
    
    class var exampleRegistration: UIColor? {
        UIColor(named: "ExplainRegistration")
    }
}

// MARK: Background
extension UIColor {
    /// 본문, 작성 후 텍스트 (Active)
    static let gray0 = UIColor(named: "GRAY0")
    
    /// 부제
    static let gray1 = UIColor(named: "GRAY1")
    
    /// 부제, 인풋창 내 아이콘
    static let gray2 = UIColor(named: "GRAY2")
    
    /// 작성 전 텍스트 (Default)
    static let gray3 = UIColor(named: "GRAY3")
    
    /// 누르기 전 버튼 (Default)
    static let gray4 = UIColor(named: "GRAY4")
    
    /// 구분 선, 인풋 창 아웃라인
    static let gray5 = UIColor(named: "GRAY5")
    
    /// 인풋창 배경
    static let gray6 = UIColor(named: "GRAY6")
    
    /// 모든 화이트
    static let gray7 = UIColor(named: "GRAY7")
}

// MARK: MAIN
extension UIColor {
    /// GREEN
    static let all = UIColor(named: "GREEN")
    
    /// ORANGE
    static let some = UIColor(named: "ORANGE")
    
    /// YELLOW
    static let request = UIColor(named: "YELLOW")
    
    /// NAVY
    static let main = UIColor(named: "COBALT")
    
    /// RED
    static let warning = UIColor(named: "RED")
    
    /// BG NAVY
    static let bgNavy = UIColor(named: "BG NAVY")
    
    /// BG RED
    static let bgRed = UIColor(named: "BG RED")
    
    /// ChangeButtonColor
    static let keywordBlue = UIColor(named: "KEYWORD_BLUE")
}
