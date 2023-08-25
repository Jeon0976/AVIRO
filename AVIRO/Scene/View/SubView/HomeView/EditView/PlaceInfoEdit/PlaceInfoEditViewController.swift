//
//  PlaceInfoEditViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

final class PlaceInfoEditViewController: UIViewController {
    lazy var presenter = PlaceInfoEditPresenter(viewController: self)
    
    let items = ["위치", "전화번호", "영업시간", "홈페이지"]
    
    lazy var topLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    lazy var segmentedControl: UnderlineSegmentedControl = {
        let segmented = UnderlineSegmentedControl(items: items)
        
        segmented.setAttributedTitle()
        segmented.selectedSegmentIndex = 0
        
        return segmented
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension PlaceInfoEditViewController: PlaceInfoEditProtocol {
    func makeLayout() {
        [
            topLine,
            segmentedControl
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            topLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            segmentedControl.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func makeAttribute() {
        
        self.view.backgroundColor = .gray7
        self.setupCustomBackButton()
        navigationController?.navigationBar.isHidden = false

        navigationItem.title = "정보 수정 요청하기"
        
        let rightBarButton = UIBarButtonItem(title: "요청하기", style: .plain, target: self, action: #selector(editStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
    }
    
    @objc private func editStore() {
        
    }
}
