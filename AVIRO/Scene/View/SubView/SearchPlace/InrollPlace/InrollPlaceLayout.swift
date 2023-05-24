//
//  InrollPlaceLayout.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/24.
//

import UIKit

extension InrollPlaceViewController {
    public func storeTitleStackViewLayout() {
        [
            storeTitleExplanation,
            requiredTitleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeTitleExplanationStackView.addArrangedSubview($0)
        }
        
        storeTitleExplanationStackView.axis = .horizontal
        storeTitleExplanationStackView.spacing = 3.0
        storeTitleExplanationStackView.distribution = .equalSpacing
        
        [
            storeTitleExplanationStackView,
            storeTitleField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeTitleStackView.addArrangedSubview($0)
        }
                
        storeTitleStackView.axis = .vertical
        storeTitleStackView.spacing = 8.0
        storeTitleStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeTitleField.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeTitleField.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor)
        ])
    }
    
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
        storeLocationExplanationStackView.spacing = 3.0
        
        [
            storeLocationExplanationStackView,
            storeLocationField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeLocationStackView.addArrangedSubview($0)
        }
        
        storeLocationStackView.axis = .vertical
        storeLocationStackView.spacing = 8.0
        storeLocationStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeLocationField.leadingAnchor.constraint(
                equalTo: storeLocationStackView.leadingAnchor),
            storeLocationField.trailingAnchor.constraint(
                equalTo: storeLocationStackView.trailingAnchor)
        ])
    }
    
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
        storeCategoryExplanationStackView.spacing = 3.0
        
        [
            storeCategoryExplanationStackView,
            storeCategoryField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storeCategoryStackView.addArrangedSubview($0)
        }
        
        storeCategoryStackView.axis = .vertical
        storeCategoryStackView.spacing = 8.0
        storeCategoryStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storeCategoryField.leadingAnchor.constraint(
                equalTo: storeCategoryStackView.leadingAnchor),
            storeCategoryField.trailingAnchor.constraint(
                equalTo: storeCategoryStackView.trailingAnchor)
        ])
    }
    
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
        storePhoneExplanationStackView.spacing = 3.0
        
        [
            storePhoneExplanationStackView,
            storePhoneField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            storePhoneStackView.addArrangedSubview($0)
        }
        
        storePhoneStackView.axis = .vertical
        storePhoneStackView.spacing = 8.0
        storePhoneStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            storePhoneField.leadingAnchor.constraint(
                equalTo: storePhoneStackView.leadingAnchor),
            storePhoneField.trailingAnchor.constraint(
                equalTo: storePhoneStackView.trailingAnchor)
        ])
    }
    
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
        veganDetailExplanationStackView.spacing = 3.0
        
        [
            allVegan,
            someMenuVegan,
            ifRequestPossibleVegan
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganButtonStackView.addArrangedSubview($0)
        }
        
        veganButtonStackView.axis = .horizontal
        veganButtonStackView.spacing = 3.0
        veganButtonStackView.distribution = .fillEqually
        
        [
            veganDetailExplanationStackView,
            veganButtonStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganDetailStackView.addArrangedSubview($0)
        }
        
        veganDetailStackView.axis = .vertical
        veganDetailStackView.spacing = 8.0
        veganDetailStackView.alignment = .leading
        
        NSLayoutConstraint.activate([
            veganButtonStackView.leadingAnchor.constraint(
                equalTo: veganDetailStackView.leadingAnchor),
            veganButtonStackView.trailingAnchor.constraint(
                equalTo: veganDetailStackView.trailingAnchor)
        ])
    }
    
    public func veganTableHeaderViewLayout() {
        [
            veganMenuExplanation,
            requriedMenuLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            veganMenuExplanationStackView.addArrangedSubview($0)
        }
        
        veganMenuExplanationStackView.axis = .horizontal
        veganMenuExplanationStackView.spacing = 3.0
        
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
        
        // 동적 뷰를 위한 설정
        veganDetailStackViewBottomL = veganDetailStackView.bottomAnchor.constraint(
            equalTo: reportStoreButton.topAnchor,
            constant: -32)
        
        tableHeaderViewL = [
            // Vegan Header View
            veganMenuHeaderStackView.topAnchor.constraint(
                equalTo: veganDetailStackView.bottomAnchor, constant: 16),
            veganMenuHeaderStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganMenuHeaderStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor)
        ]
        
        allAndVeganMenuL = [
            // veganMenuStackView
            veganMenuTableView.topAnchor.constraint(
                equalTo: veganMenuHeaderStackView.bottomAnchor, constant: 8),
            veganMenuTableView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganMenuTableView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            veganMenuTableView.bottomAnchor.constraint(
                equalTo: reportStoreButton.topAnchor, constant: -16)
        ]
        
        howToRequestVeganMenuTableViewL = [
            howToRequestVeganMenuTableView.topAnchor.constraint(
                equalTo: veganMenuHeaderStackView.bottomAnchor, constant: 8),
            howToRequestVeganMenuTableView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            howToRequestVeganMenuTableView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            howToRequestVeganMenuTableView.bottomAnchor.constraint(
                equalTo: reportStoreButton.topAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate([
            // storeTitleStackView
            storeTitleStackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 16),
            storeTitleStackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 16),
            storeTitleStackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -16),
            
            // storeLocationStackView
            storeLocationStackView.topAnchor.constraint(
                equalTo: storeTitleStackView.bottomAnchor,
                constant: 16),
            storeLocationStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeLocationStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),

            // storeCategoryStackView
            storeCategoryStackView.topAnchor.constraint(
                equalTo: storeLocationStackView.bottomAnchor,
                constant: 16),
            storeCategoryStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storeCategoryStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            
            // storePhoneStackView
            storePhoneStackView.topAnchor.constraint(
                equalTo: storeCategoryStackView.bottomAnchor,
                constant: 16),
            storePhoneStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            storePhoneStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),

            // veganDetailStackView
            veganDetailStackView.topAnchor.constraint(
                equalTo: storePhoneStackView.bottomAnchor,
                constant: 16),
            veganDetailStackView.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            veganDetailStackView.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            veganDetailStackViewBottomL,
            
            // reportStoreButton
            reportStoreButton.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor, constant: -16),
            reportStoreButton.leadingAnchor.constraint(
                equalTo: storeTitleStackView.leadingAnchor),
            reportStoreButton.trailingAnchor.constraint(
                equalTo: storeTitleStackView.trailingAnchor),
            reportStoreButton.centerXAnchor.constraint(
                equalTo: scrollView.centerXAnchor),
            reportStoreButton.heightAnchor.constraint(
                equalTo: storeTitleField.heightAnchor, multiplier: 1)
        ])

    }
}
