////
////  CommentsDetailViewController.swift
////  AVIRO
////
////  Created by 전성훈 on 2023/05/28.
////
//
//import UIKit
//
//final class CommentDetailViewController: UIViewController {
//    lazy var presenter = CommentDetailPresenter(viewController: self)
//        
//    var commentsTitle = UILabel()
//    var commentsCount = UILabel()
//    var commentsTableView = UITableView()
//    
//    var noCommentLabel1 = UILabel()
//    var noCommentLabel2 = UILabel()
//    
//    var pushCommentView = PushCommentView()
//    
//    var tapGesture = UITapGestureRecognizer()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        presenter.viewDidLoad()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        presenter.viewWillAppear()
//        
//        // MARK: 키보드에따른 view 높이 변경
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil
//        )
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil
//        )
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        presenter.viewDidDisappear()
//    }
//}
//
//extension CommentDetailViewController: CommentDetailProtocol {
//    func makeLayout() {
//        [
//            commentsTitle,
//            commentsCount,
//            commentsTableView,
//            pushCommentView,
//            noCommentLabel1,
//            noCommentLabel2
//        ].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            // commentsTitle
//            commentsTitle.topAnchor.constraint(
//                equalTo: view.topAnchor, constant: Layout.Inset.leadingTop),
//            commentsTitle.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
//            
//            // commentsCount
//            commentsCount.leadingAnchor.constraint(
//                equalTo: commentsTitle.trailingAnchor, constant: Layout.Inset.leadingTopSmall),
//            commentsCount.bottomAnchor.constraint(
//                equalTo: commentsTitle.bottomAnchor),
//            
//            // commentsTableView
//            commentsTableView.topAnchor.constraint(
//                equalTo: commentsTitle.bottomAnchor, constant: Layout.Inset.leadingTopPlus),
//            commentsTableView.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor, constant: Layout.Inset.leadingTop),
//            commentsTableView.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor, constant: Layout.Inset.trailingBottom),
//            commentsTableView.bottomAnchor.constraint(
//                equalTo: pushCommentView.topAnchor),
//            
//            pushCommentView.leadingAnchor.constraint(
//                equalTo: view.leadingAnchor),
//            pushCommentView.trailingAnchor.constraint(
//                equalTo: view.trailingAnchor),
//            pushCommentView.bottomAnchor.constraint(
//                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.Inset.trailingBottom),
//            
//            // noCommentLabel1
//            noCommentLabel1.centerXAnchor.constraint(
//                equalTo: view.centerXAnchor),
//            noCommentLabel1.centerYAnchor.constraint(
//                equalTo: view.centerYAnchor),
//            
//            // noCommentLabel2
//            noCommentLabel2.centerXAnchor.constraint(
//                equalTo: noCommentLabel1.centerXAnchor),
//            noCommentLabel2.topAnchor.constraint(
//                equalTo: noCommentLabel1.bottomAnchor, constant: Layout.Inset.menuSpacing)
//        ])
//    }
//    
//    func makeAttribute() {
//        // view & tap
//        view.backgroundColor = .white
//        
//        tapGesture.delegate =  self
//        view.addGestureRecognizer(tapGesture)
//
//        // no Comment
//        noCommentLabel1.textColor = .mainTitle
//        noCommentLabel1.font = Layout.Label.mainTitle
//        noCommentLabel1.text = StringValue.DetailView.noCommentInfo
//        
//        noCommentLabel2.textColor = .lightGray
//        noCommentLabel2.font = Layout.Label.noInfoSub
//        noCommentLabel2.text = StringValue.DetailView.noCommentDetail
//        
//        // comments Title
//        commentsTitle.text = StringValue.DetailView.commentInfoTitle
//        commentsTitle.textColor = .mainTitle
//        commentsTitle.font = Layout.Label.commentTitle
//        
//        // comments Count
//        commentsCount.text = "0" + StringValue.DetailView.commentCount
//        commentsCount.font = Layout.Label.menuSubInfo
//        
//        // comments tableView
//        commentsTableView.dataSource = self
//        commentsTableView.delegate = self
//        commentsTableView.register(CommentsViewCell.self,
//                                   forCellReuseIdentifier: CommentsViewCell.identifier
//        )
//        
//        commentsTableView.rowHeight = UITableView.automaticDimension
//        commentsTableView.estimatedRowHeight = 80.0
//        commentsTableView.separatorStyle = .none
//    
//        pushCommentView.textView.delegate = self
//        
//        pushCommentView.button.addTarget(self, action: #selector(reportButtonTap), for: .touchUpInside)
//    }
//    
//    // MARK: comments 숫자 확인
//    func checkComments() {
//        let count = presenter.checkComments()
//                
//        if count != 0 {
//            noCommentLabel1.isHidden = true
//            noCommentLabel2.isHidden = true
//            commentsCount.text = "\(count)" + StringValue.DetailView.commentCount
//            tableViewReload()
//        }
//    }
//    
//    // MARK: Reload Tableview
//    func tableViewReload() {
//        commentsTableView.reloadData()
//    }
//}
//
//extension CommentDetailViewController {
//    // MARK: Upload Comment
//    @objc func reportButtonTap() {
//        if pushCommentView.textView.text != "" {
//            presenter.uploadData(pushCommentView.textView.text)
//            pushCommentView.textView.text = ""
//            pushCommentView.button.setTitleColor(.separateLine, for: .normal)
//        }
//    }
//}
//
//// MARK: TableVeiw data source
//extension CommentDetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.checkComments()
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: CommentsViewCell.identifier,
//            for: indexPath) as? CommentsViewCell
//
//        guard let comment = presenter.commentRow(indexPath) else { return UITableViewCell() }
//
//        cell?.selectionStyle = .none
//
//        cell?.makeData(comment.content)
//
//        return cell ?? UITableViewCell()
//    }
//
//}
//
//// MARK: TableView Delegate
//extension CommentDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.rowHeight
//    }
//}
//
//extension CommentDetailViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .separateLine {
//            textView.textColor = .black
//            textView.text = ""
//        }
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text != "" {
//            pushCommentView.button.setTitleColor(.black, for: .normal)
//        } else {
//            pushCommentView.button.setTitleColor(.separateLine, for: .normal)
//        }
//        
//        let size = CGSize(width: textView.frame.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        
//        if estimatedSize.height <= textView.font!.lineHeight * 5 {
//            textView.isScrollEnabled = false
//
//            textView.constraints.forEach { constraint in
//                if constraint.firstAttribute == .height {
//                    constraint.constant = estimatedSize.height
//                }
//            }
//        } else {
//            textView.isScrollEnabled = true
//        }
//    }
//}
//
//extension CommentDetailViewController: UIGestureRecognizerDelegate {
//    // MARK: 외부 클릭 시 키보드 내려가면서, 키보드 취소버튼 사라짐 & 취소버튼 클릭시 text 사라짐
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view is UITextView {
//            return false
//        }
//        
//        if touch.view is UIButton {
//            return false
//        }
//
//        view.endEditing(true)
//        
//        return true
//    }
//    
//    // MARK: 키보드 나타남에 따라 view 동적으로 보여주기
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//           let keyboardRectangle = keyboardFrame.cgRectValue
//            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
//
//            UIView.animate(
//                withDuration: 0.3,
//                animations: {
//                    self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height - tabBarHeight))
//                }
//            )
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        self.view.transform = .identity
//    }
//}
