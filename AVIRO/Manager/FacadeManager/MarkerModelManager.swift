//
//  MarkerModelManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/19.
//

// TODO: Logout부분 수정
import Foundation

import NMapsMap.NMFMarker
// realm 생성 및 기타 활동을 실행할때는 동일 쓰레드에서 진행해야함
import RealmSwift

protocol MarkerModelManagerProtocol {
    func fetchAllData(completionHandler: @escaping (Result<[AVIROMarkerModel], APIError>) -> Void)
    func updateMarkerModelsWhenViewWillAppear(
        completionHandler: @escaping (Result<MarkerModelResult, APIError>) -> Void
    )
    func setAllMarkerModels(with markers: [MarkerModel])
    func getAllMarkers() -> [NMFMarker]
}

final class MarkerModelManager: MarkerModelManagerProtocol {
    
    private var didLoadOnce: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UDKey.loadOnce.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UDKey.loadOnce.rawValue)
        }
    }
    
    private var updateTime: String {
        get {
            return UserDefaults.standard.string(forKey: UDKey.timeForUpdate.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UDKey.timeForUpdate.rawValue)
        }
    }
    
    func fetchAllData(
        completionHandler: @escaping (Result<[AVIROMarkerModel], APIError>) -> Void
    ) {
        if didLoadOnce {
            fetchAllDataFromRealm(completionHandler: completionHandler)
        } else {
            fetchAllDataFromServer(completionHandler: completionHandler)
        }
    }
    
    private func fetchAllDataFromRealm(
        completionHandler: @escaping (Result<[AVIROMarkerModel], APIError>) -> Void
    ) {
        updateMarkerModelsWhenFetchData { [weak self] result in
            switch result {
            case .success(let model):
                self?.updateTime = TimeUtility.nowDateAndTime()
                completionHandler(.success(model))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func updateMarkerModelsWhenFetchData(
        completionHandler: @escaping (
            Result<[AVIROMarkerModel],
            APIError>
        ) -> Void
    ) {
        let mapModel = AVIROMapModelDTO(
            longitude: "0.0",
            latitude: "0.0",
            wide: "0.0",
            time: updateTime
        )

        AVIROAPIManager().loadNerbyPlaceModels(with: mapModel) { result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    let realm = try! Realm()
                    if let updatePlace = success.data.updatedPlace {
                        for model in updatePlace {
                            let realmModel = MarkerModelFromRealm(
                                placeId: model.placeId,
                                latitude: model.y,
                                longitude: model.x,
                                isAll: model.allVegan,
                                isSome: model.someMenuVegan,
                                isRequest: model.ifRequestVegan
                            )
                            
                            try! realm.write {
                                realm.add(realmModel, update: .modified)
                            }
                        }
                    }
                     
                    if let deletedPlace = success.data.deletedPlace {
                        for placeId in deletedPlace {
                            if let toDeleted = realm.object(
                                ofType: MarkerModelFromRealm.self,
                                forPrimaryKey: placeId) {
                                try! realm.write {
                                    realm.delete(toDeleted)
                                }
                            }
                        }
                    }
                    let updatedDataRaw = realm.objects(MarkerModelFromRealm.self)
                    let updatedDataArray = Array(updatedDataRaw).map { $0.toAVIROMarkerModel() }
                    
                    completionHandler(.success(updatedDataArray))
                } else {
                    completionHandler(.failure(.badRequest))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func fetchAllDataFromServer(
        completionHandler: @escaping (Result<[AVIROMarkerModel], APIError>) -> Void
    ) {
        updateTime = TimeUtility.nowDateAndTime()
        
        let model = AVIROMapModelDTO(longitude: "0.0", latitude: "0.0", wide: "0.0", time: nil)
        
        AVIROAPIManager().loadNerbyPlaceModels(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if let models = success.data.updatedPlace {
                        let realmModels = models.map { model -> MarkerModelFromRealm in
                            return MarkerModelFromRealm(
                                placeId: model.placeId,
                                latitude: model.y,
                                longitude: model.x,
                                isAll: model.allVegan,
                                isSome: model.someMenuVegan,
                                isRequest: model.ifRequestVegan)
                        }
                        
                        let realm = try! Realm()
                        
                        try! realm.write {
                            realm.add(realmModels, update: .modified)
                        }

                        self?.didLoadOnce = true
                        
                        completionHandler(.success(models))
                    }
                } else {
                    completionHandler(.failure(.badRequest))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateMarkerModelsWhenViewWillAppear(
        completionHandler: @escaping (Result<MarkerModelResult, APIError>) -> Void
    ) {
        let mapModel = AVIROMapModelDTO(
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "0.0",
            time: updateTime
        )
        
        AVIROAPIManager().loadNerbyPlaceModels(with: mapModel) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    let realm = try! Realm()
                    var resultModel = MarkerModelResult()
                    
                    if let updatePlace = success.data.updatedPlace {
                        var updatedModels: [AVIROMarkerModel] = []

                        for model in updatePlace {
                            let realmModel = MarkerModelFromRealm(
                                placeId: model.placeId,
                                latitude: model.y,
                                longitude: model.x,
                                isAll: model.allVegan,
                                isSome: model.someMenuVegan,
                                isRequest: model.ifRequestVegan
                            )
                            
                            try! realm.write {
                                realm.add(realmModel, update: .modified)
                            }
                            
                            let markerModel = realmModel.toAVIROMarkerModel()
                            updatedModels.append(markerModel)
                        }
                        resultModel.updated = updatedModels
                    }
                     
                    if let deletedPlace = success.data.deletedPlace {
                        var deletedModels: [String] = []
                        
                        for placeId in deletedPlace {
                            if let toDeleted = realm.object(
                                ofType: MarkerModelFromRealm.self,
                                forPrimaryKey: placeId) {
                                try! realm.write {
                                    realm.delete(toDeleted)
                                }
                                
                                deletedModels.append(placeId)
                            }
                        }
                        
                        resultModel.deleted = deletedModels
                    }
                    self?.updateTime = TimeUtility.nowDateAndTime()
                    completionHandler(.success(resultModel))
                } else {
                    completionHandler(.failure(.badRequest))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func plusMarkerDataInCache(with markerModel: AVIROMarkerModel) {
        
    }
    
    private func deleteMarkerDataInCache(with placeId: String) {
        
    }
    
    func setAllMarkerModels(with markers: [MarkerModel]) {
        MarkerModelCache.shared.setMarkerModel(markers)
    }
    
    func getAllMarkers() -> [NMFMarker] {
        MarkerModelCache.shared.getMarkers()
    }
}
