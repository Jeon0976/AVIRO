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
    var allVegan = UIButton()
    var someMenuVegan = UIButton()
    var ifRequestPossibleVegan = UIButton()
    var veganDetailExplanationStackView = UIStackView()
    var veganButtonStackView = UIStackView()
    var veganDetailStackView = UIStackView()
        
    // 동적 뷰 layout
    var veganDetailStackViewBottomL: NSLayoutConstraint!
    var tableHeaderViewL: [NSLayoutConstraint]!
    var allAndVeganMenuL: [NSLayoutConstraint]!
    var howToRequestVeganMenuTableViewL: [NSLayoutConstraint]!
    
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
    
    var reportStoreButton = UIButton(configuration: .filled())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
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
        navigationItem.title = "식당 정보"
        let rightBarButton = UIBarButtonItem(
            title: "제보하기",
            style: .plain,
            target: self,
            action: #selector(reportStore)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        view.backgroundColor = .white
        
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
        
        // 초기화면 설정
        veganMenuTableView.isHidden = true
        veganMenuTableView.backgroundColor = .lightGray
        veganMenuTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        howToRequestVeganMenuTableView.isHidden = true
        howToRequestVeganMenuTableView.backgroundColor = .darkGray
        howToRequestVeganMenuTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension InrollPlaceViewController {
    // MARK: Final Report Function
    @objc func reportStore() {
        print("제보!")
        if veganMenuTableView.isHidden == true {
            showMenuTableView()
        } else {
            showHowToRequestVeganMenuTableView()
        }
    }
    
    // MARK: ALL or 비건 메뉴 포함 테이블 동적 보여주기
    func showMenuTableView() {
        veganDetailStackViewBottomL.isActive = false

        tableHeaderViewL.forEach {
            $0.isActive = true
        }
        
        howToRequestVeganMenuTableViewL.forEach {
            $0.isActive = false
        }
        
        allAndVeganMenuL.forEach {
            $0.isActive = true
        }

        veganMenuTableView.alpha = 0
        veganMenuTableView.isHidden = false
        
        veganMenuHeaderStackView.alpha = 0
        veganMenuExplanation.text = "비건 메뉴"
        
        howToRequestVeganMenuTableView.isHidden = true
        
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4) {
            self.veganMenuHeaderStackView.alpha = 1
            self.veganMenuTableView.alpha = 1
        }
    }
    
    // MARK: 요청하면 비건 테이블 동적 보여주기
    func showHowToRequestVeganMenuTableView() {
        veganDetailStackViewBottomL.isActive = false

        tableHeaderViewL.forEach {
            $0.isActive = true
        }

        allAndVeganMenuL.forEach {
            $0.isActive = false
        }
        
        howToRequestVeganMenuTableViewL.forEach {
            $0.isActive = true
        }

        howToRequestVeganMenuTableView.alpha = 0
        howToRequestVeganMenuTableView.isHidden = false
        
        veganMenuHeaderStackView.alpha = 0
        veganMenuExplanation.text = "메뉴 등록하기"
        
        veganMenuTableView.isHidden = true
        
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4) {
            self.veganMenuHeaderStackView.alpha = 1
            self.howToRequestVeganMenuTableView.alpha = 1
        }
    }
}

extension InrollPlaceViewController: UITextFieldDelegate {
    // MARK: Store Location Search Start
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if storeLocationField.text == nil {
            
        }
        
    }
}
