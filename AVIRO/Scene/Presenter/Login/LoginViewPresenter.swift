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
    func pushRegistration(_ userInfo: AVIROUserSignUpDTO)
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
    func upLoadUserInfo(_ userInfoModel: AVIROUserSignUpDTO) {
        keychain.set(userInfoModel.userToken,
                     forKey: "userIdentifier")
        
        let userCheck = AVIROAppleUserCheckMemberDTO(userToken: userInfoModel.userToken)
        
        AVIROAPIManager().postCheckUserModel(userCheck) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if userInfo.statusCode == 200 {
//                    self?.viewController.
                } else {
                    
                }
//                if userInfo.isMember {
//                    self?.viewController?.pushTabBar()
//                } else {
//                    self?.viewController?.pushRegistration(userInfoModel)
//                }
            }
        }
    }
}
