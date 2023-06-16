//
//  InrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

final class InrollPlaceViewController: UIViewController {
    
    lazy var presenter = InrollPlacePresenter(viewController: self)
    
    // MARK: scrollView
    var scrollView = UIScrollView()
    
    // MARK: required / optional refer
    var requiredTitleLabel = UILabel()
    var requriedLocationLabel = UILabel()
    var requriedCategoryLabel = UILabel()
    var optionalPhoneLabel = UILabel()
    var requriedDetailLabel = UILabel()
    var requriedMenuLabel = UILabel()
    
    // MARK: store title refer
    var storeTitleExplanation = UILabel()
    var storeTitleField = InrollTextField()
    var storeTitleExplanationStackView = UIStackView()
    var storeTitleStackView = UIStackView()
    
    // MARK: store location refer
    var storeLocationExplanation = UILabel()
    var storeLocationField = InrollTextField()
    var storeLocationExplanationStackView = UIStackView()
    var storeLocationStackView = UIStackView()
    
    // MARK: store category refer
    var storeCategoryExplanation = UILabel()
    var storeCategoryField = InrollTextField()
    var storeCategoryExplanationStackView = UIStackView()
    var storeCategoryStackView = UIStackView()
    
    // MARK: store phone refer
    var storePhoneExplanation = UILabel()
    var storePhoneField = InrollTextField()
    var storePhoneExplanationStackView = UIStackView()
    var storePhoneStackView = UIStackView()
    
    // MARK: vegan detail refer
    var veganDetailExplanation = UILabel()
    var allVegan = SelectVeganButton()
    var someMenuVegan = SelectVeganButton()
    var ifRequestPossibleVegan = SelectVeganButton()
    var veganDetailExplanationStackView = UIStackView()
    var veganButtonStackView = UIStackView()
    var veganDetailStackView = UIStackView()
    
    // MARK: 동적 뷰 layout
    var veganDetailStackViewBottomL: NSLayoutConstraint!
    var tableHeaderViewL: [NSLayoutConstraint]!
    var allAndVeganMenuL: [NSLayoutConstraint]!
    var howToRequestVeganMenuTableViewL: [NSLayoutConstraint]!
    
    var veganTableViewHeightConstraint: NSLayoutConstraint!
    var requestVeganTableViewHeightConstraint: NSLayoutConstraint!
    
    var veganTableHeightPlusValue = 0
    var requestVeganTableHeightPlusValue = 0
    
    // TableView Header View
    var veganMenuExplanation = UILabel()
    var veganMenuExplanationStackView = UIStackView()
    var veganMenuPlusButton = UIButton()
    var veganMenuHeaderStackView = UIStackView()
    
    // ALL 비건을 클릭할 때
    // 비건 메뉴 포함을 클릭할 때
    var veganMenuTableView = UITableView()
    
    // 요청하면 비건을 클릭할 떄
    var howToRequestVeganMenuTableView = UITableView()
    
    var reportStoreButton = ReportButton()
    
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
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("selectedPlace"),
                                                  object: nil
        )
    }
}

extension InrollPlaceViewController: InrollPlaceProtocol {
    // MARK: 전체 Layout
    func makeLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        storeTitleStackViewLayout()
        storeLocationStackViewLayout()
        storeCategoryStackviewLayout()
        storePhoneStackviewLayout()
        veganDetailStackViewLayout()
        veganTableHeaderViewLayout()

