//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

import NMapsMap

final class MarkerModelArray {
    static let shared = MarkerModelArray()
    
    private var markers: [MarkerModel] = []
    
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
    
    func getMarkerWhenSearchAfter(_ lng: Double, _ lat: Double) -> (MarkerModel?, Int?) {
        let position = NMGLatLng(lat: lat, lng: lng)
        if let index = markers.enumerated().first(where: { $0.element.marker.position == position })?.offset {
            return (markers[index], index)
        }

        return (nil, nil)
    }
    
    func setData(_ markerModel: MarkerModel) {
        guard !markers.contains(where: { $0.placeId == markerModel.placeId }) else { return }
        markers.append(markerModel)
    }
    
    func change(_ index: Int, _ markerModel: MarkerModel) {
        markers[index] = markerModel
    }
    
    func updateData(_ markerModel: MarkerModel) {
        if let existingIndex = markers.firstIndex(where: { $0.placeId == markerModel.placeId }) {
            // placeId가 일치하는 마커가 이미 존재하는 경우
            
            let existingMarker = markers[existingIndex]
            
            if existingMarker.marker.position.lat != markerModel.marker.position.lat || existingMarker.marker.position.lng != markerModel.marker.position.lng {
                // lat 혹은 lng 값이 다를 경우에만 덮어쓰기
                markers[existingIndex] = markerModel
            }
            
        } else {
            // placeId가 일치하는 마커가 존재하지 않는 경우, 추가
            markers.append(markerModel)
        }
    }
    
    func updateWhenStarButton(_ makerModel: [MarkerModel]) {
        makerModel.forEach { model in
            if let index = markers.firstIndex(where: { $0.placeId == model.placeId}) {
                markers[index] = model
            }
        }
    }
}
