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
    
    lazy var storeInfoView = StoreInfoView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 200))
    lazy var veganDetailView = VeganDetailView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 200))
    lazy var menuTableView = MenuTableView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: 200))
    
    var tapGesture = UITapGestureRecognizer()
    
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
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
            
            // menuTableView
            menuTableView.topAnchor.constraint(equalTo: veganDetailView.bottomAnchor, constant: 15),
            menuTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -15),
            menuTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            menuTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            menuTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
    }
    
    // MARK: Attribute
    func makeAttribute() {
        viewAttributed()
        navigationAttributed()
        tabBarAttributed()
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
    }
    
    // MARK: After Search
    func updatePlaceInfo(_ storeInfo: PlaceListModel) {
        storeInfoView.titleField.text = storeInfo.title
        storeInfoView.addressField.text = storeInfo.address
        storeInfoView.numberField.text = storeInfo.phone
        
        storeInfoView.expandStoreInformation()
    }
    
    // MARK: All Vegan 클릭 시
    func allVeganTapped() {
        veganDetailView.allVeganButton.isSelected.toggle()
        
        if veganDetailView.allVeganButton.isSelected {
            presenter.isPresentingDefaultTable = true 
            veganDetailView.someVeganButton.isSelected = false
            veganDetailView.requestVeganButton.isSelected = false
            changeMenuTable(presenter.isPresentingDefaultTable)
        }
    }
    
    // MARK: Some Vegan 클릭 시
    func someVeganTapped() {
        veganDetailView.someVeganButton.isSelected.toggle()
        
        if veganDetailView.someVeganButton.isSelected {
            veganDetailView.allVeganButton.isSelected = false
            changeMenuTable(presenter.isPresentingDefaultTable)
        } else {

        }
    }
    
    // MARK: Request Vegan 클릭 시
    func requestVeganTapped() {
        veganDetailView.requestVeganButton.isSelected.toggle()
        
        if veganDetailView.requestVeganButton.isSelected {
            presenter.isPresentingDefaultTable = false
            veganDetailView.allVeganButton.isSelected = false
            changeMenuTable(presenter.isPresentingDefaultTable)
        } else {
            presenter.isPresentingDefaultTable = true
            changeMenuTable(presenter.isPresentingDefaultTable)
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
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate( withDuration: 0.3, animations: {
                    self.view.transform = CGAffineTransform(
                        translationX: 0,
                        y: -(keyboardRectangle.height - 50)
                    )
                }
            )
        }
    }
    
    // MARK: Keyboard Will Hide
    func keyboardWillHide() {
        self.view.transform = .identity
    }
}

// MARK: Private Method
extension InrollPlaceViewController2 {
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
        navigationItem.backButtonTitle = ""
        navigationItem.title = "가게 등록하기"
        navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(title: "등록하기", style: .plain, target: self, action: #selector(reportStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // TODO: 백버튼 커스텀 할때 수정
        let leftBarButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backToMain))
        
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
        view.layoutIfNeeded()
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
extension InrollPlaceViewController2: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // TODO: touch가 menu text field일 때만 flase
        if touch.view is MenuField || touch.view is UIButton {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}

// MARK: TextField가 선택되었을 때 Method
extension InrollPlaceViewController2: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == storeInfoView.titleField {
            let viewController = PlaceListViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            return false
        } else if textField == storeInfoView.addressField  || textField == storeInfoView.numberField {
            return false
        }
        
        return true
    }
}

extension InrollPlaceViewController2: UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NormalTableViewCell.identifier,
                for: indexPath
            ) as? NormalTableViewCell
            
            let data = presenter.normalTableData(indexPath)
            
            cell?.setData(menu: data.menu,
                          price: data.price
            )
            
            cell?.selectionStyle = .none
            cell?.priceField.buttonDelegate = self
            
            // TODO: Data 연동 처리
            // presenter에 indexPath줘서 그거 맞춰서 data binding
            cell?.editingMenuField = { [weak self] data in
                
            }
            
            cell?.editingPriceField = { [weak self] data in

            }
            
            cell?.priceField.variblePriceChanged = { [weak self] data in

            }
            
            cell?.onMinusButtonTapped = { [weak self] in
                
            }
            
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RequestTableViewCell.identifier,
                for: indexPath
            ) as? RequestTableViewCell
            
            let data = presenter.requestTableData(indexPath)
            
            cell?.setData(menu: data.menu,
                          price: data.price,
                          request: data.howToRequest,
                          isSelected: data.isCheck
            )
            
            cell?.selectionStyle = .none
            cell?.priceField.buttonDelegate = self
            
            // TODO: Data 연동 처리
            cell?.editingMenuField = { [weak self] data in

            }
            
            cell?.editingPriceField = { [weak self] data in

            }
            
            cell?.priceField.variblePriceChanged = { [weak self] data in

            }
            
            cell?.editingRequestField = { [weak self] data in
                
            }
            
            cell?.onRequestButtonTapped = { [weak self] data in

            }
            
            cell?.onMinusButtonTapped = { [weak self] in

            }

            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

extension InrollPlaceViewController2: MenuFieldDelegate {
    func menuFieldDIdTapDotsButton(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
}
