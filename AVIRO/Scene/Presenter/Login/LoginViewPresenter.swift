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
    func showErrorAlert(with error: String, title: String?)
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
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: appleUserModel.userIdentifier)
        
        AVIROAPIManager().checkAppleToken(with: userCheck) { [weak self] result in
            switch result {
            case .success(let model):
                if model.data != nil {
                    let userId = model.data?.userId ?? ""
                    let userName = model.data?.userName ?? ""
                    let userEmail = model.data?.userEmail ?? ""
                    let userNickname = model.data?.nickname ?? ""
                    let marketingAgree = model.data?.marketingAgree ?? 0
                    
                    MyData.my.whenLogin(
                        userId: userId,
                        userName: userName,
                        userEmail: userEmail,
                        userNickname: userNickname,
                        marketingAgree: marketingAgree
                    )
                    
                    self?.keychain.set(userId, forKey: KeychainKey.userId.rawValue)
                    self?.viewController?.pushTabBar()
                } else {
                    let userModel = CommonUserModel(
                        token: appleUserModel.userIdentifier,
                        name: appleUserModel.name,
                        email: appleUserModel.email
                    )
                    
                    self?.viewController?.pushRegistration(userModel)
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
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
            guard let authorizationCode = appleIDCredential.authorizationCode,
                  let identityToken = appleIDCredential.identityToken
            else { return }

            let code = String(data: authorizationCode, encoding: .utf8)!
            let token = String(data: identityToken, encoding: .utf8)!
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.formatted() ?? ""
            let email = appleIDCredential.email ?? ""
            
            let appleUserModel = AppleUserModel(
                userIdentifier: userIdentifier,
                name: fullName,
                email: email
            )
            
            print(code)
            print(token)
            print(appleUserModel)
//            whenCheckAfterAppleLogin(appleUserModel)
        }
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        viewController?.showErrorAlert(with: error.localizedDescription, title: "애플 로그인 에러")
    }
}
