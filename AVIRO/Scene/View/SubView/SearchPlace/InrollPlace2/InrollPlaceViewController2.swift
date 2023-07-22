//
//  InrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class InrollPlaceViewController2: UIViewController {
    lazy var presenter = InrollPlacePresenter2(viewController: self)
    
    var scrollView = UIScrollView()
    
    var storeInfoView = StoreInfoView()
    var veganDetailView = VeganDetailView()
    var menuTableView = MenuTableView()
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarAttributed()
    }
}

// MARK: Protocol Method
extension InrollPlaceViewController2: InrollPlaceProtocol2 {
    // MARK: Layout
    func makeLayout() {
        [
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        [
            storeInfoView,
            veganDetailView,
            menuTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // storeInfoView
            storeInfoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            storeInfoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            storeInfoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            storeInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            // veganDetailView
            veganDetailView.topAnchor.constraint(equalTo: storeInfoView.bottomAnchor, constant: 15),
            veganDetailView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            veganDetailView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            veganDetailView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            veganDetailView.heightAnchor.constraint(equalToConstant: 200),
            
            // menuTableView
            menuTableView.topAnchor.constraint(equalTo: veganDetailView.bottomAnchor, constant: 15),
            menuTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            menuTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            menuTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            menuTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            menuTableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // navigation, view...
        viewAttributed()
        navigationAttributed()
        tabBarAttributed()
        
    }
    
    // MARK: Gesture
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }

}

// MARK: @Objc Method
extension InrollPlaceViewController2 {
    // TODO: Report Button Logic 처리
    @objc func reportStore() {
        
    }
    
    @objc func backToMain() {
        tabBarController?.selectedIndex = 0

    }
}

// MARK: TapGestureDelegate
extension InrollPlaceViewController2: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // TODO: touch가 textField이면서 가게 기본 정보가 아니면 flase
        if touch.view is UITextField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

// MARK: Private Method
extension InrollPlaceViewController2 {
    // MARK: View Attribute
    private func viewAttributed() {
        view.backgroundColor = .white

        scrollView.backgroundColor = .systemGray6
        
        storeInfoView.backgroundColor = .white
        veganDetailView.backgroundColor = .white
        menuTableView.backgroundColor = .white
        
        storeInfoView.layer.cornerRadius = 16
        veganDetailView.layer.cornerRadius = 16
        menuTableView.layer.cornerRadius = 16
    }
    
    // MARK: Navigation Attribute
    private func navigationAttributed() {
        navigationItem.backButtonTitle = ""
        navigationItem.title = "가게 등록하기"
        navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(title: "등록하기", style: .plain, target: self, action: #selector(reportStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // TODO: Check
        let leftBarButton = UIBarButtonItem(title: "테스트", style: .plain, target: self, action: #selector(backToMain))
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    // MARK: TabBar Attribute
    private func tabBarAttributed() {
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
    }
    
}
