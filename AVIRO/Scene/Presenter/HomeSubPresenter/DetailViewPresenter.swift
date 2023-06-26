//
//  DetailViewPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/27.
//

import UIKit

protocol DetailViewProtocol: NSObject {
    func bindingData()
    func makeLayout()
    func makeAttribute()
    func showOthers()
    func updateComment(_ model: VeganModel?)
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
            self?.menuModel = menuModel.data
            DispatchQueue.main.async {
                completionHandler(menuModel.data)
            }
        }
    }
    
    // MARK: Comment Info 불러오기
    func loadCommentInfo(completionHandler: @escaping (([CommentArray]) -> Void)) {
        guard let placeId = placeId else { return }
        aviroManager.getCommentInfo(placeId: placeId
        ) { [weak self] commentModel in
            self?.commentModel = commentModel.data
            DispatchQueue.main.async {
                completionHandler(commentModel.data)
            }
        }
    }
//
//    func reloadVeganModel(_ model: VeganModel) {
//        veganModel = model
//        viewController?.updateComment(veganModel)
//    }
}
