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
    func changeSubInfo(subInfo: String, isVaild: Bool)
    func pushSecondRegistrationView(_ userInfoModel: UserInfoModel)
}

final class FirstRegistrationPresenter {
    weak var viewController: FirstRegistrationProtocol?
    private let aviroManager = AVIROAPIManager()

    var userInfoModel: UserInfoModel?
    var userNickname: String?
        
    init(viewController: FirstRegistrationProtocol, userInfoModel: UserInfoModel? = nil) {
        self.viewController = viewController
        self.userInfoModel = userInfoModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: Nickname Setting Method
    func insertUserNickName(_ userName: String) {
        userNickname = userName
    }
    
    func nicNameCount() -> Int {
        userNickname?.count ?? 0
    }
    
    // MARK: Nickmane Check Method
    func checkDuplication() {
        let nickname = NicknameCheckInput(nickname: userNickname)
        aviroManager.postCheckNickname(nickname) { result in
            let result = NicknameCheck(
                statusCode: result.statusCode,
                isValid: result.isValid,
                message: result.message
            )
            
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.changeSubInfo(subInfo: result.message, isVaild: result.isValid)
            }
        }
    }
    
    // MARK: Nicmane + UserModel Push Method
    func pushUserInfo() {
        guard var userInfoModel = userInfoModel else { return }
        userInfoModel.nickname = userNickname
        viewController?.pushSecondRegistrationView(userInfoModel)
    }
}
