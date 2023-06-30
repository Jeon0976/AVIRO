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
        
        let userIdentifier = keychain.get("userIdentifier")
        showFirstView(userIdentifier)
    }
     
    // MARK: Login Logic
    func showFirstView(_ userIdentifier: String?) {
        guard let saveUserIdentifier = userIdentifier else {
            // MARK: 최초 로그인 시 Login 화면
            let viewController = LoginViewController()
            let rootViewContrller = UINavigationController(rootViewController: viewController)
            
            window?.rootViewController = rootViewContrller
            window?.backgroundColor = .white
            window?.tintColor = .mainTitle
            
            window?.makeKeyAndVisible()
            return
        }
        
        // MARK: userInfo가 있으면 자동 로그인, 없으면 로그인 화면 보여지기
        let userInfo = UserInfoModel(userToken: saveUserIdentifier, userName: "", userEmail: "")
        aviroManager.postUserModel(userInfo) { userInfo in
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
