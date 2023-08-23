//
//  BookmarkManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

final class BookmarkFacadeManager {
    private let bookmarkArray = BookmarkArray.shared
    
    private let userId = UserId.shared.userId
    
    func fetchAllData() {
        AVIROAPIManager().getBookmarkModels(userId: userId) { [weak self] bookmarkModel in
            let dataArray = bookmarkModel.bookmarks
            self?.bookmarkArray.updateAllData(dataArray)
        }
    }
    
    func loadAllData() -> [String] {
        bookmarkArray.loadAllData()
    }
    
    func updateAllData() {
        let bookmarks = bookmarkArray.loadAllData()
        
        let postModel = BookmarkPostModel(placeList: bookmarks, userId: userId)
        
        // MARK: Error 처리
        AVIROAPIManager().postBookmarkModel(bookmarkModel: postModel) { statusCode in
        }
    }
    
    func checkData(_ placeId: String) -> Bool {
        bookmarkArray.checkData(placeId)
    }
    
    func updateData(_ placeId: String) {
        bookmarkArray.updateData(placeId)
    }
    
    func deleteData(_ placeId: String) {
        bookmarkArray.deleteData(placeId)
    }
}
