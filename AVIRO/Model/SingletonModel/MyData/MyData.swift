//
//  UserSingleton.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/22.
//

import Foundation

protocol MyDataProtocol {
    func whenLogin(
        userId: String,
        userName: String,
        userEmail: String,
        userNickname: String,
        marketingAgree: Int
    )
    func whenLogout()
}

final class MyData: MyDataProtocol {
    static let my = MyData()
    
    var id = ""
    var name = ""
    var email = ""
    var nickname = ""
    var marketingAgree = 0
    
    private init(
        userId: String = "",
        userName: String = "",
        userEmail: String = "",
        userNickName: String = "",
        marketingAgree: Int = 0
    ) {
        self.id = userId
        self.name = userName
        self.email = userEmail
        self.nickname = userNickName
        self.marketingAgree = marketingAgree
    }
    
    func whenLogin(
        userId: String,
        userName: String,
        userEmail: String,
        userNickname: String,
        marketingAgree: Int
    ) {
        self.id = userId
        self.name = userName
        self.email = userEmail
        self.nickname = userNickname
        self.marketingAgree = marketingAgree
        
        AmplitudeUtility.login()
    }
    
    func whenLogout() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.nickname = ""
        self.marketingAgree = 0
    }
}
