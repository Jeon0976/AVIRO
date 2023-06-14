//
//  LoginViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/14.
//

import UIKit

protocol LoginViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class LoginViewPresenter {
    weak var viewController: LoginViewProtocol?
    
    let images: [String] = ["HomeInfoRequestVegan", "HomeInfoSomeVegan", "HomeInfoVegan"]
    
    init(viewController: LoginViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func makeScrollView() -> Int {
        images.count
    }
}
