//
//  PageEndingCheck.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/21.
//

import Foundation

// PageEnd Check SingleTon
final class PageEndingCheck {
    static let shared = PageEndingCheck()
    
    var isend: Bool?
    
    private init(isend: Bool? = nil) {
        self.isend = isend
    }
}
