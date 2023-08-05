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
    
    /// API 호출 관련해서 다 입력이 끝나면 발동하도록 하는 변수
    var searchTimer: DispatchWorkItem?

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
        
        // searchField 클릭 시 navigation 위치로 이동시키기 위함
        searchFieldTopConstraint = searchField.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 15
        )
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
    
    // MARK: Attribute
    func makeAttribute() {
        makeViewAndTabAttribute()
        makeSearchFieldAttribute()
        makePlaceListTableAttribute()
        makeHistoryTableAttribute()
        
        historyTableView.isHidden = true
    }
    
    // MARK: How to Show First View
    func howToShowFirstView(_ isShowHistoryTable: Bool) {
        if isShowHistoryTable {
            ShowHistoryTable()
        } else {
            ShowNoHistoryView()
        }
    }
    
    func reloadTableView() {
        placeListTableView.reloadData()
    }
}

extension HomeSearchViewController {
    // MARK: How to Show First View Detail
    private func ShowHistoryTable() {
        historyTableView.isHidden = false
        noHistoryView.isHidden = true
    }
    
    private func ShowNoHistoryView() {
        historyTableView.isHidden = true
        noHistoryView.isHidden = false
    }
    
    // MARK: View and Tab Attribute
    private func makeViewAndTabAttribute() {
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        view.backgroundColor = .gray7
        navigationItem.title = "가게•위치 검색"
        
        navigationController?.navigationBar.isHidden = false
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
    }
    
    // MARK: Search Field Attribute
    private func makeSearchFieldAttribute() {
        searchField.delegate = self
        searchField.rightButtonHidden = true
        searchField.makePlaceHolder("어디로 이동할까요?")
        searchField.didTappedLeftButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Place List Table Attribute
    private func makePlaceListTableAttribute() {
        placeListTableView.delegate = self
        placeListTableView.dataSource = self
        placeListTableView.register(
            HomeSearchViewTableViewCell.self,
            forCellReuseIdentifier: HomeSearchViewTableViewCell.identifier
        )
        placeListTableView.separatorStyle = .none
        placeListTableView.isHidden = true
    }
    
    // MARK: History Table Attribute
    private func makeHistoryTableAttribute() {
        
    }
}

extension HomeSearchViewController: UITextFieldDelegate {
    // MARK: 검색 시작할 때
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.navigationBar.isHidden = true
        
        searchField.changeLeftButton()
         UIView.animate(withDuration: 0.2) {
             self.historyTableView.isHidden = true
             self.noHistoryView.isHidden = true
             self.placeListTableView.isHidden = false
             
             self.searchFieldTopConstraint?.constant = 16
             self.view.layoutIfNeeded()
         }
     }
    
    // MARK: 실시간 검색
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchField.rightButtonHidden = false
        // 중간 배열의 out of index 방지를 위해 & API 요청 횟수를 줄이기 위해 
        
        // 이전 타이머 작업을 취소합니다(있는 경우).
        searchTimer?.cancel()

        // 새로운 타이머 작업을 생성합니다.
        let task = DispatchWorkItem { [weak self] in
            if let text = textField.text {
                self?.presenter.changedColorText = text
                self?.presenter.initialSearchDataAndCompareAVIROData(text)
            }
        }

        // 타이머 작업을 저장합니다.
        searchTimer = task
        
        // 0.5초 후에 작업을 실행합니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: task)
    }
    
}

extension HomeSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.matchedPlaceModelCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeSearchViewTableViewCell.identifier,
            for: indexPath
        ) as? HomeSearchViewTableViewCell

        let data = presenter.matchedPlaceListRow(indexPath.row)

        let title = data.title
        let address = data.address
        let distance = data.distance
        
        var icon: UIImage?
        
        switch (data.allVegan, data.someVegan, data.requestVegan) {
        case (true, _, _):
            icon = UIImage(named: "AllCell")
        case (_, true, _):
            icon = UIImage(named: "SomeCell")
        case (_, _, true):
            icon = UIImage(named: "RequestCell")
        default:
            icon = UIImage(named: "ListCellIcon")
        }
        
        let cellData = MatchedPlaceListCell(
            icon: icon ?? UIImage(named: "ListCellIcon")!,
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

extension HomeSearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // 더 빠른 API 호출을 위한 상수 300
        if offsetY > contentHeight - height {
            let query = searchField.text ?? ""
            presenter.afterPagingSearchAndCompareAVIROData(query)
        }
    }
}

extension HomeSearchViewController: UIGestureRecognizerDelegate {
    // MARK: 키보드 로직
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is SearchField {
            return false
        }

        view.endEditing(true)
        return true
    }
}
