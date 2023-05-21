//
//  PlaceListViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import UIKit

final class PlaceListViewController: UIViewController {
    lazy var presenter = PlaceListViewPresenter(viewController: self)
    
    var listTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension PlaceListViewController: PlaceListProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            listTableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
                
        NSLayoutConstraint.activate([
            // listTableView
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.layer.cornerRadius = 8

        // listTableView
        listTableView.backgroundColor = .white.withAlphaComponent(0.1)
        listTableView.dataSource = presenter
        listTableView.delegate = self
        listTableView.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identifier)
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
            presenter.loadData()
        }
    }
    
    // MARK: Item 클릭 될 때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
}
