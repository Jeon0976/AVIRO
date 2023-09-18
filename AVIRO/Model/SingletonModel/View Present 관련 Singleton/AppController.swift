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
        window.backgroundColor = .gray7
        window.makeKeyAndVisible()
        
        checkState()
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

        // TODO: 로그인 기능 추가 시 업데이트
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: userIdentifier)
        
        print(userCheck)
        // 회원이 서버에 없을 때
        AVIROAPIManager().postCheckUserModel(userCheck) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if userInfo.statusCode == 200 {
                    print("TestTest")
                    let userId = userInfo.data?.userId ?? ""
                    let userName = userInfo.data?.userName ?? ""
                    let userEmail = userInfo.data?.userEmail ?? ""
                    let userNickname = userInfo.data?.nickname ?? ""
                    let marketingAgree = userInfo.data?.marketingAgree ?? 0
                    
                    UserId.shared.whenLogin(
                        userId: userId,
                        userName: userName,
                        userNickname: userNickname,
                        marketingAgree: marketingAgree
                    )
                    print(userInfo)
                    self?.setHomeView()
                } else {
                    print(userInfo)
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
