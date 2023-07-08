//
//  RegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

protocol FirstRegistrationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class FirstRegistrationPresenter {
    weak var viewController: FirstRegistrationProtocol?
    
    var userInfoModel: UserInfoModel?
    
    init(viewController: FirstRegistrationProtocol, userInfoModel: UserInfoModel? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        print(userInfoModel)
    }
}
