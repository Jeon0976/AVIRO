//
//  HomeSearchViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewController: UIViewController {
    lazy var presenter = HomeSearchPresenter(viewController: self)
    
    var searchTextField = InrollTextField()
    var placeListTableView = UITableView()
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
    }
}

extension HomeSearchViewController: HomeSearchProtocol {
    func makeLayout() {
        [
            searchTextField,
            placeListTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // searchTextField
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16),
            
            // placeListTableView
            placeListTableView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 16),
            placeListTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            placeListTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            placeListTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    func makeAttribute() {
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.backgroundColor = .clear
        
        // navigation, view
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.backgroundColor = .white
        navigationItem.title = "검색 결과"
        
        // searchText
        searchTextField.customClearButton()
        searchTextField.placeholder = "가게 이름을 검색해보세요"
        searchTextField.textColor = .black
        searchTextField.delegate = self
        searchTextField.rightView?.isHidden = true
        
        // placeListTableView
        placeListTableView.delegate = self
        placeListTableView.dataSource = self
        placeListTableView.register(
            HomeSearchViewTableViewCell.self,
            forCellReuseIdentifier: HomeSearchViewTableViewCell.identifier
        )
    }
}

extension HomeSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchTextField.rightView?.isHidden = false
        return true
    }
}

extension HomeSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeSearchViewTableViewCell.identifier,
            for: indexPath) as? HomeSearchViewTableViewCell
        
        let mockUp = HomeSearchData(
            icon: "InrollSearchIcon",
            title: "러브얼스",
            address: "주소입니다",
            category: "카테고리입니다",
            distance: "200m"
        )
        
        cell?.makeCellData(mockUp)
        
        cell?.backgroundColor = .white
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension HomeSearchViewController: UIGestureRecognizerDelegate {
    // MARK: 외부 클릭 시 키보드 내려가면서, 키보드 취소버튼 사라짐 & 취소버튼 클릭시 text 사라짐
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == searchTextField.rightView {
            searchTextField.text = ""
            searchTextField.rightView?.isHidden = true
              return true
        }

        view.endEditing(true)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
