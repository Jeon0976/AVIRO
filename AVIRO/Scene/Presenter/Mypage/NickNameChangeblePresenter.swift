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
    func popViewController()
}

final class NickNameChangeblePresenter {
    weak var viewController: NickNameChangebleProtocol?
    
    private var initNickName = MyData.my.nickname
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
        guard let userNickname = userNickname else { return }
        
        let nickname = AVIRONicknameIsDuplicatedCheckDTO(nickname: userNickname)
        
        if userNickname != initNickName {
            AVIROAPIManager().postCheckNickname(nickname) { result in
                
                let result = AVIRONicknameIsDuplicatedCheckResultDTO(
                    statusCode: result.statusCode,
                    isValid: result.isValid,
                    message: result.message
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.changeSubInfo(
                        subInfo: result.message,
                        isVaild: result.isValid ?? false
                    )
                }
            }
        } else {
            self.viewController?.initSubInfo()
        }
    }
    
    func updateMyNickname() {
        guard let userNickname = userNickname else { return }
        
        let model = AVIRONicknameChagneableDTO(
            userId: MyData.my.id,
            nickname: userNickname
        )
        
        AVIROAPIManager().postChangeNickname(model) { [weak self] resultModel in
            if resultModel.statusCode == 200 {
                DispatchQueue.main.async {
                    MyData.my.nickname = userNickname
                    print("성공!")
                    self?.viewController?.popViewController()
                }
            } else {
                print(resultModel)
            }
        }
    }
}
