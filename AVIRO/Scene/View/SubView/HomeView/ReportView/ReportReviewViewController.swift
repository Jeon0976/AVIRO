//
//  ReportReviewViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import UIKit

final class ReportReviewViewController: UIViewController {
    lazy var presenter = ReportReviewPresenter(viewController: self)
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var reportButotn: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var separatedLine: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension ReportReviewViewController: ReportReviewProtocol {
    func makeLayout() {
        view.backgroundColor = .gray7
    }
    
    func makeAttribute() {
        
    }
}
