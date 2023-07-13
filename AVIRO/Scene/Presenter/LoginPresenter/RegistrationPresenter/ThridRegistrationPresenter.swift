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
}

final class ThridRegistrationPresenter {
    weak var viewController: ThridRegistrationProtocol?

    private let aviroManager = AVIROAPIManager()

    var userInfoModel: UserInfoModel?
    
    var marketingAgree = false
    
    init(viewController: ThridRegistrationProtocol, userInfo: UserInfoModel? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfo
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
