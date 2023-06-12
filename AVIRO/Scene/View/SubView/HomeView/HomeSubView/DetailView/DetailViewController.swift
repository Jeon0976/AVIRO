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
    var menuHeight: CGFloat!
    var commentHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        // MARK: Comment 업데이트 NotificationCenter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDismissNotification),
            name: Notification.Name("CommentsViewControllerrDismiss"),
            object: nil
        )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindingTopDetailView()
        bindingStoreDetail()
        bindingMenuDetail()
        bindingComment()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("CommentsViewControllerrDismiss"),
            object: nil
        )
    }
    
    @objc func handleDismissNotification() {
        guard let data = presenter.veganModel?.comment else { return }
        comment.tableView.reloadData()
        comment.comentCount.text = "\(data.count)개"
    }
}

extension DetailViewController: DetailViewProtocol {
    func makeLayout() {

        bindingTopDetailView()
        bindingStoreDetail()
        bindingMenuDetail()
        bindingComment()
        
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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            topDetail.heightAnchor.constraint(equalTo: topDetail.widthAnchor, constant: -90),

            // storeDetail
            storeDetail.topAnchor.constraint(equalTo: topDetail.bottomAnchor, constant: 16),
            storeDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            storeDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            storeDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            storeDetail.heightAnchor.constraint(equalTo: storeDetail.widthAnchor, constant: -90),

            // menuDetail
            menuDetail.topAnchor.constraint(equalTo: storeDetail.bottomAnchor, constant: 16),
            menuDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            menuDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            menuDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            menuDetail.heightAnchor.constraint(equalToConstant: menuHeight + 20),

            // comment
            comment.topAnchor.constraint(equalTo: menuDetail.bottomAnchor, constant: 16),
            comment.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            comment.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            comment.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            comment.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            comment.heightAnchor.constraint(equalToConstant: commentHeight)
        ])
    }
    
    func makeAttribute() {
        // navigation, view, indicator
        view.backgroundColor = .white
        indicator.color = .separateLine
        indicator.startAnimating()
        indicator.alpha = 1
        navigationItem.title = presenter.veganModel?.placeModel.title
        navigationItem.backButtonDisplayMode = .generic
        
        navigationController?.navigationBar.isHidden = false
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(true)
        }
        
        scrollView.isHidden = true
        scrollView.backgroundColor = .separateLine
        topDetail.backgroundColor = .white
        storeDetail.backgroundColor = .white
        menuDetail.backgroundColor = .white
        comment.backgroundColor = .white
        
        storeDetail.layer.cornerRadius = 16
        menuDetail.layer.cornerRadius = 16
        comment.layer.cornerRadius = 16
        
        comment.commentButton.addTarget(self, action: #selector(pushDetailComment), for: .touchUpInside)
    }
    
    @objc func pushDetailComment() {
        guard let veganModel = presenter.veganModel else { return }
                
        let view = CommentsViewController()
        
        let presenter = CommentDetailPresenter(viewController: view, veganModel: veganModel)
        view.presenter = presenter
        
        present(view, animated: true)
    }
    
    func showOthers() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.indicator.alpha = 0
        }, completion: { [weak self] _ in
            self?.scrollView.isHidden = false
        })
    }
    // MARK: TopDetailView data binding
    private func bindingTopDetailView() {
        guard let veganModel = presenter.veganModel else { return }
        topDetail.title.text = veganModel.placeModel.title
        topDetail.address.text = veganModel.placeModel.address
        
        if veganModel.allVegan {
            topDetail.imageView.image = UIImage(
               named: "HomeInfoVegan")
            topDetail.topImageView.image = UIImage(
               named: "HomeInfoVeganTitle")
        } else if veganModel.someMenuVegan {
            topDetail.imageView.image = UIImage(
               named: "HomeInfoSomeVegan")
            topDetail.topImageView.image = UIImage(
               named: "HomeInfoSomeVeganTItle")
        } else {
            topDetail.imageView.image = UIImage(
               named: "HomeInfoRequestVegan")
            topDetail.topImageView.image = UIImage(
               named: "HomeInfoRequestVeganTitle")
        }
        topDetail.imageView.contentMode = .scaleAspectFit
        topDetail.topImageView.contentMode = .scaleAspectFit
        
        topDetail.layoutIfNeeded()
        
        topDetail.viewHeight = topDetail.frame.size.height

    }
    
    // MARK: StoreDetail data binding
    private func bindingStoreDetail() {
        storeDetail.addressLabel.text = presenter.veganModel?.placeModel.address
        storeDetail.phoneLabel.text = presenter.veganModel?.placeModel.phone ?? ""
        storeDetail.categoryLabel.text = presenter.veganModel?.placeModel.category
    }
    
    // MARK: MenuDetail data binding
    private func bindingMenuDetail() {
        guard let veganModel = presenter.veganModel else {
            menuDetail.showNoData()
            return
        }
        
        var items = [DetailMenuTableModel]()
        
        let notRequestMenu = veganModel.notRequestMenuArray?.filter { $0.menu != "" }
        let requestMenu = veganModel.requestMenuArray?.filter { $0.menu != "" }

        if let notRequestMenu = notRequestMenu {
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
        
        if let requestMenu = requestMenu {
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
        
        menuDetail.showData(items)
        
        let titleHeight = menuDetail.heightOfLabel(label: menuDetail.title)
        
        menuHeight = menuDetail.tableView.contentSize.height + titleHeight + 100
    }
    
    // MARK: CommentDetail data binding
    private func bindingComment() {
        let titleHeight = comment.heightOfLabel(label: comment.title)
        comment.commentButton.layoutIfNeeded()
        let buttonHeight = comment.commentButton.frame.size.height

        guard let veganModel = presenter.veganModel else { return }
                
        guard let comments = veganModel.comment else { 
            commentHeight = titleHeight + buttonHeight + 140
            return
        }
        
        comment.items = comments
        comment.showData()
        
        commentHeight = comment.tableView.contentSize.height + titleHeight + buttonHeight + 60
    }
}
