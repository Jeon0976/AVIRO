//
//  MenuEditViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class MenuEditViewController: UIViewController {
    lazy var presenter = MenuEditPresenter(viewController: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension MenuEditViewController: MenuEditProtocol {
    func makeLayout() {
        
    }
    
    func makeAttribute() {
        
    }
}
