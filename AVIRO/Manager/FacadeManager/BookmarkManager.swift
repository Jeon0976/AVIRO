//
//  BookmarkManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

protocol BookmarkFacadeProtocol {
    func fetchAllData(completionHandler: @escaping ((String) -> Void))
    func loadAllData() -> [String]
    func checkData(with placeId: String) -> Bool
    func updateData(with placeId: String, completionHandler: @escaping ((String) -> Void))
    func deleteData(with placeId: String, completionHandler: @escaping ((String) -> Void))
    func deleteAllData()
}

final class BookmarkFacadeManager: BookmarkFacadeProtocol {
    private let bookmarkArray: BookmarkDataProtocol
        
    init(bookmarkArray: BookmarkDataProtocol = LocalBookmarkData.shared) {
        self.bookmarkArray = bookmarkArray
    }
    
    func fetchAllData(completionHandler: @escaping ((String) -> Void)) {
        AVIROAPIManager().loadBookmarkModels(with: MyData.my.id) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    let dataArray = success.bookmarks
                    self?.bookmarkArray.updateAllData(with: dataArray)
                } else {
                    if let error = APIError.badRequest.errorDescription {
                        completionHandler(error)
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    completionHandler(error)
                }
            }
        }
    }
    
    func loadAllData() -> [String] {
        bookmarkArray.loadAllData()
    }
    
    func checkData(with placeId: String) -> Bool {
        bookmarkArray.checkData(with: placeId)
    }
    
    func updateData(
        with placeId: String,
        completionHandler: @escaping ((String) -> Void)
    ) {
        self.bookmarkArray.updateData(with: placeId)
        self.updateBookmark(
            with: placeId,
            completionHandler: completionHandler
        )
    }
    
    func deleteData(
        with placeId: String,
        completionHandler: @escaping ((String) -> Void)
    ) {
        self.bookmarkArray.deleteData(with: placeId)
        self.updateBookmark(
            with: placeId,
            completionHandler: completionHandler
        )
    }
    
    private func updateBookmark(with placeId: String, completionHandler: @escaping ((String) -> Void)) {
        let bookmarks = bookmarkArray.loadAllData()
        
        let postModel = AVIROUpdateBookmarkDTO(
            placeList: bookmarks,
            userId: MyData.my.id
        )
        
        AVIROAPIManager().createBookmarkModel(with: postModel) { result in
            switch result {
            case .success(let success):
                if success.statusCode != 200 {
                    if let message = success.message {
                        completionHandler(message)
                    } else {
                        completionHandler("에러 발생")
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    completionHandler(error)
                }
            }
        }
    }

    func deleteAllData() {
        bookmarkArray.deleteAllBookmark()
    }
}
