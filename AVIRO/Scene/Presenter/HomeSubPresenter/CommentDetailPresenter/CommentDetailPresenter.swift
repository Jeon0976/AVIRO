//
//  CommentDetailPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/28.
//

import UIKit

protocol CommentDetailProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func checkComments()
    func tableViewReload()
}

final class CommentDetailPresenter {
    weak var viewController: CommentDetailProtocol?
        
    var commentItems: [CommentArray]?
        
    init(viewController: CommentDetailProtocol,
         commentItems: [CommentArray]? = nil
    ) {
        self.viewController = viewController
        self.commentItems = commentItems
    }
    
    // MARK: View Did Load
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: View Will Appear
    func viewWillAppear() {
        viewController?.checkComments()
    }
    
    func checkComments() -> Int {
        guard let comments = commentItems else { return 0 }
                
        let count = comments.count
        
        return count
    }
    
    func commentRow(_ indexPath: IndexPath) -> CommentArray? {
        guard let commentItems = commentItems else { return nil }
        
        return commentItems[indexPath.row]
    }
    
    func uploadData(_ comment: String) {
//        let commentData = CommentModel(comment: comment, date: .now)
//
//        guard var comments = veganModel.comment else {
//            let comment = CommentModel(comment: comment, date: .now)
//            veganModel.comment = [comment]
//
//            self.veganModel = veganModel
//            print(veganModel)
//
//            userDefaluts.editingData(veganModel)
//
//            viewController?.checkComments()
//
//            return
//        }
        
//        comments.append(commentData)
//
//        let sortedComments = comments.sorted(by: {$0.date < $1.date})
//
//        veganModel.comment = sortedComments
//
//        self.veganModel = veganModel
//
//        userDefaluts.editingData(veganModel)
//
//        let userInfo: [String: Any] = ["veganModel": veganModel]
//
//        NotificationCenter.default.post(name: Notification.Name("CommentsViewControllerrDismiss"), object: nil, userInfo: userInfo)

        viewController?.checkComments()
    }
}
