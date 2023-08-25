//
//  MenuEditPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

protocol MenuEditProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class MenuEditPresenter {
    weak var viewController: MenuEditProtocol?
    
    init(viewController: MenuEditProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
