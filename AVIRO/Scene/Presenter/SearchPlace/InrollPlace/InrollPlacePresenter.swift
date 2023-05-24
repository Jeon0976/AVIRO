//
//  InrollPlacePresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

protocol InrollPlaceProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class InrollPlacePresenter: NSObject {
    weak var viewController: InrollPlaceProtocol?
    
    init(viewController: InrollPlaceProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
}
