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
    func setupLayout()
    func setupAttribute()
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
        viewController?.setupLayout()
        viewController?.setupAttribute()
    }
    
    func viewWillAppear() {
        loadMyData()
    }
    
    private func loadMyData() {
        let myNickName = MyData.my.nickname
        let myStar = String(BookmarkFacadeManager().loadAllData().count)
        
        var myPlace = "0"
        var myReview = "0"
        
        AVIROAPIManager().getMyContributionCount(MyData.my.id) { [weak self] contributionCountModel in
            if contributionCountModel.statusCode == 200 {
                myPlace = String(contributionCountModel.data.placeCount)
                myReview = String(contributionCountModel.data.commentCount)
            }
            
            self?.myDataModel = MyDataModel(
                id: myNickName,
                place: myPlace,
                review: myReview,
                star: myStar
            )
        }
    }
    
    func whenAfterLogout() {
        LocalMarkerData.shared.deleteAllMarkerModel()
        LocalBookmarkData.shared.deleteAllBookmark()
        MyData.my.whenLogout()
        
        self.keychain.delete("userIdentifier")
        
        viewController?.pushLoginViewController(with: .logout)
    }
    
    func whenAfterWithdrawal() {
        guard let userToken = self.keychain.get("userIdentifier") else { return }
        
        let userModel = AVIROUserWithdrawDTO(userToken: userToken)
        
        AVIROAPIManager().postUserWithrawal(userModel) { [weak self] resultModel in
            if resultModel.statusCode == 200 {
                LocalMarkerData.shared.deleteAllMarkerModel()
                LocalBookmarkData.shared.deleteAllBookmark()
                MyData.my.whenLogout()

                self?.keychain.delete("userIdentifier")
                
                DispatchQueue.main.async {
                    self?.viewController?.pushLoginViewController(with: .withdrawal)
                }
            }
        }
    }
}
