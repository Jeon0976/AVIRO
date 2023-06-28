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
}

final class MyPageViewPresenter {
    weak var viewController: MyPageViewProtocol?
    
    init(viewController: MyPageViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
