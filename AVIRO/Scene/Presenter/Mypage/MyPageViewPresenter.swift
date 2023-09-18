//
//  MyPageViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/28.
//

import UIKit

import KeychainSwift

enum PushLoginViewEnum {
    case logout
    case withdrawal
}

protocol MyPageViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func updateMyData(_ myDataModel: MyDataModel)
    func pushLoginViewController(with: PushLoginViewEnum)
}

final class MyPageViewPresenter {
    weak var viewController: MyPageViewProtocol?
    
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
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func viewWillAppear() {
        loadMyData()
    }
    
    private func loadMyData() {
        let myNickName = UserId.shared.userNickname
        let myStar = String(BookmarkFacadeManager().loadAllData().count)
        
        let myPlace = "0"
        let myReview = "0"
        
        myDataModel = MyDataModel(id: myNickName, place: myPlace, review: myReview, star: myStar)
    }
    
    func whenAfterLogout() {
        MarkerModelArray.shared.deleteAllMarkerModel()
        UserId.shared.whenLogout()
        BookmarkArray.shared.deleteAllBookmark()
        self.keychain.delete("userIdentifier")
        
        viewController?.pushLoginViewController(with: .logout)
    }
    
    func whenAfterWithdrawal() {
        guard let userToken = self.keychain.get("userIdentifier") else { return }
        
        let userModel = AVIROUserWithdrawDTO(userToken: userToken)
        
        AVIROAPIManager().postUserWithrawal(userModel) { [weak self] resultModel in
            print(resultModel)
            if resultModel.statusCode == 200 {
                self?.keychain.delete("userIdentifier")
                DispatchQueue.main.async {
                    MarkerModelArray.shared.deleteAllMarkerModel()
                    UserId.shared.whenLogout()
                    BookmarkArray.shared.deleteAllBookmark()
                    
                    self?.viewController?.pushLoginViewController(with: .withdrawal)
                }
            }
        }
    }
}
