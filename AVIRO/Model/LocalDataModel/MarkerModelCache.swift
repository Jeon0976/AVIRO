//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

import NMapsMap

// MARK: 아래 함수들 존재 유무 확인 필요
protocol MarkerModelCacheProtocol {
    func getMarkers() -> [NMFMarker]
    func getMarkerModels() -> [MarkerModel]
    func getOnlyStarMarkerModels() -> [MarkerModel]
    func getMarkerFromIndex(_ index: Int) -> MarkerModel?
    func getMarkerFromMarker(_ marker: NMFMarker) -> (MarkerModel?, Int?)
    func setMarkerModel(_ markerModels: [MarkerModel])
    func changeMarkerModel(_ index: Int, _ markerModel: MarkerModel)
    func updateWhenClickedMarker(_ markerModel: MarkerModel)
    func updateWhenStarButton(_ markerModel: [MarkerModel])
    func updateMarkerModel(_ markerModel: MarkerModel)
    func getUpdatedMarkers() -> [NMFMarker]
    func deleteMarkerModel(with placeId: String)
    func deleteAllMarkerModel()
}

final class MarkerModelCache: MarkerModelCacheProtocol {
    static let shared = MarkerModelCache()
    
    private var markers: [MarkerModel] = []
    
    private var updatedMarkers: [NMFMarker] = []
    
    private init() {}
    
    func getMarkers() -> [NMFMarker] {
        var nmfMarkers = [NMFMarker]()
        
        markers.forEach { nmfMarkers.append($0.marker)}
        
        return nmfMarkers
    }
    
    func getMarkerModels() -> [MarkerModel] {
        return markers
    }
    
    func getOnlyStarMarkerModels() -> [MarkerModel] {
        var markers: [MarkerModel] = []
        
        self.markers.forEach {
            if $0.isStar {
                markers.append($0)
            }
        }
        
        return markers
    }
    
    func getMarkerFromIndex(_ index: Int) -> MarkerModel? {
        guard index < markers.count else { return nil }
        
        return markers[index]
    }
    
    func getMarkerFromMarker(_ marker: NMFMarker) -> (MarkerModel?, Int?) {
        if let index = markers.enumerated().first(where: {$0.element.marker == marker})?.offset {
            return (markers[index], index)
        }
        
        return (nil, nil)
    }
    
    func getMarkerWhenSearchAfter(_ afterSearchModel: MatchedPlaceModel
    ) -> (MarkerModel?, Int?) {
        if let index = markers.enumerated()
            .first(where: {
                $0.element.placeId == afterSearchModel.placeId
            })?.offset {
            return (markers[index], index)
        }
        
        return (nil, nil)
    }
    
    func getMarkerWhenEnrollAfter(x: Double, y: Double) -> (MarkerModel?, Int?) {
        let latlng = NMGLatLng(lat: x, lng: y)
        
        if let index = markers.enumerated()
            .first(where: {
                $0.element.marker.position == latlng
            })?.offset {
            return (markers[index], index)
        }

        return (nil, nil)
    }

    func setMarkerModel(_ markerModels: [MarkerModel]) {
        markers = markerModels
        
        for model in markers {
            adjustZPosition(for: model)
        }
    }
    
    func changeMarkerModel(_ index: Int, _ markerModel: MarkerModel) {

        markers[index] = markerModel
    }
    
    func updateWhenClickedMarker(_ markerModel: MarkerModel) {
        if let index = markers.firstIndex(where: { $0.placeId == markerModel.placeId }) {
            markers[index].isClicked = markerModel.isClicked
        }
    }

    func updateWhenStarButton(_ makerModel: [MarkerModel]) {
        makerModel.forEach { model in
            if let index = markers.firstIndex(where: { $0.placeId == model.placeId}) {
                markers[index] = model
            }
        }
    }
    
    func updateMarkerModel(_ markerModel: MarkerModel) {
        if let index = markers.firstIndex(where: { $0.placeId == markerModel.placeId }) {
            
            var updateMarker = markerModel
            
            updateMarker.marker = markers[index].marker
            
            markers[index] = updateMarker
        } else {
            markers.append(markerModel)
            updatedMarkers.append(markerModel.marker)
        }
        
        for model in markers {
            adjustZPosition(for: model)
        }
    }
    
    private func adjustZPosition(for markerModel: MarkerModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let samePositionMarkers = self.markers.filter { $0.marker.position == markerModel.marker.position }
            
            guard samePositionMarkers.count >= 2 else { return }
            
            for (index, model) in samePositionMarkers.enumerated() {
                let changedPositionLat = model.marker.position.lat
                let changedPositionLng = model.marker.position.lng + (Double(index) * 0.0000100)
                
                let latLng = NMGLatLng(lat: changedPositionLat, lng: changedPositionLng)
                
                model.marker.position = latLng
                
            }
        }
    }

    func getUpdatedMarkers() -> [NMFMarker] {
        let markers = updatedMarkers
        
        updatedMarkers.removeAll()
        
        return markers
    }
    
    func deleteMarkerModel(with placeId: String) {
        DispatchQueue.main.async { [weak self] in
            guard let markerModel = self?.markers.first(where: { $0.placeId == placeId })  else { return }
            
            markerModel.marker.mapView = nil
            
            self?.markers.removeAll { $0 == markerModel }
        }
    }

    func deleteAllMarkerModel() {
        markers.forEach {
            $0.marker.mapView = nil
        }
        
        markers.removeAll()
    }
}
