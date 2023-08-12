//
//  TabBarViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let centerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "InrollTabBarIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOpacity = 0.07
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        return button
    }()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarViewControllers: [UIViewController] = TabBarItem.allCases.map { tabCase in
            let viewController = tabCase.viewController
            let tabBarItem = UITabBarItem(
                title: tabCase.title,
                image: tabCase.icon.default,
                selectedImage: tabCase.icon.selected
            )
        
            viewController.tabBarItem = tabBarItem
            
            return viewController
        }
        self.viewControllers = tabBarViewControllers
                
        centerButton.addTarget(self, action:
                                #selector(didTapPlusButton),
                               for: .touchUpInside
        )
        
        setupTabBar()
        setupMiddleButton()
    }
    
    // MARK: 가운데 plus 버튼 만들기
    private func setupMiddleButton() {
        view.addSubview(centerButton)

        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            centerButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -30),
            centerButton.widthAnchor.constraint(equalToConstant: 80),
            centerButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    // MARK: TabBar Attribute
    private func setupTabBar() {
        tabBar.backgroundColor = .gray7
        tabBar.tintColor = .main
        tabBar.isTranslucent = false
        tabBar.layer.cornerRadius = tabBar.frame.height * 0.41
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.gray6?.cgColor
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    // MARK: button touch method
    @objc func didTapPlusButton(_ sender: UIButton) {
        selectedIndex = 1
    }

    // MARK: tabBar 숨길때 사용하는 method
    func hiddenTabBar(_ hidden: Bool) {
        self.tabBar.isTranslucent = hidden
        self.tabBar.isHidden = hidden
        self.centerButton.isHidden = hidden
        
        if !hidden {
            setupTabBar()
            setupMiddleButton()
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
