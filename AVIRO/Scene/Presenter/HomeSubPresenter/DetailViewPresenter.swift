//
//  DetailViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

protocol DetailViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func showOthers()
    func updateComment(_ model: VeganModel?)
}

final class DetailViewPresenter {
    weak var viewController: DetailViewProtocol?
    
    var placeId: String
    
    init(viewController: DetailViewProtocol, placeId: String) {
        self.viewController = viewController
        self.placeId = placeId
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.showOthers()
    }
    
//    func reloadVeganModel(_ model: VeganModel) {
//        veganModel = model
//        viewController?.updateComment(veganModel)
//    }
}
