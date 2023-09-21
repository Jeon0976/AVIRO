//
//  ThridRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/13.
//

import UIKit

protocol ThridRegistrationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func pushFinalRegistrationView()
}

final class ThridRegistrationPresenter {
    enum Term: String {
           case aviroUsage = "어비로 이용 약관 (필수)"
           case personalInfo = "개인정보 수집 및 이용에 대한 동의 (필수)"
           case locationService = "위치기반 서비스 이용약관 (필수)"
           case marketing = "이벤트 및 마케팅 활용 동의 (선택)"
    }

    weak var viewController: ThridRegistrationProtocol?

    private let aviroManager = AVIROAPIManager()

    var userInfoModel: AVIROUserSignUpDTO?
        
    private var terms: [Term: Bool] = [
        .aviroUsage: false,
        .personalInfo: false,
        .locationService: false,
        .marketing: false
    ]
    
    init(viewController: ThridRegistrationProtocol, userInfo: AVIROUserSignUpDTO? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfo
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func getTerms() -> [Term: Bool] {
        return terms
    }
    
    func clickedTerm(_ term: Term) {
        terms[term]?.toggle()
        print(terms)
    }
    
    func allAcceptButtonTapped(_ isSelcted: Bool) {
        for (term, _) in terms {
            terms[term] = isSelcted
        }
    }
    
    func checkAllRequiredTerms() -> (Bool, Bool) {
        // 하나 하나 체크 해서 전부다 체크 했을 경우
        let allTermsAllAgreed = terms.allSatisfy { $0.value }
        
        // nextButton 활성 조건
        let requiredTermsAllAgreed = terms.filter {
            $0.key.rawValue.contains("필수")
        }.allSatisfy { $0.value }
                
        return (allTermsAllAgreed, requiredTermsAllAgreed)
    }
    
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        
        userInfoModel.marketingAgree = terms[.marketing] ?? false
        
        print(userInfoModel)
        // TODO: 마지막 페이지 완성후 테스트
        aviroManager.postUserSignupModel(userInfoModel) { userInfo in
            print(userInfo)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.pushFinalRegistrationView()
            }
        }
    }
    
}
