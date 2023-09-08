//
//  MyPageViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/28.
//

import UIKit

protocol MyPageViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func updateMyData(_ myDataModel: MyDataModel)
}

final class MyPageViewPresenter {
    weak var viewController: MyPageViewProtocol?
    
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
        let myNickName = UserId.shared.userId
        let myStar = String(BookmarkFacadeManager().loadAllData().count)
        
        let myPlace = "0"
        let myReview = "0"
        
        myDataModel = MyDataModel(id: myNickName, place: myPlace, review: myReview, star: myStar)
    }
}
