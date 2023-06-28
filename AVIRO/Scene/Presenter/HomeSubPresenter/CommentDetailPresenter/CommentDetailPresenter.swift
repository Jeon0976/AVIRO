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
        
    private let aviroAPIManager = AVIROAPIManager()
    
    private var placeId: String?
    private var commentItems: [CommentArray]?
        
    init(viewController: CommentDetailProtocol,
         placeId: String? = nil,
         commentItems: [CommentArray]? = nil
    ) {
        self.viewController = viewController
        self.placeId = placeId
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
    
    func viewDidDisappear() {
        guard let commentItems = commentItems else { return }
        NotificationCenter.default.post(
            name: Notification.Name( "CommentsViewControllerrDismiss"),
            object: nil,
            userInfo: ["comment": commentItems]
        )
    }
    
    func checkComments() -> Int {
        guard let comments = commentItems else { return 0 }
                
        commentItems?.sort(by: {$0.createdTime > $1.createdTime})
        
        let count = comments.count
        
        return count
    }
    
    func commentRow(_ indexPath: IndexPath) -> CommentArray? {
        guard let commentItems = commentItems else { return nil }
        
        return commentItems[indexPath.row]
    }
    
    func uploadData(_ comment: String) {
        guard let placeId = placeId else { return }
        let commentModel = AVIROCommentPost(placeId: placeId, userId: "test", content: comment)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        let commentArrayValue = CommentArray(commentId: commentModel.commentId, userId: commentModel.userId, content: comment, createdTime: dateString)
        
        aviroAPIManager.postCommentModel(commentModel)
        
        commentItems?.append(commentArrayValue)
        
        viewController?.checkComments()
    }
}
