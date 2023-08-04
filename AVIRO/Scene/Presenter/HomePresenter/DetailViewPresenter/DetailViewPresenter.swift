//
//  DetailViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

protocol DetailViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func showOthers()
    func bindingData()
    func updateComment(_ model: [CommentArray])
}

final class DetailViewPresenter {
    weak var viewController: DetailViewProtocol?
    
    private let aviroManager = AVIROAPIManager()
    
    var placeId: String?
    
    var placeModel: PlaceData?
    var menuModel: [MenuArray]?
    var commentModel: [CommentArray]?
    
    init(viewController: DetailViewProtocol, placeId: String? = nil) {
        self.viewController = viewController
        self.placeId = placeId
    }
    // MARK: ViewDidLoad()
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.showOthers()
        viewController?.bindingData()
    }
    
    // MARK: Place Info 불러오기
    func loadPlaceInfo(completionHandler: @escaping ((PlaceData) -> Void)) {
        guard let placeId = placeId else { return }
        aviroManager.getPlaceInfo(placeId: placeId
        ) { [weak self] placeModel in
            self?.placeModel = placeModel.data
            DispatchQueue.main.async {
                completionHandler(placeModel.data)
            }
        }
    }
    
    // MARK: Menu Info 불러오기
    func loadMenuInfo(completionHandler: @escaping (([MenuArray]) -> Void)) {
        guard let placeId = placeId else { return }
        aviroManager.getMenuInfo(placeId: placeId
        ) { [weak self] menuModel in
            self?.menuModel = menuModel.data.menuArray
            DispatchQueue.main.async {
                completionHandler(menuModel.data.menuArray)
            }
        }
    }
    
    // MARK: Comment Info 불러오기
    func loadCommentInfo(completionHandler: @escaping (([CommentArray]) -> Void)) {
        guard let placeId = placeId else { return }
        aviroManager.getCommentInfo(placeId: placeId
        ) { [weak self] commentModel in
            self?.commentModel = commentModel.data.commentArray
            DispatchQueue.main.async {
                completionHandler(commentModel.data.commentArray)
            }
        }
    }

    func reloadComment(_ model: [CommentArray]) {
        commentModel = model
        viewController?.updateComment(model)
    }
}
