//
//  MenuEditPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

protocol EditMenuProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class EditMenuPresenter {
    weak var viewController: EditMenuProtocol?
    
    init(viewController: EditMenuProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
