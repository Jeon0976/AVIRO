//
//  SceneDelegate.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewController = LoginViewController()

        let rootViewContrller = UINavigationController(rootViewController: viewController)
        
        window?.rootViewController = rootViewContrller
        window?.backgroundColor = .white
        window?.tintColor = .mainTitle
        
        window?.makeKeyAndVisible()
    }
}
