//
//  SecondRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

protocol SecondRegistrationProtocol: NSObject {
    func setupLayout()
    func setupGenderButton()
    func setupGesture()
    func setupAttribute()
    func isInvalidDate()
    func isValidDate()
    func birthInit()
    func pushThridRegistrationView(_ userInfoModel: AVIROUserSignUpDTO)
}

final class SecondRegistrationPresenter {
    weak var viewController: SecondRegistrationProtocol?
    
    var userInfoModel: AVIROUserSignUpDTO?
    
    var birth = ""
    var gender: Gender?
    var isWrongBirth = true
        
    init(viewController: SecondRegistrationProtocol,
         userInfoModel: AVIROUserSignUpDTO? = nil
    ) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupGesture()
        viewController?.setupGenderButton()
    }
    
    func viewWillAppear() {
        viewController?.setupAttribute()
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
    
    func checkInvalidDate() {
        if TimeUtility.isValidDate(birth) {
            viewController?.isValidDate()
        } else {
            birth = "0"
            viewController?.isInvalidDate()
        }
    }
}
