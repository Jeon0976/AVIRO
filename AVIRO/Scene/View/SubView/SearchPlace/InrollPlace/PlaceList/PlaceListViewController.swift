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
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            // listTableView
            listTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.backgroundColor = .white
        navigationItem.title = "가게 이름 검색"
        
        // listTableView
        listTableView.dataSource = presenter
        listTableView.backgroundColor = .white
        listTableView.delegate = self
        listTableView.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identifier)
        listTableView.separatorStyle = .singleLine
        
        // search Textfield
        
        searchField.placeholder = "가게 이름을 검색해보세요"
        searchField.backgroundColor = .white
        searchField.makeCustomClearButton()
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchField.delegate = self
    }
    
    // MARK: reloadData
    func reloadTableView() {
        listTableView.reloadData()
    }
    
}

extension PlaceListViewController: UITableViewDelegate {
    // MARK: Scroll 될 때 API 요청을 위한 메서드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentSize.height
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            let query = searchField.text ?? ""
            presenter.loadData(query)
        }
    }
    
    // MARK: Item 클릭 될 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: 실시간 검색 함수
extension PlaceListViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            presenter.searchData(text)
        }
    }
}

extension PlaceListViewController: UIGestureRecognizerDelegate {
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

// MARK: 취소 창 없에기
extension PlaceListViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchField.rightView?.isHidden = false
        return true
    }
}
