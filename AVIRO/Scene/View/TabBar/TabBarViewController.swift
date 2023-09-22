//
//  TabBarViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
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
        tabBar.tintColor = .main
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.gray5.cgColor
        
        let attributesNormal: [NSAttributedString.Key: Any] = [
            .font: CFont.font.bold11,
            .foregroundColor: UIColor.gray2
        ]
        
        let attributesSelected: [NSAttributedString.Key: Any] = [
            .font: CFont.font.bold11,
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

// MARK: View Preview
#if DEBUG
import SwiftUI

struct TabBarViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = TabBarViewController()
        
        return vc
    }
}

struct TabBarViewControllerPresentablePreviewProvider: PreviewProvider {
    static var previews: some View {
        TabBarViewControllerPresentable()
    }
}
#endif
