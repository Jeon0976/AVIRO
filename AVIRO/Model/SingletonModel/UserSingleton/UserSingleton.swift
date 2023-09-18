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
    var userName = ""
    var userEmail = ""
    var userNickname = ""
    var marketingAgree = 0
    
    private init(
        userId: String = "test",
        userName: String = "",
        userEmail: String = "",
        userNickName: String = "test",
        marketingAgree: Int = 0
    ) {
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.userNickname = userNickName
        self.marketingAgree = marketingAgree
    }
    
    func whenLogin(
        userId: String,
        userName: String,
        userNickname: String,
        marketingAgree: Int
    ) {
        self.userId = userId
        self.userName = userName
        self.userNickname = userNickname
        self.marketingAgree = marketingAgree
    }
    
    func whenLogout() {
        self.userId = ""
        self.userName = ""
        self.userEmail = ""
        self.userNickname = ""
        self.marketingAgree = 0
    }
}
