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
}

final class SecondRegistrationPresenter {
    weak var viewController: SecondRegistrationProtocol?
    
    var userInfoModel: UserInfoModel?
    
    var birth: Int?
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
}
