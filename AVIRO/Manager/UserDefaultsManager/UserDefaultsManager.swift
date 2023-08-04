//
//  UserDefaultsManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.
//

import Foundation

// TODO: 제너릭 타입으로 변경 요망
// 일단 구현, 향후 수정 예정
protocol UserDefaultsManagerProtocol {
    func getHistoryModel() -> [HistoryTableModel]
    func setHistoryModel(_ newValues: HistoryTableModel)
    func deleteHistoryModel(_ value: HistoryTableModel)
}

struct UserDefalutsManager: UserDefaultsManagerProtocol {
    enum Key: String {
        case historyModel
    }
    
    // MARK: Data 가져오기
    func getHistoryModel() -> [HistoryTableModel] {
        guard let data = UserDefaults.standard.data(forKey: Key.historyModel.rawValue) else { return [] }
        
        return (try? PropertyListDecoder().decode(
            [HistoryTableModel].self,
            from: data)) ?? []
    }
    
    // MARK: Data 저장하기
    func setHistoryModel(_ newValues: HistoryTableModel) {
        var currentTable: [HistoryTableModel] = getHistoryModel()
        
        currentTable.insert(newValues, at: 0)
        
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(currentTable),
            forKey: Key.historyModel.rawValue
        )
    }
    
    // MARK: Data 제거하기
    func deleteHistoryModel(_ value: HistoryTableModel) {
        var currentTable: [HistoryTableModel] = getHistoryModel()
        currentTable = currentTable.filter { $0.id != value.id}
        
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(currentTable),
            forKey: Key.historyModel.rawValue
        )
    }
}
