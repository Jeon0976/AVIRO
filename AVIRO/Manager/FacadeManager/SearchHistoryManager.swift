//
//  UserDefaultsManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/04.
//

import Foundation

protocol SearchHistoryManagerProtocol {
    func getHistoryModel() -> [HistoryTableModel]
    func setHistoryModel(_ newValues: HistoryTableModel)
    func deleteHistoryModel(_ value: HistoryTableModel)
}

struct SearchHistoryManager: SearchHistoryManagerProtocol {
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
        
        if let existingIndex = currentTable.firstIndex(where: { $0.title == newValues.title }) {
              currentTable.remove(at: existingIndex)
        }
        
        currentTable.insert(newValues, at: 0)
        
        if currentTable.count > 10 {
            currentTable.removeSubrange(10..<currentTable.count)
        }
        
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(currentTable),
            forKey: Key.historyModel.rawValue
        )
    }
    
    // MARK: Data 제거하기
    func deleteHistoryModel(_ value: HistoryTableModel) {
        var currentTable: [HistoryTableModel] = getHistoryModel()
        currentTable = currentTable.filter { $0.id != value.id }
        
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(currentTable),
            forKey: Key.historyModel.rawValue
        )
    }
    
    func deleteHistoryModelAll() {
        let currentTable = [HistoryTableModel]()
        
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(currentTable),
            forKey: Key.historyModel.rawValue)
    }
}
