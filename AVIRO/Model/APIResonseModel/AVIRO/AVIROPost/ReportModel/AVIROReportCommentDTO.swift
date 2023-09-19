//
//  AVIROReportCommentDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/18.
//

import Foundation

enum AVIROCommentReportType: String, CaseIterable {
    case profanity = "욕설/비방/차별/혐오 후기예요."
    case advertisement = "홍보/영리목적 후기예요."
    case illegalInfo = "불법 정보 후기예요."
    case obscene = "음란/청소년 유해 후기예요."
    case personalInfo = "개인 정보 노출/유포/거래를 한 후기예요."
    case spam = "도배/스팸 후기예요."
    case others = "기타"
    
    var code: Int {
        switch self {
        case .profanity: return 1
        case .advertisement: return 2
        case .illegalInfo: return 3
        case .obscene: return 4
        case .personalInfo: return 5
        case .spam: return 6
        case .others: return 7
        }
    }
}

struct AVIROReportCommentDTO: Encodable {
    let commentId: String
    let userId: String
    let nickname: String
    let code: Int
    let content: String
}

struct AVIROReportID {
    let commentId: String
    let userId: String
    let nickname: String
}
