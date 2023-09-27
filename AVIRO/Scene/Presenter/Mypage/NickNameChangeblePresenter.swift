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
    func showErrorAlert(with error: String, title: String?)
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
            AVIROAPIManager().checkNickname(with: nickname) { [weak self] result in
                switch result {
                case .success(let model):
                    if model.statusCode == 200 {
                        self?.viewController?.changeSubInfo(
                            subInfo: model.message,
                            isVaild: model.isValid ?? false
                        )
                    } else {
                        self?.viewController?.showErrorAlert(with: model.message, title: nil)
                    }
                case .failure(let error):
                    self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
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
        
        AVIROAPIManager().editNickname(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    MyData.my.nickname = userNickname
                    self?.viewController?.popViewController()
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
}
