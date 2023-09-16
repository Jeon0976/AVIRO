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
    func makeNaviAttribute()
    func pushTabBar()
    func pushRegistration(_ userModel: CommonUserModel)
    func afterLogoutAndMakeToastButton()
    func afterWithdrawalUserShowAlert()
}

final class LoginViewPresenter {
    weak var viewController: LoginViewProtocol?
    
    private let keychain = KeychainSwift()
        
    var whenAfterLogout = false
    var whenAfterWithdrawal = false
    
    init(viewController: LoginViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func viewWillAppear() {
        viewController?.makeNaviAttribute()
        
        if whenAfterWithdrawal {
            viewController?.afterWithdrawalUserShowAlert()
            whenAfterWithdrawal.toggle()
        }
        
        if whenAfterLogout {
            viewController?.afterLogoutAndMakeToastButton()
            whenAfterLogout.toggle()
        }
    }
    // MARK: Login 후 최초인지 아닌지 확인 처리
    func whenCheckAfterAppleLogin(_ appleUserModel: AppleUserModel) {
        keychain.set(appleUserModel.userIdentifier,
                     forKey: "userIdentifier")
        
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: appleUserModel.userIdentifier)
                
        AVIROAPIManager().postCheckUserModel(userCheck) { userInfo in
            print(userInfo)
            DispatchQueue.main.async { [weak self] in
                if userInfo.data != nil {
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
                    
                    self?.viewController?.pushTabBar()
                } else {
                    let userModel = CommonUserModel(
                        token: appleUserModel.userIdentifier,
                        name: appleUserModel.name,
                        email: appleUserModel.email
                    )
                    
                    self?.viewController?.pushRegistration(userModel)
                }
            }
        }
    }
    
}
