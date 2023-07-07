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
    func pushRegistration(_ userInfo: UserInfoModel)
}

final class LoginViewPresenter {
    weak var viewController: LoginViewProtocol?
    
    let keychain = KeychainSwift()
    
    private let avrioManager = AVIROAPIManager()
    
    init(viewController: LoginViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: Login 후 최초인지 아닌지 확인 처리
    func upLoadUserInfo(_ userInfoModel: UserInfoModel) {
        keychain.set(userInfoModel.userToken,
                     forKey: "userIdentifier")
        
        avrioManager.postUserModel(userInfoModel) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if userInfo.isMember {
                    self?.viewController?.pushTabBar()
                } else {
                    self?.viewController?.pushRegistration(userInfoModel)
                }
            }
        }
    }
}
