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
        self.userKey = keychain.get(KeychainKey.userId.rawValue)
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

        // TODO: 로그인 기능 추가 시 업데이트
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: userKey)
        
        // 회원이 서버에 없을 때
        AVIROAPIManager().postCheckAppleUserModel(userCheck) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if userInfo.statusCode == 200 {
                    let userId = userInfo.data?.userId ?? ""
                    let userName = userInfo.data?.userName ?? ""
                    let userEmail = userInfo.data?.userEmail ?? ""
                    let userNickname = userInfo.data?.nickname ?? ""
                    let marketingAgree = userInfo.data?.marketingAgree ?? 0
                    
                    MyData.my.whenLogin(
                        userId: userId,
                        userName: userName,
                        userEmail: userEmail,
                        userNickname: userNickname,
                        marketingAgree: marketingAgree
                    )
                    self?.setHomeView()
                    self?.keychain.set(userId, forKey: KeychainKey.userId.rawValue)
                } else {
                    self?.setLoginView()
                }
            }
        }
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
    
}
