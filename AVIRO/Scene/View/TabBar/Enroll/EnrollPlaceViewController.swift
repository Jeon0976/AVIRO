//
//  EnrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/07/20.
//

import UIKit

final class EnrollPlaceViewController: UIViewController {
    lazy var presenter = EnrollPlacePresenter(viewController: self)
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var storeInfoView = EnrollStoreInfoView()
    private lazy var veganDetailView = EnrollVeganDetailView()
    private lazy var menuTableView = EnrollMenuTableView()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
    }
}

extension EnrollPlaceViewController: EnrollPlaceProtocol {
    // MARK: Layout
    func makeLayout() {
        
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
            storeInfoView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 15),
            storeInfoView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            storeInfoView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            // veganDetailView
            veganDetailView.topAnchor.constraint(equalTo: storeInfoView.bottomAnchor, constant: 15),
            veganDetailView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            veganDetailView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            // menuTableView
            menuTableView.topAnchor.constraint(equalTo: veganDetailView.bottomAnchor, constant: 15),
            menuTableView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -15),
            menuTableView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            menuTableView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
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
        
    }
    
    // MARK: Attribute
    func makeAttribute() {
        viewAttributed()
        navigationAttributed()
        storeInfoViewAttribute()
        veganDetailViewAttribute()
        menuTableViewAttribute()
    }
    
    // MARK: ViewWillAppear Attribute
    func makeAttributeWhenViewWillAppear() {
        tabBarAttributed()
    }
    
    // MARK: Gesture
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }

    // MARK: Notification
    func makeNotification() {
        // after search method
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
        
        // keyboard가 보이는 중에 resign해서 view의 높이가 변경되는 버그 수정을 위한 notification
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appWillResignActive() {
        self.scrollView.transform = .identity
    }
    
    // MARK: After Search
    func updatePlaceInfo(_ storeInfo: PlaceListModel) {
        storeInfoView.titleField.text = storeInfo.title
        storeInfoView.addressField.text = storeInfo.address
        storeInfoView.numberField.text = storeInfo.phone
        
        storeInfoView.expandStoreInfoView()
    }
    
    // MARK: All Vegan 클릭 시
    func allVeganTapped() {
        veganDetailView.allVeganButton.isSelected.toggle()
        
        if veganDetailView.allVeganButton.isSelected {
            presenter.isPresentingDefaultTable = true
            veganDetailView.someVeganButton.isSelected = false
            veganDetailView.requestVeganButton.isSelected = false
            presenter.changeButton(allVegan: true, someVegan: false, requestVegan: false)
            changeMenuTable(presenter.isPresentingDefaultTable)
        } else {
            presenter.changeButton(allVegan: false, someVegan: false, requestVegan: false)
        }
    }
    
    // MARK: Some Vegan 클릭 시
    func someVeganTapped() {
        veganDetailView.someVeganButton.isSelected.toggle()
        veganDetailView.allVeganButton.isSelected = false

        if veganDetailView.someVeganButton.isSelected && veganDetailView.requestVeganButton.isSelected {
            presenter.changeButton(allVegan: false, someVegan: true, requestVegan: true)
            changeMenuTable(presenter.isPresentingDefaultTable)
        } else if veganDetailView.someVeganButton.isSelected {
            presenter.changeButton(allVegan: false, someVegan: true, requestVegan: false)
        } else if veganDetailView.requestVeganButton.isSelected && !veganDetailView.someVeganButton.isSelected {
            presenter.changeButton(allVegan: false, someVegan: false, requestVegan: true)
        } else {
            presenter.changeButton(allVegan: false, someVegan: false, requestVegan: false)
        }
    }
    
    // MARK: Request Vegan 클릭 시
    func requestVeganTapped() {
        veganDetailView.requestVeganButton.isSelected.toggle()
        veganDetailView.allVeganButton.isSelected = false
        
        if veganDetailView.requestVeganButton.isSelected && veganDetailView.someVeganButton.isSelected {
            presenter.isPresentingDefaultTable = false
            changeMenuTable(presenter.isPresentingDefaultTable)
            presenter.changeButton(allVegan: false, someVegan: true, requestVegan: true)
        } else if veganDetailView.requestVeganButton.isSelected && !veganDetailView.someVeganButton.isSelected {
            presenter.isPresentingDefaultTable = false
            changeMenuTable(presenter.isPresentingDefaultTable)
            presenter.changeButton(allVegan: false, someVegan: false, requestVegan: true)
        } else if !veganDetailView.requestVeganButton.isSelected && veganDetailView.someVeganButton.isSelected {
            presenter.isPresentingDefaultTable = true
            changeMenuTable(presenter.isPresentingDefaultTable)
            presenter.changeButton(allVegan: false, someVegan: true, requestVegan: false)
        } else {
            presenter.isPresentingDefaultTable = true
            changeMenuTable(presenter.isPresentingDefaultTable)
            presenter.changeButton(allVegan: false, someVegan: false, requestVegan: false)
        }
    }
    
    // MARK: TableView Reload
    func menuTableReload(isPresentingDefaultTable: Bool) {
        if isPresentingDefaultTable {
            changeMenuTable(isPresentingDefaultTable)
            menuTableView.normalTableView.reloadData()
        } else {
            changeMenuTable(isPresentingDefaultTable)
            menuTableView.requestTableView.reloadData()
        }
    }
    
    // MARK: Keyboard Will Show
    func keyboardWillShow(height: CGFloat) {
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let result = height - tabBarHeight
        
        UIView.animate(
            withDuration: 0.3,
            animations: { self.scrollView.transform = CGAffineTransform(
                translationX: 0,
                y: -(result))
            }
        )
    }
    
    // MARK: Keyboard Will Hide
    func keyboardWillHide() {
        self.scrollView.transform = .identity
    }
    
    // MARK: Enable Right Button
    func enableRightButton(_ bool: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = bool
    }
    
    // MARK: Pop View Controller
    func popViewController() {
        initData()
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: Push Alert Controller
    func pushAlertController() {
        let title = "이미 등록된 가게입니다"
        let message = "다른 유저가 이미 등록한 가게예요.\n홈 화면에서 검색해보세요."
        showAlert(title: title, message: message)
    }
}

// MARK: Private Method
extension EnrollPlaceViewController {
    // MARK: Init Data
    private func initData() {
        presenter.initData()
        initStoreInfoView()
        initVeganDetailView()
        initmenuTableView()
    }
    
    // MARK: Init Store Info View
    private func initStoreInfoView() {
        storeInfoView.titleField.text = nil
        storeInfoView.addressField.text = nil
        storeInfoView.numberField.text = nil
        
        storeInfoView.categoryButtons.forEach {
            $0.isSelected = false
        }
        storeInfoView.initStoreInfoViewHeight()
    }
    
    // MARK: Init Vegan Detail View
    private func initVeganDetailView() {
        veganDetailView.veganOptions.forEach {
            $0.isSelected = false
        }
    }
    
    // MARK: Init Menu Table View
    private func initmenuTableView() {
        changeMenuTable(presenter.isPresentingDefaultTable)
    }
    
    // MARK: View Attribute
    private func viewAttributed() {
        view.backgroundColor = .gray7

        scrollView.backgroundColor = .gray6
        
        storeInfoView.backgroundColor = .gray7
        veganDetailView.backgroundColor = .gray7
        menuTableView.backgroundColor = .gray7
        
        storeInfoView.layer.cornerRadius = 16
        veganDetailView.layer.cornerRadius = 16
        menuTableView.layer.cornerRadius = 16
    }
    
    // MARK: Navigation Attribute
    private func navigationAttributed() {
        navigationItem.title = "가게 등록하기"
        navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(title: "등록하기", style: .plain, target: self, action: #selector(uploadStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        backButton.addTarget(self, action: #selector(backToMain), for: .touchUpInside)
        backButton.frame = .init(x: 0, y: 0, width: 24, height: 24)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    // MARK: TabBar Attribute
    // TODO: Tab Bar push hidden 처리도 해야함
    private func tabBarAttributed() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor.clear
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
        
        let bar = self.tabBarController?.tabBar
        bar?.standardAppearance.backgroundEffect = nil
        bar?.standardAppearance.backgroundImage = nil
    
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
    }
    
    // MARK: storeInfo View Attribute
    private func storeInfoViewAttribute() {
        storeInfoView.titleField.delegate = self
        storeInfoView.addressField.delegate = self
        storeInfoView.numberField.delegate = self
        
        storeInfoView.categoryButtons.forEach {
            $0.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: vegan Detail View Attrubute
    private func veganDetailViewAttribute() {
        veganDetailView.veganOptions.forEach {
            $0.addTarget(self, action: #selector(veganOptionButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: Menu Table View Attribute
    private func menuTableViewAttribute() {
        menuTableView.normalTableView.dataSource = self
        menuTableView.requestTableView.dataSource = self
        menuTableView.menuPlusButton.addTarget(self, action: #selector(menuPlusButtonTapped), for: .touchUpInside)
    }
        
    // MARK: Menu Table View Show
    private func changeMenuTable(_ isPresentingDefaultTable: Bool) {
        if isPresentingDefaultTable {
            menuTableView.normalTableView.isHidden = false
            menuTableView.requestTableView.isHidden = true
            menuTableView.updateViewHeight(
                defaultTable: isPresentingDefaultTable,
                count: presenter.normalTableCount
            )
        } else {
            menuTableView.normalTableView.isHidden = true
            menuTableView.requestTableView.isHidden = false
            menuTableView.updateViewHeight(
                defaultTable: isPresentingDefaultTable,
                count: presenter.requestTableCount
            )
            
        }
    }
}

extension EnrollPlaceViewController {
    // MARK: Report Button Tapped
    @objc func uploadStore() {
        presenter.uploadStore()
    }
    
    // MARK: 홈 화면으로 돌아가기
    @objc func backToMain() {
        initData()
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: 검색 결과 데이터 binding notification
    @objc func selectedPlace(_ notification: Notification) {
        guard let selectedPlace = notification.userInfo?["selectedPlace"] as? PlaceListModel else { return }
        
        presenter.updatePlaceModel(selectedPlace)
    }
    
    // MARK: Category button 클릭 시
    @objc func categoryTapped(_ sender: UIButton) {
        for button in storeInfoView.categoryButtons {
            button.isSelected = (button == sender)
        }
        
        guard let title = sender.currentAttributedTitle?.string else { return }
        
        presenter.categoryTapped(title)
    }
    
    // MARK: Vegan Option Button 클릭 시
    @objc func veganOptionButtonTapped(_ sender: VeganOptionButton) {
        presenter.veganOptionButtonTapped(sender)
    }
    
    @objc func menuPlusButtonTapped() {
        presenter.menuPlusButtonTapped()
    }
}

// MARK: TapGestureDelegate
extension EnrollPlaceViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is MenuField || touch.view is UIButton {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

// MARK: TextField가 선택되었을 때 Method
extension EnrollPlaceViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == storeInfoView.titleField {
            let viewController = PlaceListSearchViewController()
            let presenter =
            PlaceListSearchViewPresenter(viewController: viewController)
            viewController.presenter = presenter
            
            navigationController?.pushViewController(viewController, animated: true)
            return false
        } else if textField == storeInfoView.addressField  || textField == storeInfoView.numberField {

            return false
        }
        
        return true
    }
}

extension EnrollPlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return presenter.normalTableCount
        case 1:
            return presenter.requestTableCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            let cell = presenter.normalTableCell(tableView, indexPath)
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = presenter.requestTableCell(tableView, indexPath)
            cell.selectionStyle = .none
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
