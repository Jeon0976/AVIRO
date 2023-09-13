//
//  EditPhone+DTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/13.
//

import Foundation

struct AVIROEditPhoneDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let phone: AVIROEditCommonBeforeAfterDTO
}
