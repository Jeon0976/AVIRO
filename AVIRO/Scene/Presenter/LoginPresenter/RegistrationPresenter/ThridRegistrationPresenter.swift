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
    weak var viewController: ThridRegistrationProtocol?

    private let aviroManager = AVIROAPIManager()

    var userInfoModel: UserInfoModel?
        
    var terms = [
        ("어비로 이용 약관 (필수)", false),
        ("개인정보 수집 및 이용에 대한 동의 (필수)", false),
        ("위치기반 서비스 이용약관 (필수)", false),
        ("이벤트 및 마케팅 활용 동의 (선택)", false)
    ]
    
    init(viewController: ThridRegistrationProtocol, userInfo: UserInfoModel? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfo
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: All Accept Button 클릭 시
    func allAcceptButtonTapped(_ isSelcted: Bool) {
        if isSelcted {
            for index in terms.indices {
                terms[index].1 = true
            }
        } else {
            for index in terms.indices {
                terms[index].1 = false
            }
        }
    }
    
    // MARK: 하나 하나 클릭, nextButton 활성화 조건
    func checkAllRequiredTerms() -> (Bool, Bool) {
        // 하나 하나 체크 해서 전부다 체크 했을 경우
        let allTermsAllAgreed = terms.allSatisfy { $0.1 }
        
        // nextButton 활성 조건
        let requiredTermsAllAgreed = terms.filter { $0.0.contains("필수")}.allSatisfy { $0.1 }
        
        return (allTermsAllAgreed, requiredTermsAllAgreed)
    }
    
    // MARK: user Info 등록하기
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        
        userInfoModel.marketingAgree = terms.last?.1 ?? false
        
        print(userInfoModel)
        viewController?.pushFinalRegistrationView()
        // TODO: 마지막 페이지 완성후 테스트
//        aviroManager.postUserModel(userInfoModel) { userInfo in
//            print(userInfo.statusCode)
//            DispatchQueue.main.async { [weak self] in
//                self?.viewController?.pushFinalRegistrationView()
//            }
//        }
    }
    
}
