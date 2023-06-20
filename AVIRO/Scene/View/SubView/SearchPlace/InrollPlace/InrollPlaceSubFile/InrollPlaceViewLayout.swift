//
//  InrollPlaceLayout.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/24.
//

import UIKit

extension InrollPlaceViewController {
    // MARK: Store Title Stack View Layout
    public func storeTitleStackViewLayout() {
        [
            storeTitleExplanation,
            requiredTitleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeTitleExplanationStackView.addArrangedSubview($0)
        }
        
        storeTitleExplanationStackView.axis = .horizontal
        storeTitleExplanationStackView.spacing = Layout.InrollView.labelToLabel
        storeTitleExplanationStackView.distribution = .equalSpacing
        
        [
            storeTitleExplanationStackView,
            storeTitleField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeTitleStackView.addArrangedSubview($0)
        }
                
        storeTitleStackView.axis = .vertical
        storeTitleStackView.spacing = Layout.InrollView.labelToField
        storeTitleStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeTitleField.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeTitleField.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor)
        ])
    }
    
    // MARK: Store Location Stack View Layout
    public func storeLocationStackViewLayout() {
        [
            storeLocationExplanation,
            requriedLocationLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeLocationExplanationStackView.addArrangedSubview($0)
        }
        
        storeLocationExplanationStackView.axis = .horizontal
        storeLocationExplanationStackView.distribution = .fill
        storeLocationExplanationStackView.spacing = Layout.InrollView.labelToLabel
        
        [
            storeLocationExplanationStackView,
            storeLocationField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeLocationStackView.addArrangedSubview($0)
        }
        
        storeLocationStackView.axis = .vertical
        storeLocationStackView.spacing = Layout.InrollView.labelToField
        storeLocationStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeLocationField.leadingAnchor.constraint(
                equalTo: storeLocationStackView.leadingAnchor),
            storeLocationField.trailingAnchor.constraint(
                equalTo: storeLocationStackView.trailingAnchor)
        ])
    }
    
    // MARK: Store Category Stack View Layout
    public func storeCategoryStackviewLayout() {
        [
            storeCategoryExplanation,
            requriedCategoryLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeCategoryExplanationStackView.addArrangedSubview($0)
        }
        
        storeCategoryExplanationStackView.axis = .horizontal
        storeCategoryExplanationStackView.distribution = .fill
        storeCategoryExplanationStackView.spacing = Layout.InrollView.labelToLabel
        
        [
            storeCategoryExplanationStackView,
            storeCategoryField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeCategoryStackView.addArrangedSubview($0)
        }
        
        storeCategoryStackView.axis = .vertical
        storeCategoryStackView.spacing = Layout.InrollView.labelToField
        storeCategoryStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeCategoryField.leadingAnchor.constraint(
                equalTo: storeCategoryStackView.leadingAnchor),
            storeCategoryField.trailingAnchor.constraint(
                equalTo: storeCategoryStackView.trailingAnchor)
        ])
    }
    
    // MARK: Store Phone Stack View Layout
    public func storePhoneStackviewLayout() {
        [
            storePhoneExplanation,
            optionalPhoneLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storePhoneExplanationStackView.addArrangedSubview($0)
        }
        
        storePhoneExplanationStackView.axis = .horizontal
        storePhoneExplanationStackView.distribution = .fill
        storePhoneExplanationStackView.spacing = Layout.InrollView.labelToLabel
        
        [
            storePhoneExplanationStackView,
            storePhoneField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storePhoneStackView.addArrangedSubview($0)
        }
        
        storePhoneStackView.axis = .vertical
        storePhoneStackView.spacing = Layout.InrollView.labelToField
        storePhoneStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storePhoneField.leadingAnchor.constraint(
                equalTo: storePhoneStackView.leadingAnchor),
            storePhoneField.trailingAnchor.constraint(
                equalTo: storePhoneStackView.trailingAnchor)
        ])
    }
    
    // MARK: Vegan Detail Button Stack View Layout
    public func veganDetailStackViewLayout() {
        [
            veganDetailExplanation,
            requriedDetailLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganDetailExplanationStackView.addArrangedSubview($0)
        }
        
        veganDetailExplanationStackView.axis = .horizontal
        veganDetailExplanationStackView.distribution = .fill
        veganDetailExplanationStackView.spacing = Layout.InrollView.labelToLabel
        
        [
            allVegan,
            someMenuVegan,
            ifRequestPossibleVegan
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganButtonStackView.addArrangedSubview($0)
        }
        
        veganButtonStackView.axis = .horizontal
        veganButtonStackView.spacing = Layout.InrollView.labelToLabel
        veganButtonStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            allVegan.heightAnchor.constraint(equalTo: allVegan.widthAnchor, multiplier: 1),
            someMenuVegan.heightAnchor.constraint(equalTo: allVegan.widthAnchor, multiplier: 1),
            ifRequestPossibleVegan.heightAnchor.constraint(equalTo: allVegan.widthAnchor, multiplier: 1)
        ])
        
        [
            veganDetailExplanationStackView,
            veganButtonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganDetailStackView.addArrangedSubview($0)
        }
        
        veganDetailStackView.axis = .vertical
        veganDetailStackView.spacing = Layout.InrollView.labelToField
        veganDetailStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            veganButtonStackView.leadingAnchor.constraint(
                equalTo: veganDetailStackView.leadingAnchor),
            veganButtonStackView.trailingAnchor.constraint(
                equalTo: veganDetailStackView.trailingAnchor)
        ])
    }
    
    // MARK: Vegan Table Header View Layout
    public func veganTableHeaderViewLayout() {
        [
            veganMenuExplanation,
            requriedMenuLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganMenuExplanationStackView.addArrangedSubview($0)
        }
        
        veganMenuExplanationStackView.axis = .horizontal
        
        veganMenuExplanationStackView.spacing = Layout.InrollView.labelToLabel
        
        [
            veganMenuExplanationStackView,
            veganMenuPlusButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganMenuHeaderStackView.addArrangedSubview($0)
        }
        
        veganMenuHeaderStackView.axis = .horizontal
        
        veganMenuHeaderStackView.distribution = .equalCentering
        
    }
    
    // MARK: Dynamic Table View
    private func dynamicsTableView() {
        // 동적 뷰를 위한 설정
        // 최초 및 모든 버튼 비활성화 시 활성화될 layout
        veganDetailStackViewBottomL = veganDetailStackView.bottomAnchor.constraint(
            equalTo: reportStoreButton.topAnchor, constant: Layout.Inset.trailingBottomDouble)

        // 어떤 버튼이라도 눌렀을 시 활성화될 layout
        tableHeaderViewL = [
            // Vegan Header View
            veganMenuHeaderStackView.topAnchor.constraint(
                equalTo: veganDetailStackView.bottomAnchor, constant: Layout.Inset.leadingTopDouble),
            veganMenuHeaderStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganMenuHeaderStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor)
        ]
        
        //
        veganTableViewHeightConstraint = veganMenuTableView.heightAnchor.constraint(
            equalTo: storeTitleField.heightAnchor, multiplier: 1)

        veganTableViewHeightConstraint.constant = Layout.InrollView.notRequestTableConstant

        // Not Request Vegan Menu Table View의 Layout
        allAndVeganMenuL = [
            veganMenuTableView.topAnchor.constraint(
                equalTo: veganMenuHeaderStackView.bottomAnchor, constant: Layout.Inset.trailingBottomHalf),
            veganMenuTableView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganMenuTableView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            veganMenuTableView.bottomAnchor.constraint(
                equalTo: reportStoreButton.topAnchor, constant: Layout.Inset.trailingBottomDouble),
            veganTableViewHeightConstraint
        ]
        
        requestVeganTableViewHeightConstraint = howToRequestVeganMenuTableView.heightAnchor.constraint(
            equalTo: storeTitleField.heightAnchor, multiplier: 2)

        requestVeganTableViewHeightConstraint.constant = Layout.InrollView.requestTableConstant
        
        // Request Vegan Menu Table View의 Layout
        howToRequestVeganMenuTableViewL = [
            howToRequestVeganMenuTableView.topAnchor.constraint(
                equalTo: veganMenuHeaderStackView.bottomAnchor, constant: Layout.Inset.trailingBottomHalf),
            howToRequestVeganMenuTableView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            howToRequestVeganMenuTableView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            howToRequestVeganMenuTableView.bottomAnchor.constraint(
                equalTo: reportStoreButton.topAnchor, constant: Layout.Inset.trailingBottomDouble),
            requestVeganTableViewHeightConstraint
        ]
        
        veganMenuHeaderStackView.isHidden = true
    }
    
    // MARK: Total StackView Layout
    public func stackViewLayout() {
        [
            storeTitleStackView,
            storeLocationStackView,
            storeCategoryStackView,
            storePhoneStackView,
            veganDetailStackView,
            veganMenuHeaderStackView,
            veganMenuTableView,
            howToRequestVeganMenuTableView,
            reportStoreButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        dynamicsTableView()
        
        NSLayoutConstraint.activate([
            // storeTitleStackView
            storeTitleStackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor, constant: Layout.Inset.leadingTop),
            storeTitleStackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor, constant: Layout.Inset.leadingTop),
            storeTitleStackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // storeLocationStackView
            storeLocationStackView.topAnchor.constraint(
                equalTo: storeTitleStackView.bottomAnchor, constant: Layout.Inset.leadingTopDouble),
            storeLocationStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeLocationStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),

            // storeCategoryStackView
            storeCategoryStackView.topAnchor.constraint(
                equalTo: storeLocationStackView.bottomAnchor, constant: Layout.Inset.leadingTopDouble),
            storeCategoryStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeCategoryStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            
            // storePhoneStackView
            storePhoneStackView.topAnchor.constraint(
                equalTo: storeCategoryStackView.bottomAnchor, constant: Layout.Inset.leadingTopDouble),
            storePhoneStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storePhoneStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),

            // veganDetailStackView
            veganDetailStackView.topAnchor.constraint(
                equalTo: storePhoneStackView.bottomAnchor, constant: Layout.Inset.leadingTopDouble),
            veganDetailStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganDetailStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            veganDetailStackViewBottomL,
            
            // reportStoreButton
            reportStoreButton.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor, constant: Layout.Inset.trailingBottomDouble),
            reportStoreButton.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            reportStoreButton.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            reportStoreButton.centerXAnchor.constraint(
                equalTo: scrollView.centerXAnchor),
            reportStoreButton.heightAnchor.constraint(
                equalToConstant: Layout.Button.height)
        ])
    }
}
