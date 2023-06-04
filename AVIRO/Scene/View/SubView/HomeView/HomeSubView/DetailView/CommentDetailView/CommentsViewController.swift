//
//  CommentsViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/28.
//

import UIKit

final class CommentsViewController: UIViewController {
    lazy var presenter = CommentDetailPresenter(viewController: self)
        
    var commentsTitle = UILabel()
    var commentsCount = UILabel()
    var commentsTableView = UITableView()
    
    var noCommentLabel1 = UILabel()
    var noCommentLabel2 = UILabel()
    
    var commentTextField = CommentsTextField()
    var commentButton = UIButton()
    
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
        
        // MARK: 키보드에따른 view 높이 변경
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("CommentsViewControllerrDismiss"), object: nil)

    }
    
}

extension CommentsViewController: CommentDetailProtocol {
    func makeLayout() {
        [
            commentsTitle,
            commentsCount,
            commentsTableView,
            commentTextField,
            commentButton,
            noCommentLabel1,
            noCommentLabel2
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // commentsTitle
            commentsTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            commentsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // commentsCount
            commentsCount.leadingAnchor.constraint(equalTo: commentsTitle.trailingAnchor, constant: 4),
            commentsCount.bottomAnchor.constraint(equalTo: commentsTitle.bottomAnchor),
            
            // commentsTableView
            commentsTableView.topAnchor.constraint(equalTo: commentsTitle.bottomAnchor, constant: 20),
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentsTableView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor),
            
            // commentTextField
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // commentButton
            commentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            
            // noCommentLabel1
            noCommentLabel1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCommentLabel1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // noCommentLabel2
            noCommentLabel2.centerXAnchor.constraint(equalTo: noCommentLabel1.centerXAnchor),
            noCommentLabel2.topAnchor.constraint(equalTo: noCommentLabel1.bottomAnchor, constant: 6)
        ])
    }
    
    func makeAttribute() {
        // view & tap
        view.backgroundColor = .white
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // no Comment
        noCommentLabel1.textColor = .mainTitle
        noCommentLabel1.font = .systemFont(ofSize: 18, weight: .bold)
        noCommentLabel1.text = "아직 댓글이 없어요"
        
        noCommentLabel2.textColor = .lightGray
        noCommentLabel2.font = .systemFont(ofSize: 14)
        noCommentLabel2.text = "영광스러운 첫 댓글을 남겨주세요"
        
        // comments Title
        commentsTitle.text = "댓글"
        commentsTitle.textColor = .mainTitle
        commentsTitle.font = .systemFont(ofSize: 20, weight: .bold)
        
        // comments Count
        commentsCount.text = "0개"
        
        // comment TextField
        commentTextField.placeholder = "이 식당에 대한 경험을 적어주세요!"
        commentTextField.delegate = self
        
        // comment button
        commentButton.setTitle("게시", for: .normal)
        commentButton.setTitleColor(.mainTitle, for: .normal)
        commentButton.addTarget(self, action: #selector(tappedCommentButton), for: .touchUpInside)
        
        // comments tableView
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(CommentsViewCell.self,
                                   forCellReuseIdentifier: CommentsViewCell.identifier
        )
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 80.0
        commentsTableView.separatorStyle = .none
    
    }
    
    // MARK: comments 숫자 확인
    func checkComments() {
        let count = presenter.checkComments()
                
        if count != 0 {
            noCommentLabel1.isHidden = true
            noCommentLabel2.isHidden = true
            commentsCount.text = "\(count)개"
            tableViewReload()
        }
    }
    
    // MARK: Reload Tableview
    func tableViewReload() {
        commentsTableView.reloadData()
    }
}

extension CommentsViewController {
    // MARK: Upload Comment
    @objc func tappedCommentButton() {
        guard let comment = commentTextField.text else { return }

        presenter.uploadData(comment)
        commentTextField.text = ""
    }
}

// MARK: 글자수 제한
extension CommentsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 28
    }
}

// MARK: TableVeiw data source
extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter.veganModel?.comment?.count else { return 0 }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentsViewCell.identifier,
            for: indexPath) as? CommentsViewCell
       
        guard let comments = presenter.veganModel?.comment else { return UITableViewCell() }

        let comment = comments[indexPath.row]
        
        cell?.selectionStyle = .none
        
        cell?.makeData(comment.comment)
        
        return cell ?? UITableViewCell()
    }
    
}

// MARK: TableView Delegate
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

extension CommentsViewController: UIGestureRecognizerDelegate {
    // MARK: 외부 클릭 시 키보드 내려가면서, 키보드 취소버튼 사라짐 & 취소버튼 클릭시 text 사라짐
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == commentTextField.rightView {
            commentTextField.text = ""
            commentTextField.rightView?.isHidden = true
              return true
        }

        view.endEditing(true)
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: 키보드 나타남에 따라 view 동적으로 보여주기
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height - tabBarHeight))
                }
            )
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.transform = .identity
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
