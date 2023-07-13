//
//  UserInfoModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/06/29.
//

import Foundation

// MARK: Gender 확인
enum Gender: String, Codable {
    case female
    case male
    case other
}

// MARK: 유저 정보 input
struct UserInfoModel: Codable {
    var userToken: String
    var userName: String?
    var userEmail: String?
    var nickname: String?
    var birthYear: Int
    var gender: String?
    var marketingAgree: Bool
}

// MARK: 유저 정보 output
struct UserInrollResponse: Codable {
    let statusCode: Int
    let message: String?
}

// MARK: 유저 확인 Input
struct UserCheckInput: Encodable {
    let userToken: String
}

// MARK: 유저 확인 output
struct CheckUser: Codable {
    let statusCode: Int
    let isMember: Bool
    let message: String?
}

// MARK: 닉네임 중복 확인 Input
struct NicnameCheckInput: Encodable {
    let nickname: String?
}

// MARK: 닉네임 중복 확인 Output
struct NicnameCheck: Codable {
    let statusCode: Int
    let isValid: Bool
    let message: String
}

// MARK: 유저 탈퇴 Input
struct UserWidthdrawInput: Encodable {
    let userToken: String
}

// MARK: 유저 탈퇴 Output
struct UserWithdraw: Codable {
    let statusCode: Int
    let message: String
}
