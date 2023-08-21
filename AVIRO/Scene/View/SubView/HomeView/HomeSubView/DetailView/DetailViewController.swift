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
    
    // MARK: ViewDidLoad
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
}

extension DetailViewController: DetailViewProtocol {
    // MARK: Make Layout
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
            indicator.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            indicator.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            indicator.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            indicator.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // scrollView
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
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
            topDetail.topAnchor.constraint(
                equalTo: scrollView.topAnchor),
            topDetail.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor),
            topDetail.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor),
            topDetail.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor),
            
            // storeDetail
            storeDetail.topAnchor.constraint(
                equalTo: topDetail.bottomAnchor, constant: Layout.Inset.leadingTop),
            storeDetail.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor, constant: Layout.Inset.leadingTop),
            storeDetail.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            storeDetail.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor, constant: Layout.Inset.trailingBottomDouble),

            // menuDetail
            menuDetail.topAnchor.constraint(
                equalTo: storeDetail.bottomAnchor, constant: Layout.Inset.leadingTop),
            menuDetail.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor, constant: Layout.Inset.leadingTop),
            menuDetail.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            menuDetail.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor, constant: Layout.Inset.trailingBottomDouble),

            // comment
            comment.topAnchor.constraint(
                equalTo: menuDetail.bottomAnchor, constant: Layout.Inset.leadingTop),
            comment.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor, constant: Layout.Inset.leadingTop),
            comment.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            comment.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor, constant: Layout.Inset.trailingBottomPlus),
            comment.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor, constant: Layout.Inset.trailingBottomDouble)
        ])
    }
    
    // MARK: Make Attribute
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
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
        
        // 최초 scrollView Hidden
        scrollView.isHidden = true
        scrollView.backgroundColor = .separateLine
        topDetail.backgroundColor = .white
        storeDetail.backgroundColor = .white
        menuDetail.backgroundColor = .white
        comment.backgroundColor = .white
        
        storeDetail.layer.cornerRadius = Layout.DetailView.viewCornerRadius
        menuDetail.layer.cornerRadius = Layout.DetailView.viewCornerRadius
        comment.layer.cornerRadius = Layout.DetailView.viewCornerRadius
        
        comment.commentButton.addTarget(
            self,
            action: #selector(pushDetailComment),
            for: .touchUpInside
        )
    }
    
    // MARK: 최초 Indicator 작동 후 ScrollView 보여짐
    func showOthers() {
        UIView.animate(withDuration: 0.7, animations: { [weak self] in
            self?.indicator.alpha = 0
        }, completion: { [weak self] _ in
            self?.scrollView.isHidden = false
        })
    }
    
    // MARK: Data Binding
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
    
    // MARK: TopDetailView data binding
    private func bindingTopDetailView(_ placeModel: PlaceInfoData) {
//        topDetail.title.text = placeModel.title
//        topDetail.address.text = placeModel.address
//
//        if placeModel.allVegan {
//            topDetail.imageView.image = UIImage(
//                named: Image.homeInfoVegan
//            )
//            topDetail.topImageView.image = UIImage(
//                named: Image.homeInfoVeganTitle
//            )
//        } else if placeModel.someMenuVegan {
//            topDetail.imageView.image = UIImage(
//                named: Image.homeInfoSomeVegan
//            )
//            topDetail.topImageView.image = UIImage(
//                named: Image.homeInfoSomeVeganTitle
//            )
//        } else {
//            topDetail.imageView.image = UIImage(
//                named: Image.homeInfoRequestVegan
//            )
//            topDetail.topImageView.image = UIImage(
//                named: Image.homeInfoRequestVeganTitle
//            )
//        }
    }
    
    // MARK: StoreDetail data binding
    private func bindingStoreDetail(_ placeModel: PlaceInfoData) {
//        storeDetail.addressLabel.text = placeModel.address
//        storeDetail.phoneLabel.text = placeModel.phone == "" ? StringValue.DetailView.noInfo : placeModel.phone
//        storeDetail.phoneLabel.textColor = placeModel.phone == "" ? .separateLine : .mainTitle
//         storeDetail.categoryLabel.text = placeModel.category
    }
    
    // MARK: MenuDetail data binding
    private func bindingMenuDetail(_ menuModel: [MenuArray]) {
        var menuModel = menuModel
        // 비건 > not 비건 순으로 정렬하되, 가격이 낮은 순
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
    
    // MARK: CommentDetailView Dismiss 될 때
    // comment data update
    @objc func handleDismissNotification(_ notification: Notification) {
        if let commnet = notification.userInfo?["comment"] as? [CommentArray] {
            presenter.reloadComment(commnet)
        }
    }
    
    // MARK: UpdateComment
    func updateComment(_ model: [CommentArray]) {
        comment.commentCount.text = "\(model.count)개"
        comment.bindingCommentData(model)
    }
    
    // MARK: Push Comment Detail View
    @objc func pushDetailComment() {

        let viewController = CommentDetailViewController()
        let presenter = CommentDetailPresenter(
            viewController: viewController,
            placeId: presenter.placeId,
            commentItems: presenter.commentModel
        )

        viewController.presenter = presenter

        present(viewController, animated: true)
    }
    
}
