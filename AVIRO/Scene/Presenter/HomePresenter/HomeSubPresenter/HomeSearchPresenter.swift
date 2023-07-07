//
//  HomeSearchPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

protocol HomeSearchProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class HomeSearchPresenter {
    weak var viewController: HomeSearchProtocol?
    
    init(viewController: HomeSearchProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
