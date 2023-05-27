//
//  UserDefaultsManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/26.
//

// MARK: 서버 작업 후 삭제 예정
import Foundation

protocol UserDefaultsManagerProtocol {
    func getData() -> [VeganModel]
    func setData(_ newData: VeganModel)
    func deleteData(_ data: VeganModel)
    func editingData(_ data: VeganModel)
}

struct UserDefalutsManager: UserDefaultsManagerProtocol {
    enum Key: String {
        case vegan
    }
    
    func getData() -> [VeganModel] {
        guard let data = UserDefaults.standard.data(forKey: Key.vegan.rawValue) else { return [] }
        return (try? PropertyListDecoder().decode([VeganModel].self, from: data)) ?? []
    }
    
    func setData(_ newData: VeganModel) {
        var currentDatas: [VeganModel] = getData()
        currentDatas.insert(newData, at: 0)
        currentDatas.sort(by: {
            $0.placeModel.distanceMyLocation < $1.placeModel.distanceMyLocation }
        )
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currentDatas), forKey: Key.vegan.rawValue
        )
    }
    
    func deleteData(_ data: VeganModel) {
        var currentDatas: [VeganModel] = getData()
        
        currentDatas = currentDatas.filter { $0 != data }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currentDatas), forKey: Key.vegan.rawValue
        )
    }
    
    func editingData(_ data: VeganModel) {
        var currentDatas: [VeganModel] = getData()
        
        currentDatas = currentDatas.map { currentData in
            if currentData.placeModel == data.placeModel {
                var newData = currentData
                newData.comment = data.comment
                return newData
            } else {
                return currentData
            }
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(currentDatas), forKey: Key.vegan.rawValue)
    }
}
