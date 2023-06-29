//
//  LoginViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

import KeychainSwift

protocol LoginViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func pushTabBar()
}

final class LoginViewPresenter {
    weak var viewController: LoginViewProtocol?
    
    let keychain = KeychainSwift()
    let images: [String] = ["HomeInfoRequestVegan", "HomeInfoSomeVegan", "HomeInfoVegan"]
    
    init(viewController: LoginViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func makeScrollView() -> Int {
        images.count
    }
    
    func upLoadUserInfo(_ userInfoModel: UserInfoModel) {
        keychain.set(userInfoModel.userIdentifier,
                     forKey: "userIdentifier")
        
        viewController?.pushTabBar()
    }
}
