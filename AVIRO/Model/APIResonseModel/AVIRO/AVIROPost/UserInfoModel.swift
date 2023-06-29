//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

struct UserInfoModel: Codable {
    let userToken: String
    let userName: String?
    let userEmail: String?
}

struct CheckUser: Codable {
    let statusCode: Int
    let isMember: Bool
}
