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
//
//    deinit {
//        NotificationCenter.default.removeObserver(
//            self,
//            name: Notification.Name("CommentsViewControllerrDismiss"),
//            object: nil
//        )
//    }
    
    @objc func handleDismissNotification(_ notification: Notification) {
        if let commnet = notification.userInfo?["comment"] as? [CommentArray] {
            presenter.reloadComment(commnet)
        }
    }
}

extension DetailViewController: DetailViewProtocol {
    func bindingData() {
        presenter.loadPlaceInfo { [weak self] in
            self?.bindingTopDetailView($0)
            self?.bindingStoreDetail($0)
        }
        
        presenter.loadMenuInfo { [weak self] in
            self?.bindingMenuDetail($0)
        }
        
        presenter.loadCommentInfo { [weak self] in
            self?.bindingComment($0)
        }
    }
    
    func makeLayout() {
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
            
            // storeDetail
            storeDetail.topAnchor.constraint(equalTo: topDetail.bottomAnchor, constant: 16),
            storeDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            storeDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            storeDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            // menuDetail
            menuDetail.topAnchor.constraint(equalTo: storeDetail.bottomAnchor, constant: 16),
            menuDetail.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            menuDetail.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            menuDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            // comment
            comment.topAnchor.constraint(equalTo: menuDetail.bottomAnchor, constant: 16),
            comment.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            comment.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            comment.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            comment.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    func makeAttribute() {
        // navigation, view, indicator
        view.backgroundColor = .white
        indicator.color = .separateLine
        indicator.startAnimating()
        indicator.alpha = 1
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

        let viewController = CommentDetailViewController()
        let presenter = CommentDetailPresenter(viewController: viewController,
                                               placeId: presenter.placeId,
                                               commentItems: presenter.commentModel
        )
        viewController.presenter = presenter

        present(viewController, animated: true)
    }
    
    func showOthers() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.indicator.alpha = 0
        }, completion: { [weak self] _ in
            self?.scrollView.isHidden = false
        })
    }
    
    // MARK: UpdateComment
    func updateComment(_ model: [CommentArray]) {
        comment.commentCount.text = "\(model.count)개"
        comment.bindingCommentData(model)
    }
    
    // MARK: TopDetailView data binding
    private func bindingTopDetailView(_ placeModel: PlaceData) {
        topDetail.title.text = placeModel.title
        topDetail.address.text = placeModel.address
        
        if placeModel.allVegan {
            topDetail.imageView.image = UIImage(
               named: "HomeInfoVegan")
            topDetail.topImageView.image = UIImage(
               named: "HomeInfoVeganTitle")
        } else if placeModel.someMenuVegan {
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
    }
    
    // MARK: StoreDetail data binding
    private func bindingStoreDetail(_ placeModel: PlaceData) {
        storeDetail.addressLabel.text = placeModel.address
        storeDetail.phoneLabel.text = placeModel.phone ?? "정보가 없습니다."
        storeDetail.categoryLabel.text = placeModel.category
    }
    
    // MARK: MenuDetail data binding
    private func bindingMenuDetail(_ menuModel: [MenuArray]) {
        var menuModel = menuModel
        menuModel.sort { (menu1, menu2) -> Bool in
            if menu1.menuType == MenuType.vegan.rawValue && menu2.menuType == MenuType.needToRequset.rawValue {
                return true
            } else if menu1.menuType == MenuType.needToRequset.rawValue && menu2.menuType == MenuType.vegan.rawValue {
                    return false
            } else {
                return menu1.price < menu2.price
            }
        }
        
        menuDetail.bindingMenuData(menuModel)
    }
    
    // MARK: CommentDetail data binding
    private func bindingComment(_ commentModel: [CommentArray]) {
        let sortedData = commentModel.sorted(by: { $0.createdTime > $1.createdTime})
        
        comment.bindingCommentData(sortedData)
    }
}
