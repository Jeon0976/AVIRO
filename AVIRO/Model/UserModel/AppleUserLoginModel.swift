//
//  AppleUserLoginModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/10/01.
//

import Foundation

struct AppleUserLoginModel {
    let identityToken: String
    let authorizationCode: String
    let userName: String?
    let userEmail: String?
}
