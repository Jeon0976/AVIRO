//
//  NickNameChangeblePresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import Foundation

protocol NickNameChangebleProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func setupGesture()
    func changeSubInfo(subInfo: String, isVaild: Bool)
    func initSubInfo()
}

final class NickNameChangeblePresenter {
    weak var viewController: NickNameChangebleProtocol?
    
    private var initNickName = UserId.shared.userNickName
    var userNickname: String?
    
    init(viewController: NickNameChangebleProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupGesture()
    }
    
    func insertUserNickName(_ userNickName: String) {
        self.userNickname = userNickName
    }
    
    func checkDuplication() {
        let nickname = NicknameCheckInput(nickname: userNickname)
        
        if userNickname! != initNickName {
            AVIROAPIManager().postCheckNickname(nickname) { result in
                
                let result = NicknameCheck(
                    statusCode: result.statusCode,
                    isValid: result.isValid,
                    message: result.message
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.changeSubInfo(subInfo: result.message, isVaild: result.isValid)
                }
            }
        } else {
            self.viewController?.initSubInfo()
        }
    }
}
