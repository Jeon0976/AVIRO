//
//  NickNameChangeblePresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/08.
//

import Foundation

protocol NickNameChangebleProtocol: NSObject {
    func setupLayout()
    func setupAttribute()
}

final class NickNameChangeblePresenter {
    weak var viewController: NickNameChangebleProtocol?
    
    init(viewController: NickNameChangebleProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupLayout()
        viewController?.setupAttribute()
    }
}
