//
//  AppController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/05.
//

import Foundation

import KeychainSwift

// MARK: 처음 켰을 때 자동로그인 확인
final class AppController {
    static let shared = AppController()
    
    private var userIdentifier: String?
    
    private let keychain = KeychainSwift()
    private let aviroManager = AVIROAPIManager()
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    private init() {
        self.userIdentifier = keychain.get("userIdentifier")
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .white
        window.tintColor = .mainTitle
        window.makeKeyAndVisible()
        
        checkState()
    }
    
    private func setHomeView() {
        let homeVC = TabBarViewController()

        rootViewController = homeVC
    }
    
    private func setLoginView() {
        let loginVC = LoginViewController()
        
        rootViewController = UINavigationController(rootViewController: loginVC)
    }
    
    private func setTutorialView() {
        let tutorialVC = TutorialViewController()
        
        rootViewController = UINavigationController(rootViewController: tutorialVC)
    }
    
    private func checkState() {
        guard UserDefaults.standard.bool(forKey: "Tutorial") else {
            setTutorialView()
            return
        }
        
        guard let userIdentifier = userIdentifier else {
            setLoginView()
            return
        }
        
        let userInfo = UserInfoModel(userToken: userIdentifier, userName: "", userEmail: "")
        
        aviroManager.postUserModel(userInfo) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if userInfo.isMember {
                    self?.setHomeView()
                } else {
                    self?.setLoginView()
                }
            }
        }
    }
}
