//
//  EditAddressTableModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/28.
//

import Foundation

struct PublicAddressDTO {
    var totalCount: String?
    var currentPage: String?
    var juso: [Juso]
}

struct Juso {
    var roadAddr: String?
    var jibunAddr: String?
    var zipNo: String?
}
