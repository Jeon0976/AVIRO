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
    func makeLayout() {
        [
            listTableView
        ].forEach { view.addSubview($0) }
        
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func makeAttribute() {
        listTableView.dataSource = presenter
        listTableView.delegate = self
        listTableView.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identifier)
    }
    
    func reloadTableView() {
        listTableView.reloadData()
    }
}

extension PlaceListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentSize.height
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter.loadData()
        }
    }
}
