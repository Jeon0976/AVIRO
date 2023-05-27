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
}

final class DetailViewPresenter {
    weak var viewController: DetailViewProtocol?
    
    var veganModel: VeganModel?
    
    init(viewController: DetailViewProtocol,
         veganModel: VeganModel? = nil) {
        self.viewController = viewController
        self.veganModel = veganModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.showOthers()
    }
}
