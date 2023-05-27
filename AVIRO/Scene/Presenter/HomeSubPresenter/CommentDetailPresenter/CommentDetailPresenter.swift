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
    
    private let userDefaluts: UserDefaultsManagerProtocol
    
    var veganModel: VeganModel?
        
    init(viewController: CommentDetailProtocol,
         userDefaults: UserDefaultsManagerProtocol = UserDefalutsManager(),
         veganModel: VeganModel? = nil
    ) {
        self.viewController = viewController
        self.userDefaluts = userDefaults
        self.veganModel = veganModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func viewWillAppear() {
        viewController?.checkComments()
    }
    
    func checkComments() -> Int {
        guard let veganModel = veganModel else { return 0 }
        
        guard let comments = veganModel.comment else { return 0 }
                
        let count = comments.count
        
        return count
    }
    
    func uploadData(_ comment: String) {
        guard var veganModel = veganModel else { return }
        
        let commentData = CommentModel(comment: comment, date: .now)
        
        guard var comments = veganModel.comment else {
            let comment = CommentModel(comment: comment, date: .now)
            veganModel.comment = [comment]
            
            self.veganModel = veganModel
            print(veganModel)
            
            userDefaluts.editingData(veganModel)
            
            viewController?.checkComments()
            
            return
        }
        
        comments.append(commentData)
        
        let sortedComments = comments.sorted(by: {$0.date < $1.date})
        
        veganModel.comment = sortedComments
        
        self.veganModel = veganModel

        userDefaluts.editingData(veganModel)
                
        viewController?.checkComments()
    }
}
