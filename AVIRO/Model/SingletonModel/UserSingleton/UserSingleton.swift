//
//  UserSingleton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import Foundation

final class UserId {
    static let shared = UserId()
    
    var userId = ""
    var userNickName = ""
    
    private init(userId: String = "test", userNickName: String = "test") {
        self.userId = userId
        self.userNickName = userNickName
    }
}
