//
//  SceneDelegate.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let keychain = KeychainSwift()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        guard let saveUserIdentifier = keychain.get("userIdentifier") else {
            let viewController = LoginViewController()

            let rootViewContrller = UINavigationController(rootViewController: viewController)
            
            window?.rootViewController = rootViewContrller
            window?.backgroundColor = .white
            window?.tintColor = .mainTitle
            
            window?.makeKeyAndVisible()
            return
        }
        
        let viewController = TabBarViewController()
        
        window?.rootViewController = viewController
        window?.backgroundColor = .white
        window?.tintColor = .mainTitle
        
        window?.makeKeyAndVisible()
    }
}
