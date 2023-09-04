//
//  EditMenuModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/04.
//

import Foundation

struct EditMenuModel: Encodable {
    let placeId: String
    let userId: String
    let allVegan: Bool
    let someMenuVegan: Bool
    let ifRequestVegan: Bool
    let deleteArray: [String]
    let updateArray: [MenuArray]
    let insertArray: [MenuArray]
}