        stackViewLayout()
    }
    
    // MARK: 전체 Attribute
    func makeAttribute() {
        // navigation & view 관련
        navigationItem.title = StringValue.InrollView.naviTitle
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainTitle!]
        
        let rightBarButton = UIBarButtonItem(
            title: StringValue.InrollView.naviRightBar,
            style: .plain,
            target: self,
            action: #selector(reportStore)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        view.backgroundColor = .white

        // report button & navigaitonRightBarButton
        reportStoreButton.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false

        requiredAndOptionalAttribute()
        storeTitleReferAttribute()
        storeLocationReferAttribute()
        storeCategoryReferAttribute()
        storePhoneReferAttribute()
        veganDetailReferAttribute()
        veganHeaderViewAttribute()
        
        // report button
        reportStoreButton.setTitle(StringValue.InrollView.reportButton, for: .normal)
        reportStoreButton.addTarget(self,
                                    action: #selector(reportStore),
                                    for: .touchUpInside
        )
        reportStoreButton.layer.cornerRadius = Layout.Button.cornerRadius
        
        reportStoreButton.titleLabel?.font = Layout.Button.font
         
        // Vegan Menu Table View Attribute
        veganMenuTableView.isHidden = true
        
        veganMenuTableView.register(
            VeganMenuTableViewCell.self,
            forCellReuseIdentifier: VeganMenuTableViewCell.identifier
        )
        
        veganMenuTableView.dataSource = self
        veganMenuTableView.tag = 0
        veganMenuTableView.isScrollEnabled = false
        veganMenuTableView.separatorStyle = .none
        veganMenuTableView.backgroundColor = .clear
        
        // How To Request Vegan Menu Table View Attribute
        howToRequestVeganMenuTableView.isHidden = true

        howToRequestVeganMenuTableView.register(
            IfRequestVeganMenuTableViewCell.self,
            forCellReuseIdentifier: IfRequestVeganMenuTableViewCell.identifier
        )
        
        howToRequestVeganMenuTableView.dataSource = self
        howToRequestVeganMenuTableView.tag = 1
        howToRequestVeganMenuTableView.isScrollEnabled = false
        howToRequestVeganMenuTableView.separatorStyle = .none
        howToRequestVeganMenuTableView.backgroundColor = .clear
        
        // TableView Plus Button
        veganMenuPlusButton.addTarget(self,
                                      action: #selector(plusCell),
                                      for: .touchUpInside
        )
    }
    
    // MARK: Make Gesture
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    // MARK: Make Notification Center
    func whenViewWillAppear() {
        // MARK: 검색 후 데이터 불러오기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
        
        // MARK: 키보드 on view 높이 변경
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func whenViewDisappear() {
        // MARK: 키보드 off view 높이 변경
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil
        )
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil
        )
    }
    
    // MARK: ReloadTableView
    func reloadTableView(_ notRequest: Bool) {
        if notRequest {
            veganMenuTableView.reloadData()
        } else {
            howToRequestVeganMenuTableView.reloadData()
        }
    }
}

extension InrollPlaceViewController {
    // MARK: 검색 후 데이터 불러오기 작업
    @objc func selectedPlace(_ notification: Notification) {
        guard let selectedPlace = notification.userInfo?["selectedPlace"] as? PlaceListModel else { return }
        
        presenter.updatePlaceModel(selectedPlace)
        
        storeTitleField.text = selectedPlace.title
        storeLocationField.text = selectedPlace.address
        storeCategoryField.text = selectedPlace.category
        storePhoneField.text = selectedPlace.phone
    }

    // MARK: refreshData
    func refreshData() {
        storeTitleField.text = ""
        storeLocationField.text = ""
        storeCategoryField.text = ""
        storePhoneField.text = ""
        
        allVegan.backgroundColor = .white
        allVegan.layer.borderColor = UIColor.separateLine?.cgColor
        
        someMenuVegan.backgroundColor = .white
        someMenuVegan.layer.borderColor = UIColor.separateLine?.cgColor
        
        ifRequestPossibleVegan.backgroundColor = .white
        ifRequestPossibleVegan.layer.borderColor = UIColor.separateLine?.cgColor
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        reportStoreButton.isEnabled = false
        
        allVegan.setImage(UIImage(named: Image.InrollPageImage.allVeganNoSelected), for: .normal)
        allVegan.setTitleColor(.separateLine, for: .normal)
        
        someMenuVegan.setImage(UIImage(named: Image.InrollPageImage.someMenuVeganNoSelected), for: .normal)
        someMenuVegan.setTitleColor(.separateLine, for: .normal)
        
        ifRequestPossibleVegan.setImage(UIImage(named: Image.InrollPageImage.requestMenuVeganNoSelected), for: .normal)
        ifRequestPossibleVegan.setTitleColor(.separateLine, for: .normal)
        
        updateViewChanges(.offAll)
    }
    
    // MARK: Report 버튼 가능
    func isPossibleReportButton() {
        if presenter.reportButtonPossible() {
            reportStoreButton.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    // MARK: Report 버튼 off
    func isNegativeReportButton() {
        if !presenter.reportButtonPossible() {
            reportStoreButton.isEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: Search Text Field Tap
extension InrollPlaceViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == storeTitleField {
            let viewController = PlaceListViewController()

            navigationController?.pushViewController(viewController, animated: true)
            return true
        }
        
        return true
    }
}

// MARK: 다른곳 클릭할 때 키보드 없애기
extension InrollPlaceViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
    }
}
