//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

struct UserInfoModel: Codable {
    let userIdentifier: String
    let fullName: String?
    let email: String?
}
