//
//  SecondRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

protocol SecondRegistrationProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func setupGesture()
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
    
    private let aviroManager = AVIROAPIManager()
    
    init(viewController: SecondRegistrationProtocol,
         userInfoModel: AVIROUserSignUpDTO? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupGesture()
    }
    
    // MARK: 생일, 성별 회원 데이터에 추가 후 다음 페이지
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
    
    // MARK: String to Int (DateFormatter 활용) & Check Invaild Date
    func checkInvalidDate() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        if let date = dateFormatter.date(from: birth) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let currentYear = calendar.component(.year, from: Date())
            
            if year > currentYear {
                viewController?.isInvalidDate()
                birth = "0"
            } else if year < 1920 {
                viewController?.isInvalidDate()
                birth = "0"
            } else if month < 1 || month > 12 || day < 1 || day > 31 {
                viewController?.isInvalidDate()
                birth = "0"
                return
            } else {
                viewController?.isValidDate()
            }
        } else {
            viewController?.isInvalidDate()
            birth = "0"
        }
    }
}
