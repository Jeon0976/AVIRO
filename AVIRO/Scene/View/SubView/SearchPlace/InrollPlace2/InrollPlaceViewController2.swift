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
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
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
        storeInfoViewAttribute()
    }
    
    // MARK: Gesture
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }

    // MARK: Notification
    func makeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
    }
}

// MARK: @Objc Method
extension InrollPlaceViewController2 {
    // TODO: Report Button Logic 처리
    @objc func reportStore() {
        
    }
    
    // MARK: 홈 화면으로 돌아가기
    @objc func backToMain() {
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: 검색 결과 데이터 binding
    @objc func selectedPlace(_ notification: Notification) {
        guard let selectedPlace = notification.userInfo?["selectedPlace"] as? PlaceListModel else { return }
        
        presenter.updatePlaceModel(selectedPlace)
        
        storeInfoView.titleField.text = selectedPlace.title
        storeInfoView.addressField.text = selectedPlace.address
        storeInfoView.numberField.text = selectedPlace.phone
        storeInfoView.expandStoreInformation()
    }
    
    // MARK: Category button 클릭 시
    @objc func buttonTapped(_ sender: UIButton) {
        for button in storeInfoView.categoryButtons {
            button.isSelected = (button == sender)
        }
        
        guard let title = sender.currentAttributedTitle?.string else { return }
        
        switch title {
        case Category.restaurant.title:
            presenter.updateCategory(Category.restaurant)
        case Category.cafe.title:
            presenter.updateCategory(Category.cafe)
        case Category.bakery.title:
            presenter.updateCategory(Category.bakery)
        case Category.bar.title:
            presenter.updateCategory(Category.bar)
        default:
            presenter.updateCategory(nil)
        }
    }
}

// MARK: TapGestureDelegate
extension InrollPlaceViewController2: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // TODO: touch가 textField이면서 가게 기본 정보가 아니면 false
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
    
    // MARK: storeInfo View Attribute
    private func storeInfoViewAttribute() {
        storeInfoView.titleField.delegate = self
        
        storeInfoView.categoryButtons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
}

extension InrollPlaceViewController2: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == storeInfoView.titleField {
            let viewController = PlaceListViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            return true
        }
        
        return true
    }
}
