//
//  ThridRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

import KeychainSwift

protocol ThridRegistrationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func pushFinalRegistrationView()
}

final class ThridRegistrationPresenter {
    enum Term: String {
           case aviroUsage = "어비로 이용 약관 동의 (필수)"
           case personalInfo = "개인정보 수집 및 이용 동의 (필수)"
           case locationService = "위치기반 서비스 이용약관 동의 (필수)"
    }

    weak var viewController: ThridRegistrationProtocol?

    private let aviroManager = AVIROAPIManager()
    private let keyChain = KeychainSwift()
    
    var userInfoModel: AVIROUserSignUpDTO?
        
    var terms: [(Term, Bool)] = [
        (.aviroUsage, false),
        (.personalInfo, false),
        (.locationService, false)
    ]
    
    init(viewController: ThridRegistrationProtocol, userInfo: AVIROUserSignUpDTO? = nil) {
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
        
        aviroManager.postUserSignupModel(userInfoModel) { userInfo in
            DispatchQueue.main.async { [weak self] in
                if let userId = userInfo.userId {
                    self?.keyChain.set(userId, forKey: KeychainKey.userId.rawValue)
                    self?.viewController?.pushFinalRegistrationView()
                }
            }
        }
    }
    
}
