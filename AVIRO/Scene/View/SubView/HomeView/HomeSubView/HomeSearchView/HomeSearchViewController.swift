//
//  HomeSearchViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

import UIKit

final class HomeSearchViewController: UIViewController {
    lazy var presenter = HomeSearchPresenter(viewController: self)
    
    var searchField = SearchField()
    
    var placeListTableView = UITableView()
    var noHistoryView = NoHistoryView()
                                      
    var historyTableView = UITableView()
    
    var tapGesture = UITapGestureRecognizer()
    
    var searchFieldTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension HomeSearchViewController: HomeSearchProtocol {
    func makeLayout() {
        [
            searchField,
            placeListTableView,
            noHistoryView,
            historyTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        searchFieldTopConstraint = searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        searchFieldTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            // searchTextField
            searchField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // placeListTableView
            placeListTableView.topAnchor.constraint(
                equalTo: searchField.bottomAnchor),
            placeListTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            placeListTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
            placeListTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            
            // noHistoryView
            noHistoryView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            noHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // historyTableView
            historyTableView.topAnchor.constraint(equalTo: searchField.topAnchor, constant: 20),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func makeAttribute() {
        // Navigation, View, TabBar
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        view.backgroundColor = .white
        navigationItem.title = "가게•위치 검색"
        
        navigationController?.navigationBar.isHidden = false
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
        
        // searchText
        searchField.placeholder = StringValue.HomeSearchView.searchPlaceHolder
        searchField.delegate = self
        searchField.rightButtonHidden = true
        searchField.makePlaceHolder("어디로 이동할까요?")
        searchField.didTappedLeftButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // placeListTableView
        placeListTableView.delegate = self
        placeListTableView.dataSource = self
        placeListTableView.register(
            PlaceListCell.self,
            forCellReuseIdentifier: PlaceListCell.identifier
        )
        placeListTableView.separatorStyle = .singleLine
        placeListTableView.isHidden = true
        historyTableView.isHidden = true
    }
}

extension HomeSearchViewController: UITextFieldDelegate {
    // MARK: 검색 시작할 때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.navigationBar.isHidden = true

        searchField.changeLeftButton()
         UIView.animate(withDuration: 0.2) {
             self.searchFieldTopConstraint?.constant = 16
             self.view.layoutIfNeeded()
         }
     }
    
    // MARK: 실시간 검색
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchField.rightButtonHidden = false

        if let text = textField.text {

        }
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
        let address = mockUp.address
        let distance = mockUp.distance

        let cellData = PlaceListCellModel(
            title: title,
            address: address,
            distance: distance
        )

        cell?.makeCellData(cellData, attributedTitle: nil, attributedAddress: nil)

        cell?.backgroundColor = .white
        cell?.selectionStyle = .none

        return cell ?? UITableViewCell()
    }
}

extension HomeSearchViewController: UIGestureRecognizerDelegate {
    // MARK: 외부 클릭 시 키보드 내려가면서, 키보드 취소버튼 사라짐 & 취소버튼 클릭시 text 사라짐
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == searchField.rightView {
            searchField.text = ""
            searchField.rightView?.isHidden = true
              return true
        }

        view.endEditing(true)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
