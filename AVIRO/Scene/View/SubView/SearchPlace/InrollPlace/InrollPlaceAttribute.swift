//
//  InrollPlaceAttribute.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/24.
//

import UIKit

extension InrollPlaceViewController {
    // MARK: Requirde & Optional Attribute
    public func requiredAndOptionalAttribute() {
        requiredTitleLabel.text = "(필수)"
        requiredTitleLabel.textColor = .lightGray
        requiredTitleLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        requriedLocationLabel.text = "(필수)"
        requriedLocationLabel.textColor = .lightGray
        requriedLocationLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        requriedCategoryLabel.text = "(필수)"
        requriedCategoryLabel.textColor = .lightGray
        requriedCategoryLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        optionalPhoneLabel.text = "(선택)"
        optionalPhoneLabel.textColor = .lightGray
        optionalPhoneLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        requriedDetailLabel.text = "(필수)"
        requriedDetailLabel.textColor = .lightGray
        requriedDetailLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        requriedMenuLabel.text = "(필수)"
        requriedMenuLabel.textColor = .lightGray
        requriedMenuLabel.font = .systemFont(ofSize: 12, weight: .light)

    }
    
    // MARK: Store Title Attribute
    public func storeTitleReferAttribute() {
        storeTitleExplanation.text = "가게 이름"
        storeTitleExplanation.textColor = .black
        storeTitleField.placeholder = "가게를 찾아보세요"
        storeTitleField.delegate = self
    }

    // MARK: Store Location Attribute
    public func storeLocationReferAttribute() {
        storeLocationExplanation.text = "가게 위치"
        storeLocationExplanation.textColor = .black
    }
    
    // MARK: Store Category Attribute
    public func storeCategoryReferAttribute() {
        storeCategoryExplanation.text = "카테고리"
        storeCategoryExplanation.textColor = .black
    }
    
    // MARK: Store Phone Attribute
    public func storePhoneReferAttribute() {
        storePhoneExplanation.text = "전화번호"
        storePhoneExplanation.textColor = .black
    }
    
    // MARK: Vegan Detail Attribute
    public func veganDetailReferAttribute() {
        veganDetailExplanation.text = "가게 종류"
        veganDetailExplanation.textColor = .black
        
        allVegan.makeVeganSelectButton("plus.square", "ALL 비건")
        someMenuVegan.makeVeganSelectButton("plus.square", "비건 메뉴 포함")
        ifRequestPossibleVegan.makeVeganSelectButton("plus.square", "요청하면 비건")
        allVegan.addTarget(self, action: #selector(clickedAllVeganButton), for: .touchUpInside)
        someMenuVegan.addTarget(self, action: #selector(clickedSomeMenuVeganButton), for: .touchUpInside)
        ifRequestPossibleVegan.addTarget(self, action: #selector(clickedIfRequestPossibleVebanButton), for: .touchUpInside)
    }
    
    // MARK: vegan Header View
    public func veganHeaderViewAttribute() {
        veganMenuExplanation.text = "비건 메뉴"
        veganMenuPlusButton.customImageConfig("plusButton", "plusButton")
    }
}
