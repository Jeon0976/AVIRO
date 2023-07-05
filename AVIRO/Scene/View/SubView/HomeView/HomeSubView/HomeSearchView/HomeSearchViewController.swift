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
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // placeListTableView
            placeListTableView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 5),
            placeListTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            placeListTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            placeListTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Inset.trailingBottom)
        ])
    }
    
    func makeAttribute() {
        // Navigation, View, TabBar
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        view.backgroundColor = .white
        navigationItem.title = StringValue.HomeSearchView.naviTitle
        
        navigationController?.navigationBar.isHidden = false
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
        
        // searchText
        searchTextField.makeCustomClearButton()
        searchTextField.placeholder = StringValue.HomeSearchView.searchPlaceHolder
        searchTextField.delegate = self
        searchTextField.rightView?.isHidden = true
        
        // placeListTableView
        placeListTableView.delegate = self
        placeListTableView.dataSource = self
        placeListTableView.register(
            PlaceListCell.self,
            forCellReuseIdentifier: PlaceListCell.identifier
        )
        placeListTableView.separatorStyle = .singleLine
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
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceListCell.identifier,
            for: indexPath
        ) as? PlaceListCell

        let mockUp = HomeSearchData(
                icon: "InrollSearchIcon",
                title: "러브얼스",
                address: "주소입니다",
                category: "카테고리입니다",
                distance: "200"
            )

        let title = mockUp.title
        let category = mockUp.category
        let address = mockUp.address
        let distance = mockUp.distance

        let cellData = PlaceListCellModel(
            title: title,
            category: category,
            address: address,
            distance: distance
        )

        cell?.makeCellData(cellData, attributedTitle: nil, attributedAddress: nil)

        cell?.backgroundColor = .white
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: HomeSearchViewTableViewCell.identifier,
//            for: indexPath) as? HomeSearchViewTableViewCell
//
//        let mockUp = HomeSearchData(
//            icon: "InrollSearchIcon",
//            title: "러브얼스",
//            address: "주소입니다",
//            category: "카테고리입니다",
//            distance: "200m"
//        )
//
//        cell?.makeCellData(mockUp)
//
//        cell?.backgroundColor = .white
//        cell?.selectionStyle = .none
//
//        return cell ?? UITableViewCell()
//    }
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
