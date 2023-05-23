//
//  InrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

final class InrollPlaceViewController: UIViewController {
    
    lazy var presenter = InrollPlacePresenter(viewController: self)
    
    var storeTitleExplanation = UILabel()
    var storeTitle = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension InrollPlaceViewController: InrollPlaceProtocol {
    // MARK: Layout
    func makeLayout() {
        navigationItem.title = "식당 정보"
    }
    
    // MARK: Attribute
    func makeAttribute() {
        
    }
}
