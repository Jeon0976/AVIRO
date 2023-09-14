//
//  EditURL+DTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/13.
//

import Foundation

struct AVIROEditURLDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let title: String
    let url: AVIROEditCommonBeforeAfterDTO
}
