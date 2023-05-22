//
//  InrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

final class InrollPlaceViewController: UIViewController {
    
    lazy var presenter = InrollPlacePresenter(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
}

extension InrollPlaceViewController: InrollPlaceProtocol {
    // MARK: Layout
    func makeLayout() {
        
    }
    
    // MARK: Attribute
    func makeAttribute() {
        
    }
}
