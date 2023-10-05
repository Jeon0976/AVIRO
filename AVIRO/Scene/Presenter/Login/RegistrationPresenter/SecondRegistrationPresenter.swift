//
//  SecondRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

protocol SecondRegistrationProtocol: NSObject {
    func setupLayout()
    func setupGesture()
    func setupAttribute()
    func setupGenderButton()

    func isValidDate(with isValid: Bool)
    
    func pushThridRegistrationView(_ userInfoModel: AVIROAppleUserSignUpDTO)
}

final class SecondRegistrationPresenter {
    weak var viewController: SecondRegistrationProtocol?
    
    private var userInfoModel: AVIROAppleUserSignUpDTO?
    
    var birth = "" {
        didSet {
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(afterEndTimer),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    var gender: Gender?
    private var isWrongBirth = true
        
    private var timer: Timer?
    
    init(viewController: SecondRegistrationProtocol,
         userInfoModel: AVIROAppleUserSignUpDTO? = nil
    ) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupGesture()
        viewController?.setupGenderButton()
    }
    
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        
        if isWrongBirth {
            birth = "0"
        }

        if let gender = gender {
            userInfoModel.gender = gender.rawValue
        } else {
            userInfoModel.gender = ""
        }
        
        let birth = Int(birth.components(separatedBy: ".").joined()) ?? 0
        
        userInfoModel.birthday = birth
        
        viewController?.pushThridRegistrationView(userInfoModel)
    }
    
    @objc func afterEndTimer() {
        checkInvalidDate()
    }
    
    private func checkInvalidDate() {
        isWrongBirth = !TimeUtility.isValidDate(birth)
        viewController?.isValidDate(with: !isWrongBirth)
    }
}
