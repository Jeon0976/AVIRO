//
//  DetailViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

final class DetailViewController: UIViewController {
    lazy var presenter = DetailViewPresenter(viewController: self)
    
    var indicator = UIActivityIndicatorView()
    
    var scrollView = UIScrollView()
    
    var topDetail = TopDetailView()
    var storeDetail = StoreDetailView()
    var menuDetail = MenuDetailView()
    var comment = CommentDetailView()
    
    // 동적 크기
    var menuHeightConstraint: NSLayoutConstraint!
    var menuHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension DetailViewController: DetailViewProtocol {
    func makeLayout() {
        
        bindingTopDetailView()
        bindingStoreDetail()
        bindingMenuDetail()
        
        [
            indicator,
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // indicator
            indicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // scrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        [
            topDetail,
            storeDetail,
            menuDetail,
            comment
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // topDetail
            topDetail.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            topDetail.heightAnchor.constraint(equalTo: topDetail.widthAnchor, constant: -60),

            // storeDetail
            storeDetail.topAnchor.constraint(equalTo: topDetail.bottomAnchor, constant: 16),
            storeDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            storeDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            storeDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            storeDetail.heightAnchor.constraint(equalTo: storeDetail.widthAnchor, constant: -60),

            // menuDetail
            menuDetail.topAnchor.constraint(equalTo: storeDetail.bottomAnchor, constant: 16),
            menuDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            menuDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            menuDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            menuDetail.heightAnchor.constraint(equalToConstant: menuHeight),

            // comment
            comment.topAnchor.constraint(equalTo: menuDetail.bottomAnchor, constant: 16),
            comment.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            comment.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            comment.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            comment.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            comment.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func makeAttribute() {
        // navigation, view, indicator
        view.backgroundColor = .white
        indicator.color = .black
        indicator.startAnimating()
        indicator.alpha = 1
        navigationItem.title = presenter.veganModel?.placeModel.title
        navigationItem.backButtonDisplayMode = .generic
        scrollView.isHidden = true
        scrollView.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        topDetail.backgroundColor = .white
        storeDetail.backgroundColor = .white
        menuDetail.backgroundColor = .white
        comment.backgroundColor = .white
        
        storeDetail.layer.cornerRadius = 16
        menuDetail.layer.cornerRadius = 16
        comment.layer.cornerRadius = 16
        
    }
    
    func showOthers() {
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self?.indicator.alpha = 0
        }, completion: { [weak self] _ in
            self?.scrollView.isHidden = false
        })
    }
    // MARK: TopDetailView data binding
    private func bindingTopDetailView() {
        topDetail.title.text = presenter.veganModel?.placeModel.title
        topDetail.address.text = presenter.veganModel?.placeModel.address
    }
    
    // MARK: StoreDetail data binding
    private func bindingStoreDetail() {
        storeDetail.addressLabel.text = presenter.veganModel?.placeModel.address
        storeDetail.phoneLabel.text = presenter.veganModel?.placeModel.phone ?? ""
        storeDetail.categoryLabel.text = presenter.veganModel?.placeModel.category
    }
    
    // MARK: MenuDetail data binding
    private func bindingMenuDetail() {
        guard let veganModel = presenter.veganModel else { return }
        
        var items = [DetailMenuTableModel]()

        if let notRequestMenu = veganModel.notRequestMenuArray {
            notRequestMenu.forEach {
                let data = DetailMenuTableModel(
                    title: $0.menu,
                    price: $0.price,
                    isVean: "비건",
                    requestMenuVegan: false
                )
                items.append(data)
            }
        }
        if let requestMenu = veganModel.requestMenuArray {
            requestMenu.forEach {
                let data = DetailMenuTableModel(
                    title: $0.menu,
                    price: $0.price,
                    isVean: $0.howToRequest,
                    requestMenuVegan: true
                )
                items.append(data)
            }
        }
                
        menuDetail.items = items
        menuDetail.reloadData()
        
        let titleHeight = menuDetail.heightOfLabel(label: menuDetail.title)
        
        menuHeight = menuDetail.tableView.contentSize.height + titleHeight + 40
    }
    
    // MARK: CommentDetail data binding
}
