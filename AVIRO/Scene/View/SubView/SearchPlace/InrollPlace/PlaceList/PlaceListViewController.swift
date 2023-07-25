//
//  PlaceListViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListViewController: UIViewController {
    lazy var presenter = PlaceListViewPresenter(viewController: self)
    
    var listTableView = UITableView()
    var searchField = InrollTextField()
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension PlaceListViewController: PlaceListProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            searchField,
            listTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
                
        NSLayoutConstraint.activate([
            // searchField
            searchField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Layout.Inset.trailingBottom),
            searchField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Inset.leadingTop),
            
            // listTableView
            listTableView.topAnchor.constraint(
                equalTo: searchField.bottomAnchor, constant: Layout.Inset.tableToField),
            listTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Inset.trailingBottom),
            listTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
            listTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.backgroundColor = .white
        navigationItem.title = StringValue.PlaceListView.naviTitle
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
    
        // listTableView
        listTableView.backgroundColor = .white
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identifier)
        listTableView.separatorStyle = .singleLine
        
        // search Textfield
        
        searchField.placeholder = StringValue.PlaceListView.searchFieldPlaceHolder
        searchField.backgroundColor = .white
//        searchField.makeCustomClearButton()
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchField.delegate = self
    }
    
    // MARK: reloadData
    func reloadTableView() {
        listTableView.reloadData()
    }
    
    // TODO: 검색 결과가 없을 때 Shake 기능 넣기
    func shakeTableView() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shakeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        shakeAnimation.values = [-5.0, 5.0, -5.0, 5.0, -3.0, 3.0, -1.0, 1.0, 0.0 ]
        shakeAnimation.duration = 0.2
        searchField.layer.add(shakeAnimation, forKey: "shake")
    }
}

extension PlaceListViewController: UITableViewDelegate {
    // MARK: Scroll 될 때 API 요청을 위한 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // 더 빠른 API 호출을 위한 상수 300
        if offsetY > contentHeight - height - 300 {
            let query = searchField.text ?? ""
            presenter.loadData(query)
        }
    }
    
    // MARK: Item 클릭 될 때
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRowAt(indexPath)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: TableView DataSource
extension PlaceListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int
    ) -> Int {
        presenter.placeListCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaceListCell.identifier,
            for: indexPath
        ) as? PlaceListCell
        
        let placeList = presenter.placeListRow(indexPath.row)
        
        let title = placeList.title
        let category = placeList.category
        let address = placeList.address
        let distance = placeList.distance
        
        let cellData = PlaceListCellModel(
            title: title,
            category: category,
            address: address,
            distance: distance
        )
  
        let attributedTitle = attributedText(title)
        let attributedAddress = attributedText(address)

        cell?.makeCellData(cellData, attributedTitle: attributedTitle, attributedAddress: attributedAddress)
        
        cell?.backgroundColor = .white
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
    
    // MARK: 색상 변경
    // TODO: Extension String으로 옮김 작업 
    func attributedText(_ text: String) -> NSMutableAttributedString? {
        if let range = text.range(of: presenter.inrolledData ?? "", options: []) {
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.foregroundColor,
                                        value: UIColor.subTitle ?? UIColor.gray,
                                        range: NSRange(range, in: text)
            )
            return attributedText
        }
        return nil
    }
}

// MARK: 실시간 검색 함수
extension PlaceListViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            presenter.inrolledData = text
            presenter.searchData(text)
        }
    }
}

extension PlaceListViewController: UIGestureRecognizerDelegate {
    // MARK: 외부 클릭 시 키보드 내려가면서, 키보드 취소버튼 사라짐 & 취소버튼 클릭시 text 사라짐
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch
    ) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == searchField.rightView {
            searchField.text = ""
            searchField.rightView?.isHidden = true
              return true
        }

        view.endEditing(true)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

// MARK: 취소 창 없에기
extension PlaceListViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchField.rightView?.isHidden = false
        return true
    }
}
