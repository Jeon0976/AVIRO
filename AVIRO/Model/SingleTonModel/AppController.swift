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
    
    // MARK: 외부랑 소통할 메서드
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .white
        window.tintColor = .mainTitle
        window.makeKeyAndVisible()
        
        checkState()
    }
    
    // MARK: tutorial View
    private func setTutorialView() {
        let tutorialVC = TutorialViewController()
        
        rootViewController = UINavigationController(rootViewController: tutorialVC)
    }
    
    // MARK: login View
    private func setLoginView() {
        let loginVC = LoginViewController()
        
        rootViewController = UINavigationController(rootViewController: loginVC)
    }
    
    // MARK: home View
    private func setHomeView() {
        let homeVC = TabBarViewController()

        rootViewController = homeVC
    }
    
    // MARK: 불러올 view 확인 메서드
    private func checkState() {
        // 최초 튜토리얼 화면 안 봤을 때
        guard UserDefaults.standard.bool(forKey: "Tutorial") else {
            setTutorialView()
            return
        }
        
        // 자동로그인 토큰 없을 때
        guard let userIdentifier = userIdentifier else {
            setLoginView()
            return
        }
        
        setLoginView()
        
        let userInfo = UserInfoModel(userToken: userIdentifier, userName: "", userEmail: "")
        
        // 회원이 서버에 없을 때
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
