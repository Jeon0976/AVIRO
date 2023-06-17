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
        requiredTitleLabel.text = StringValue.InrollView.required
        requiredTitleLabel.textColor = .subTitle
        requiredTitleLabel.font = Layout.Label.subTitle
        
        requriedLocationLabel.text = StringValue.InrollView.required
        requriedLocationLabel.textColor = .subTitle
        requriedLocationLabel.font = Layout.Label.subTitle
        
        requriedCategoryLabel.text = StringValue.InrollView.required
        requriedCategoryLabel.textColor = .subTitle
        requriedCategoryLabel.font = Layout.Label.subTitle
        
        optionalPhoneLabel.text = StringValue.InrollView.optional
        optionalPhoneLabel.textColor = .subTitle
        optionalPhoneLabel.font = Layout.Label.subTitle
        
        requriedDetailLabel.text = StringValue.InrollView.required
        requriedDetailLabel.textColor = .subTitle
        requriedDetailLabel.font = Layout.Label.subTitle
        
        requriedMenuLabel.text = StringValue.InrollView.required
        requriedMenuLabel.textColor = .subTitle
        requriedMenuLabel.font = Layout.Label.subTitle

    }
    
    // MARK: Store Title Attribute
    public func storeTitleReferAttribute() {
        storeTitleExplanation.text = StringValue.InrollView.storeTitle
        storeTitleExplanation.textColor = .mainTitle
        storeTitleField.placeholder = StringValue.InrollView.storeTitlePlaceHolder
        storeTitleField.delegate = self
    }

    // MARK: Store Location Attribute
    public func storeLocationReferAttribute() {
        storeLocationExplanation.text = StringValue.InrollView.storeLocation
        storeLocationExplanation.textColor = .mainTitle
    }
    
    // MARK: Store Category Attribute
    public func storeCategoryReferAttribute() {
        storeCategoryExplanation.text = StringValue.InrollView.storeCategory
        storeCategoryExplanation.textColor = .mainTitle
    }
    
    // MARK: Store Phone Attribute
    public func storePhoneReferAttribute() {
        storePhoneExplanation.text = StringValue.InrollView.storePhone
        storePhoneExplanation.textColor = .mainTitle
    }
    
    // MARK: Vegan Detail Attribute
    public func veganDetailReferAttribute() {
        veganDetailExplanation.text = StringValue.InrollView.storeTypes
        veganDetailExplanation.textColor = .mainTitle
        
        allVegan.makeVeganSelectButton(Image.InrollView.allVeganNoSelected,
                                       StringValue.InrollView.allVegan
        )
        someMenuVegan.makeVeganSelectButton(Image.InrollView.someMenuVeganNoSelected,
                                            StringValue.InrollView.someVegan
        )
        ifRequestPossibleVegan.makeVeganSelectButton(Image.InrollView.requestMenuVeganNoSelected,
                                                     StringValue.InrollView.requestVegan
        )
        
        allVegan.addTarget(self,
                           action: #selector(clickedAllVeganButton),
                           for: .touchUpInside
        )
        allVegan.addTarget(self,
                           action: #selector(clickedAllVeganButton),
                           for: .touchDragExit
        )
        allVegan.addTarget(self,
                           action: #selector(buttonTouchDown),
                           for: .touchDown
        )
        
        someMenuVegan.addTarget(self,
                                action: #selector(clickedSomeMenuVeganButton),
                                for: .touchUpInside
        )
        someMenuVegan.addTarget(self,
                                action: #selector(clickedSomeMenuVeganButton),
                                for: .touchDragExit
        )
        someMenuVegan.addTarget(self,
                                action: #selector(buttonTouchDown),
                                for: .touchDown
        )

        ifRequestPossibleVegan.addTarget(self,
                                         action: #selector(clickedIfRequestPossibleVebanButton),
                                         for: .touchUpInside
        )
        ifRequestPossibleVegan.addTarget(self,
                                         action: #selector(clickedIfRequestPossibleVebanButton),
                                         for: .touchDragExit
        )
        ifRequestPossibleVegan.addTarget(self,
                                         action: #selector(buttonTouchDown),
                                         for: .touchDown
        )

    }
    
    // MARK: vegan Header View
    public func veganHeaderViewAttribute() {
        veganMenuExplanation.text = StringValue.InrollView.menuTable
        veganMenuPlusButton.customImageConfig(Image.InrollView.plusButton, Image.InrollView.plusButton)
    }
}
