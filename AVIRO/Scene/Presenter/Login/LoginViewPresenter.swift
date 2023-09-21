//
//  LoginViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

import KeychainSwift

protocol LoginViewProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func pushTabBar()
    func pushRegistration(_ userModel: CommonUserModel)
    func afterLogoutAndMakeToastButton()
    func afterWithdrawalUserShowAlert()
}

final class LoginViewPresenter: NSObject {
    weak var viewController: LoginViewProtocol?
    
    private let keychain = KeychainSwift()
        
    var whenAfterLogout = false
    var whenAfterWithdrawal = false
    
    init(viewController: LoginViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
    }
    
    func viewWillAppear() {
        
        if whenAfterWithdrawal {
            viewController?.afterWithdrawalUserShowAlert()
            whenAfterWithdrawal.toggle()
        }
        
        if whenAfterLogout {
            viewController?.afterLogoutAndMakeToastButton()
            whenAfterLogout.toggle()
        }
    }
    
    func clickedAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
            as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    // MARK: Login 후 최초인지 아닌지 확인 처리
    func whenCheckAfterAppleLogin(_ appleUserModel: AppleUserModel) {
        keychain.set(
            appleUserModel.userIdentifier,
            forKey: KeychainKey.appleIdentifier.rawValue
        )
        
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: appleUserModel.userIdentifier)
        
        AVIROAPIManager().postCheckUserModel(userCheck) { [weak self] userInfo in
            if userInfo.data != nil {
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
                
                DispatchQueue.main.async {
                    self?.viewController?.pushTabBar()
                }
            } else {
                let userModel = CommonUserModel(
                    token: appleUserModel.userIdentifier,
                    name: appleUserModel.name,
                    email: appleUserModel.email
                )
                
                DispatchQueue.main.async {
                    self?.viewController?.pushRegistration(userModel)
                }
            }
            
        }
    }
}

// MARK: Apple Login 처리 설정
extension LoginViewPresenter: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let appleUserModel = AppleUserModel(
                userIdentifier: userIdentifier,
                name: fullName,
                email: email
            )
            
            whenCheckAfterAppleLogin(appleUserModel)
        }
    }
    
    // TODO: Error 처리
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        
    }
}
