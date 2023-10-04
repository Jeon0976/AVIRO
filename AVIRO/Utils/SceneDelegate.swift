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
        
        let window = UIWindow(windowScene: windowScene)
        
        self.window = window
        
        self.window?.rootViewController = LaunchScreenViewController()
        self.window?.makeKeyAndVisible()
         
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             AppController.shared.show(in: window)
         }
    }
}
