//
//  BookmarkManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

final class BookmarkFacadeManager {
    private let bookmarkArray = LocalBookmarkData.shared
    
    private var isUpdate = false
    private var isDelete = false
        
    func fetchAllData(completionHandler: @escaping ((String) -> Void)) {
        AVIROAPIManager().loadBookmarkModels(with: MyData.my.id) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    let dataArray = success.bookmarks
                    self?.bookmarkArray.updateAllData(dataArray)
                } else {
                    completionHandler(APIError.badRequest.localizedDescription)
                }
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    func loadAllData() -> [String] {
        bookmarkArray.loadAllData()
    }
    
    func updateBookmark(_ placeId: String, completionHandler: @escaping ((String) -> Void)) {
        let bookmarks = bookmarkArray.loadAllData()
        
        let postModel = AVIROUpdateBookmarkDTO(placeList: bookmarks, userId: MyData.my.id)
        
        AVIROAPIManager().createBookmarkModel(with: postModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let isUpdate = self?.isUpdate,
                       let isDelete = self?.isDelete {
                        if isUpdate {
                            self?.bookmarkArray.updateData(placeId)
                            self?.isUpdate = false
                            return
                        }
                        
                        if isDelete {
                            self?.bookmarkArray.deleteData(placeId)
                            self?.isDelete = false
                            return
                        }
                    }
                } else {
                    if let message = success.message {
                        completionHandler(message)
                    } else {
                        completionHandler("에러 발생")
                    }
                }
            case .failure(let error):
                completionHandler(error.localizedDescription)
            }
        }
    }
    
    func checkData(_ placeId: String) -> Bool {
        bookmarkArray.checkData(placeId)
    }
    
    func updateData(_ placeId: String, completionHandler: @escaping ((String) -> Void)) {
        isUpdate = true
        self.updateBookmark(placeId, completionHandler: completionHandler)
    }
    
    func deleteData(_ placeId: String, completionHandler: @escaping ((String) -> Void)) {
        isDelete = true
        self.updateBookmark(placeId, completionHandler: completionHandler)
    }
}
