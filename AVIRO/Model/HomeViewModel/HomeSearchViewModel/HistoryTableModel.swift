//
//  HistoryTableModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.
//

import Foundation

struct HistoryTableModel: Codable, Hashable {
    var id: UUID = UUID()
    
    let title: String
    let isAll: Bool
    let isSome: Bool
    let isRequest: Bool
}
