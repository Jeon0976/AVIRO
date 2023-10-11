//
//  MarkerModelManager.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/09/19.
//

import Foundation

import NMapsMap
// realm 생성 및 기타 활동을 실행할때는 동일 쓰레드에서 진행해야함
import RealmSwift

protocol MarkerModelManagerProtocol {
    func getAllMarkerData() -> [MarkerModel]
    func getMarkerData()
    
}

// TODO: Time Data HomeViewPresenter에서 옮기기
final class MarkerModelManager {
    private var didLoadOnce: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UDKey.loadOnce.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UDKey.loadOnce.rawValue)
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
        let realm = try! Realm()
        let realmResults = realm.objects(MarkerModelFromRealm.self)
        
        let markerModels = Array(realmResults).map {
            $0.toAVIROMarkerModel()
        }
        
        completionHandler(.success(markerModels))
    }
    
    private func fetchAllDataFromServer(
        completionHandler: @escaping (Result<[AVIROMarkerModel], APIError>) -> Void
    ) {
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
}
