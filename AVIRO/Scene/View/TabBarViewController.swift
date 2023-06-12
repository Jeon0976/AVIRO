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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = .plusButton
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarViewControllers: [UIViewController] = TabBarItem.allCases.map { tabCase in
            let viewController = tabCase.viewController
            viewController.tabBarItem = UITabBarItem(
                title: tabCase.title,
                image: tabCase.icon.default,
                selectedImage: tabCase.icon.selected
            )
            return viewController
        }
        self.viewControllers = tabBarViewControllers
        
        self.tabBar.backgroundColor = .white
        
        centerButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        centerButton.addTarget(self, action: #selector(buttonDragExit), for: .touchDragExit)
        centerButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        view.addSubview(centerButton)
        
        let itemWidth = tabBar.frame.width / CGFloat(TabBarItem.allCases.count) - 12
        
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            centerButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: tabBar.frame.height - 6),
            centerButton.widthAnchor.constraint(equalToConstant: itemWidth),
            centerButton.heightAnchor.constraint(equalToConstant: itemWidth)
        ])
    }
    
    @objc func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.layer.opacity = 0.4
        })
    }
    
    @objc func buttonDragExit(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        })
    }
    
    @objc func didTapPlusButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1

        }, completion: {  [weak self] _ in
            self?.selectedIndex = 2
        })
    }

    func hiddenTabBar(_ hidden: Bool) {
        self.tabBar.isHidden = hidden
        self.tabBar.isTranslucent = hidden
        self.centerButton.isHidden = hidden
    }
}
