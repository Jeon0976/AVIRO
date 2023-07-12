//
//  SecondRegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/12.
//

import UIKit

protocol SecondRegistrationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func invalidDate()
    func birthInit()
}

final class SecondRegistrationPresenter {
    weak var viewController: SecondRegistrationProtocol?
    
    var userInfoModel: UserInfoModel?
    
    var birth = ""
    var gender: Gender?
    
    private let aviroManager = AVIROAPIManager()
    
    init(viewController: SecondRegistrationProtocol,
         userInfoModel: UserInfoModel? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        
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
                viewController?.invalidDate()
            }
            
            if month < 1 || month > 12 || day < 1 || day > 31 {
                 viewController?.invalidDate()
                 return
             }
        } else {
            viewController?.invalidDate()
        }
    }
}
