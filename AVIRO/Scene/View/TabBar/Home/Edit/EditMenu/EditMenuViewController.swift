//
//  EditMenuViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class EditMenuViewController: UIViewController {
    lazy var presenter = EditMenuPresenter(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension EditMenuViewController: EditMenuProtocol {
    func makeLayout() {
        
    }
    
    func makeAttribute() {
        
    }
}
