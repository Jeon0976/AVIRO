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
    let aviroManager = AVIROAPIManager()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let saveUserIdentifier = keychain.get("userIdentifier") {
            aviroManager.postUserModel(UserInfoModel(userToken: saveUserIdentifier, userName: "", userEmail: "")) { userInfo in
                print("UserInfo.isMember:",userInfo.isMember)
                DispatchQueue.main.async { [weak self] in
                    if userInfo.isMember {
                        let viewController = TabBarViewController()
                        
                        self?.window?.rootViewController = viewController
                        self?.window?.backgroundColor = .white
                        self?.window?.tintColor = .mainTitle
                        
                        self?.window?.makeKeyAndVisible()
                        return
                    } else {
                        let viewController = LoginViewController()
                        let rootViewContrller = UINavigationController(rootViewController: viewController)
                        
                        self?.window?.rootViewController = rootViewContrller
                        self?.window?.backgroundColor = .white
                        self?.window?.tintColor = .mainTitle
                        
                        self?.window?.makeKeyAndVisible()
                        return
                    }
                }
            }
        }
    }
}
