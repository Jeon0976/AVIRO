//
//  LoginViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit
import AuthenticationServices

import KeychainSwift
import AmplitudeSwift

protocol LoginViewProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func pushTabBar()
    func pushRegistrationWhenAppleLogin(_ userModel: AVIROAppleUserSignUpDTO)
    func afterLogoutAndMakeToastButton()
    func afterWithdrawalUserShowAlert()
    func showErrorAlert(with error: String, title: String?)
    func switchIsLoading(with loading: Bool)
}

final class LoginViewPresenter: NSObject {
    weak var viewController: LoginViewProtocol?
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
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
        viewController?.switchIsLoading(with: false)

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
    func whenCheckAfterAppleLogin(with model: AppleUserLoginModel) {
        viewController?.switchIsLoading(with: true)
        
        let checkAppleLoginModel = AVIROAppleUserCheckMemberDTO(
            identityToken: model.identityToken,
            authorizationCode: model.authorizationCode
        )
                
        AVIROAPIManager().checkWhenAppleLogin(with: checkAppleLoginModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let data = success.data {
                        if data.isMember {
                            
                            self?.keychain.set(
                                data.refreshToken,
                                forKey: KeychainKey.appleRefreshToken.rawValue)
                            
                            self?.loadUserDataWhenAppleLogin()
                            
                        } else {
                            let model = AVIROAppleUserSignUpDTO(
                                refreshToken: data.refreshToken,
                                accessToken: data.accessToken,
                                userId: data.userId,
                                userName: model.userName,
                                userEmail: model.userEmail,
                                marketingAgree: false
                            )
                            
                            self?.viewController?.pushRegistrationWhenAppleLogin(model)
                        }
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.switchIsLoading(with: true)
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.switchIsLoading(with: true)
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    private func loadUserDataWhenAppleLogin() {
        guard let refreshToken = keychain.get(KeychainKey.appleRefreshToken.rawValue) else {
            viewController?.showErrorAlert(with: "재시도 해주세요.", title: nil)
            return
        }
        
        let model = AVIROAutoLoginWhenAppleUserDTO(refreshToken: refreshToken)
        
        AVIROAPIManager().appleUserCheck(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let data = success.data {
                        MyData.my.whenLogin(
                            userId: data.userId,
                            userName: data.userName,
                            userEmail: data.userEmail,
                            userNickname: data.nickname,
                            marketingAgree: data.marketingAgree
                        )
                        
                        self?.setAmplitude()
                        self?.viewController?.pushTabBar()
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.switchIsLoading(with: true)
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    private func setAmplitude() {
        appDelegate?.amplitude?.setUserId(userId: MyData.my.id)

        let identify = Identify()
        identify.set(property: "name", value: MyData.my.name)
        identify.set(property: "email", value: MyData.my.email)
        identify.set(property: "nickname", value: MyData.my.nickname)
        
        appDelegate?.amplitude?.identify(identify: identify)
        
        appDelegate?.amplitude?.track(eventType: AMType.login.rawValue)
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
            
            let fullName = appleIDCredential.fullName?.formatted() ?? " "
            let email = appleIDCredential.email ?? " "

            let model = AppleUserLoginModel(
                identityToken: token,
                authorizationCode: code,
                userName: fullName,
                userEmail: email
            )
            
            whenCheckAfterAppleLogin(with: model)
        }
    }
}
