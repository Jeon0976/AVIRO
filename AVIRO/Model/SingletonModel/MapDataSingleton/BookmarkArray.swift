//
//  BookmarkSingletion.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/23.
//

import Foundation

final class BookmarkArray {
    static let shared = BookmarkArray()
    
    private var bookmarkList: [String] = []
    
    private init() { }
    
    func updateAllData(_ list: [String]) {
        self.bookmarkList = list
    }
    
    func loadAllData() -> [String] {
        bookmarkList
    }
    
    func checkData(_ placeId: String) -> Bool {
        bookmarkList.contains(placeId)
    }
    
    func updateData(_ placeId: String) {
        if !bookmarkList.contains(placeId) {
            bookmarkList.append(placeId)
        }
    }
    
    func deleteData(_ placeId: String) {
        if let index = bookmarkList.firstIndex(of: placeId) {
            bookmarkList.remove(at: index)
        }
    }
}
