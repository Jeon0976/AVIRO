//
//  InrollPlaceViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

final class InrollPlaceViewController: UIViewController {
    
    lazy var presenter = InrollPlacePresenter(viewController: self)
    
    // scrollView
    var scrollView = UIScrollView()
    
    // required / optional refer
    var requiredTitleLabel = UILabel()
    var requriedLocationLabel = UILabel()
    var requriedCategoryLabel = UILabel()
    var optionalPhoneLabel = UILabel()
    var requriedDetailLabel = UILabel()
    var requriedMenuLabel = UILabel()
    
    // store title refer
    var storeTitleExplanation = UILabel()
    var storeTitleField = InrollTextField()
    var storeTitleExplanationStackView = UIStackView()
    var storeTitleStackView = UIStackView()
    
    // store location refer
    var storeLocationExplanation = UILabel()
    var storeLocationField = InrollTextField()
    var storeLocationExplanationStackView = UIStackView()
    var storeLocationStackView = UIStackView()
    
    // store category refer
    var storeCategoryExplanation = UILabel()
    var storeCategoryField = InrollTextField()
    var storeCategoryExplanationStackView = UIStackView()
    var storeCategoryStackView = UIStackView()
    
    // store phone refer
    var storePhoneExplanation = UILabel()
    var storePhoneField = InrollTextField()
    var storePhoneExplanationStackView = UIStackView()
    var storePhoneStackView = UIStackView()
    
    // vegan detail refer
    var veganDetailExplanation = UILabel()
    var allVegan = SelectVeganButton()
    var someMenuVegan = SelectVeganButton()
    var ifRequestPossibleVegan = SelectVeganButton()
    var veganDetailExplanationStackView = UIStackView()
    var veganButtonStackView = UIStackView()
    var veganDetailStackView = UIStackView()
    
    // 동적 뷰 layout
    var veganDetailStackViewBottomL: NSLayoutConstraint!
    var tableHeaderViewL: [NSLayoutConstraint]!
    var allAndVeganMenuL: [NSLayoutConstraint]!
    var howToRequestVeganMenuTableViewL: [NSLayoutConstraint]!
    
    var veganTableViewHeightConstraint: NSLayoutConstraint!
    var requestVeganTableViewHeightConstraint: NSLayoutConstraint!
    
    var veganTableHeightPlusValueTotal = 0
    var requestVeganTableHeightPlusValueTotal = 0
    
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
        // MARK: 검색 후 데이터 불러오기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
        
        // 키보드에 따른 view 높이 변경
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 키보드에 따른 view 높이 변경
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("selectedPlace"), object: nil)
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
        navigationItem.title = "가게 제보하기"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainTitle!]
        let rightBarButton = UIBarButtonItem(
            title: "제보하기",
            style: .plain,
            target: self,
            action: #selector(reportStore)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        view.backgroundColor = .white
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        // report button & navigaitonRightBarButton
        reportStoreButton.isEnabled = false
        
        navigationItem.rightBarButtonItem?.isEnabled = false

        // required / optional
        requiredAndOptionalAttribute()
        
        // store title refer
        storeTitleReferAttribute()
        
        // store location refer
        storeLocationReferAttribute()
        
        // store category refer
        storeCategoryReferAttribute()
        
        // store phone refer
        storePhoneReferAttribute()
        
        // vegan detail refer
        veganDetailReferAttribute()
        
        // vegan Header View refer
        veganHeaderViewAttribute()
        
        // report button
        reportStoreButton.setTitle("이 가게 제보하기", for: .normal)
        reportStoreButton.addTarget(self,
                                    action: #selector(reportStore),
                                    for: .touchUpInside
        )
        reportStoreButton.layer.cornerRadius = 28
        
        reportStoreButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        
        veganMenuTableView.isHidden = true
        howToRequestVeganMenuTableView.isHidden = true
        
        veganMenuTableView.register(
            VeganMenuTableViewCell.self,
            forCellReuseIdentifier: VeganMenuTableViewCell.identifier
        )
        
        veganMenuTableView.dataSource = self
        veganMenuTableView.tag = 0
        veganMenuTableView.isScrollEnabled = false
        veganMenuTableView.separatorStyle = .none
        
        howToRequestVeganMenuTableView.register(
            IfRequestVeganMenuTableViewCell.self,
            forCellReuseIdentifier: IfRequestVeganMenuTableViewCell.identifier
        )
        
        howToRequestVeganMenuTableView.dataSource = self
        howToRequestVeganMenuTableView.tag = 1
        howToRequestVeganMenuTableView.isScrollEnabled = false
        howToRequestVeganMenuTableView.separatorStyle = .none
        
        veganMenuPlusButton.addTarget(self, action: #selector(plusCell), for: .touchUpInside)
            
    }
    
    // MARK: ReloadTableView
    func reloadTableView(_ checkTable: Bool) {
        if checkTable {
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
        
        allVegan.setImage(UIImage(named: "올비건No"), for: .normal)
        allVegan.setTitleColor(.separateLine, for: .normal)
        
        someMenuVegan.setImage(UIImage(named: "썸비건No"), for: .normal)
        someMenuVegan.setTitleColor(.separateLine, for: .normal)
        
        ifRequestPossibleVegan.setImage(UIImage(named: "요청비건No"), for: .normal)
        ifRequestPossibleVegan.setTitleColor(.separateLine, for: .normal)
        
        updateViewChanges(.offAll)
    }
    
    // MARK: Report 버튼 작업
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

extension InrollPlaceViewController: UITextFieldDelegate {
    // MARK: Store Location Search Start
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == storeTitleField {
            let viewController = PlaceListViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            return false
        }
        return true
    }
}
