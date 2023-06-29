//
//  MyPageViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/23.
//

import UIKit

import KeychainSwift

final class MyPageViewController: UIViewController {
    lazy var presenter = MyPageViewPresenter(viewController: self)
    let keychain = KeychainSwift()
    
    var logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension MyPageViewController: MyPageViewProtocol {
    func makeLayout() {
        [
            logOutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    func makeAttribute() {
        view.backgroundColor = .white

        logOutButton.setTitle("로그아웃", for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.addTarget(self, action: #selector(tappedLogOutButton), for: .touchUpInside)
    }
    
    @objc func tappedLogOutButton() {
        let result = keychain.delete("userIdentifier")
        
        print("성공적인 로그아웃: \(result)")
        
        let viewController = LoginViewController()
        let rootViewController = UINavigationController(rootViewController: viewController)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController = rootViewController
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}
