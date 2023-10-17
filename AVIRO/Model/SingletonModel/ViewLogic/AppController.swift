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
    
    private var userKey: String?

    private let keychain = KeychainSwift()
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    private init() {
        self.userKey = keychain.get(KeychainKey.appleRefreshToken.rawValue)
    }
    
    // MARK: 외부랑 소통할 메서드
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .gray7
        window.makeKeyAndVisible()
        
        checkState()
    }
    
    // MARK: 불러올 view 확인 메서드
    private func checkState() {
//        self.setHomeView()
        // 최초 튜토리얼 화면 안 봤을 때
        guard UserDefaults.standard.bool(forKey: UDKey.tutorial.rawValue) else {
            setTutorialView()
            return
        }

        // 자동로그인 토큰 없을 때
        guard let userKey = userKey else {
            setLoginView()
            return
        }

        let userCheck = AVIROAutoLoginWhenAppleUserDTO(refreshToken: userKey)

        AVIROAPIManager().appleUserCheck(with: userCheck) { [weak self] result in
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    if let data = model.data {
                        MyData.my.whenLogin(
                            userId: data.userId,
                            userName: data.userName,
                            userEmail: data.userEmail,
                            userNickname: data.nickname,
                            marketingAgree: data.marketingAgree
                        )
                        self?.setHomeView()
                    }
                } else {
                    self?.keychain.delete(KeychainKey.appleRefreshToken.rawValue)
                    self?.setLoginView()
                }
            case .failure(_):
                self?.keychain.delete(KeychainKey.appleRefreshToken.rawValue)
                self?.setLoginView()
            }
        }
    }
    
    // MARK: tutorial View
    private func setTutorialView() {
        DispatchQueue.main.async { [weak self] in
            let tutorialVC = TutorialViewController()
            
            self?.rootViewController = UINavigationController(rootViewController: tutorialVC)
        }
    }
    
    // MARK: login View
    private func setLoginView() {
        DispatchQueue.main.async { [weak self] in
            let loginVC = LoginViewController()
            
            self?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
    }
    
    // MARK: home View
    private func setHomeView() {
        DispatchQueue.main.async { [weak self] in
            let homeVC = TabBarViewController()

            self?.rootViewController = homeVC
        }
    }
    
}
