//
//  EditOperationTime.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/13.
//

import Foundation

struct AVIROEditOperationTimeDTO: Encodable {
    let placeId: String
    let userId: String
    let mon: String?
    let monBreak: String?
    let tue: String?
    let tueBreak: String?
    let wed: String?
    let wedBreak: String?
    let thu: String?
    let thuBreak: String?
    let fri: String?
    let friBreak: String?
    let sat: String?
    let satBreak: String?
    let sun: String?
    let sunBreak: String?
}
