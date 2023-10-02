//
//  MyPageViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/28.
//

import UIKit

import KeychainSwift

enum LoginRedirectReason {
    case logout
    case withdrawal
}

protocol MyPageViewProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
    func updateMyData(_ myDataModel: MyDataModel)
    func pushLoginViewController(with: LoginRedirectReason)
    func showErrorAlert(with error: String, title: String?)
}

final class MyPageViewPresenter {
    weak var viewController: MyPageViewProtocol?
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let keychain = KeychainSwift()
    
    private var myDataModel: MyDataModel? {
        didSet {
            guard let myDataModel = myDataModel else { return }
            DispatchQueue.main.async {
                self.viewController?.updateMyData(myDataModel)
            }
        }
    }
    
    init(viewController: MyPageViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
    }
    
    func viewWillAppear() {
        loadMyData()
    }
    
    private func loadMyData() {
        let myNickName = MyData.my.nickname
        let myStar = String(BookmarkFacadeManager().loadAllData().count)
        
        AVIROAPIManager().loadMyContributedCount(with: MyData.my.id) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let myPlace = success.data?.placeCount,
                       let myReview = success.data?.commentCount {
                        
                        let myPlaceString = String(myPlace)
                        let myReviewString = String(myReview)
                        
                        self?.myDataModel = MyDataModel(
                            id: myNickName,
                            place: myPlaceString,
                            review: myReviewString,
                            star: myStar
                        )
                    }
                } else {
                    self?.viewController?.showErrorAlert(with: "서버 에러", title: nil)
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)

            }
        }
    }
    
    func whenAfterLogout() {
        LocalMarkerData.shared.deleteAllMarkerModel()
        LocalBookmarkData.shared.deleteAllBookmark()
        MyData.my.whenLogout()
        trackWhenLogout()
        self.keychain.delete(KeychainKey.appleRefreshToken.rawValue)
        
        viewController?.pushLoginViewController(with: .logout)
    }
    
    func whenAfterWithdrawal() {
        guard let refreshToken = keychain.get(KeychainKey.appleRefreshToken.rawValue) else { return }
        
        let model = AVIROAutoLoginWhenAppleUserDTO(refreshToken: refreshToken)
        
        print(model)
                
        AVIROAPIManager().revokeAppleUser(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                print(result)
                if success.statusCode == 200 {
                    LocalBookmarkData.shared.deleteAllBookmark()
                    MyData.my.whenLogout()
                    self?.keychain.delete(KeychainKey.appleRefreshToken.rawValue)
                    
                    DispatchQueue.main.async {
                        LocalMarkerData.shared.deleteAllMarkerModel()
                        
                        self?.viewController?.pushLoginViewController(with: .withdrawal)
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                print(result)
 
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    private func trackWhenLogout() {
        appDelegate?.amplitude?.track(eventType: "Logout")
    }
}
