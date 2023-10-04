//
//  ThridRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

import KeychainSwift
import AmplitudeSwift

protocol ThridRegistrationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func pushFinalRegistrationView()
    func showErrorAlert(with error: String, title: String?)
}

final class ThridRegistrationPresenter {
    enum Term: String {
           case aviroUsage = "어비로 이용 약관 동의 (필수)"
           case personalInfo = "개인정보 수집 및 이용 동의 (필수)"
           case locationService = "위치기반 서비스 이용약관 동의 (필수)"
    }

    weak var viewController: ThridRegistrationProtocol?

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let keyChain = KeychainSwift()
    
    var userInfoModel: AVIROAppleUserSignUpDTO?
        
    var terms: [(Term, Bool)] = [
        (.aviroUsage, false),
        (.personalInfo, false),
        (.locationService, false)
    ]
    
    init(viewController: ThridRegistrationProtocol,
         userInfo: AVIROAppleUserSignUpDTO? = nil
    ) {
        self.viewController = viewController
        self.userInfoModel = userInfo
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func clickedTerm(at index: Int) {
        terms[index].1.toggle()
    }
    
    func allAcceptButtonTapped(_ isSelcted: Bool) {
        for index in terms.indices {
            terms[index].1 = isSelcted
        }
    }
    
    func checkAllRequiredTerms() -> Bool {
        return !terms.contains(where: { $0.1 == false })
    }
    
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        
        userInfoModel.marketingAgree = false
                
        AVIROAPIManager().createAppleUser(with: userInfoModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let data = success.data {
                        self?.keyChain.set(
                            userInfoModel.refreshToken,
                            forKey: KeychainKey.appleRefreshToken.rawValue)
                        
                        MyData.my.whenLogin(
                            userId: data.userId,
                            userName: data.userName,
                            userEmail: data.userEmail,
                            userNickname: data.nickname,
                            marketingAgree: data.marketingAgree
                        )
                        
                        self?.setAmplitude()
                        self?.viewController?.pushFinalRegistrationView()
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
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
        
        appDelegate?.amplitude?.track(eventType: AMType.signUp.rawValue)
    }
}
