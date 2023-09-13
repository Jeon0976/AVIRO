//
//  EditLocationDTO.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/13.
//

import Foundation

struct AVIROEditLocationDTO: Encodable {
    let placeId: String
    let userId: String
    let nickname: String
    let title: AVIROEditCommonBeforeAfterDTO
    let category: AVIROEditCommonBeforeAfterDTO?
    let address: AVIROEditCommonBeforeAfterDTO?
    let address2: AVIROEditCommonBeforeAfterDTO?
}
