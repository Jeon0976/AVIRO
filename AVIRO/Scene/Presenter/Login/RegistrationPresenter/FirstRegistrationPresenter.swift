//
//  RegistrationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/07.
//

import UIKit

protocol FirstRegistrationProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func setupGesture()
    func changeSubInfo(subInfo: String, isVaild: Bool)
    func pushSecondRegistrationView(_ signupModel: AVIROUserSignUpDTO)
    func showErrorAlert(with error: String, title: String?)
}

final class FirstRegistrationPresenter {
    weak var viewController: FirstRegistrationProtocol?
    
    var userModel: CommonUserModel!
    var signupModel: AVIROUserSignUpDTO!
    
    var userNickname: String? {
        didSet {
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(
                timeInterval: 0.2,
                target: self,
                selector: #selector(checkDuplication),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    private var timer: Timer?
        
    init(viewController: FirstRegistrationProtocol,
         userModel: CommonUserModel? = nil
    ) {
        self.viewController = viewController
        self.userModel = userModel
        
        bindingSignupModel()
    }
    
    private func bindingSignupModel() {
        self.signupModel = AVIROUserSignUpDTO(
            userToken: userModel.token,
            userName: userModel.name,
            userEmail: userModel.email,
            marketingAgree: false
        )
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupGesture()
    }
    
    func viewWillAppear() {
        viewController?.setupAttribute()
    }
    
    func insertUserNickName(_ userName: String) {
        userNickname = userName
    }
    
    func nicNameCount() -> Int {
        userNickname?.count ?? 0
    }
    
    @objc private func checkDuplication() {
        
        guard let userNickname = userNickname else { return }
        
        let nickname = AVIRONicknameIsDuplicatedCheckDTO(nickname: userNickname)
        
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
    }
    
    func pushUserInfo() {
        guard let userNickname = userNickname else { return }
        signupModel.nickname = userNickname
        
        viewController?.pushSecondRegistrationView(self.signupModel)
    }
}
