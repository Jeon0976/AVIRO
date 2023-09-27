//
//  TabBarViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var homeTabBarButtonTapped: (() -> Void)?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
        self.delegate = self
    }
    
    private func setupViewController() {
        let tabBarViewControllers: [UIViewController] = TBItem.allCases.map { tabCase in
            let viewController = tabCase.vc
            
            let tabBarItem = UITabBarItem(
                title: tabCase.title,
                image: tabCase.icon.default,
                selectedImage: tabCase.icon.selected
            )
            
            viewController.tabBarItem = tabBarItem
            
            return viewController
        }
        self.viewControllers = tabBarViewControllers
        
    }

    // MARK: TabBar Attribute
    private func setupTabBar() {
        tabBar.backgroundColor = .gray7
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.gray5.cgColor
        
        let attributesNormal: [NSAttributedString.Key: Any] = [
            .font: CFont.font.semibold11,
            .foregroundColor: UIColor.gray2
        ]
        
        let attributesSelected: [NSAttributedString.Key: Any] = [
            .font: CFont.font.medium11,
            .foregroundColor: UIColor.main
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
    }
    
    func hiddenTabBar(_ hidden: Bool) {
        
        self.tabBar.isTranslucent = hidden
        self.tabBar.isHidden = hidden

        if !hidden {
            setupTabBar()
        }
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == 0 {
            homeTabBarButtonTapped?()
        }
    }
}
