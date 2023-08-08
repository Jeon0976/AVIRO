//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

final class MarkerModelArray {
    static let shared = MarkerModelArray()
    
    private var markers: [MarkerModel] = []
    
    private init() {}
    
    func getData() -> MarkerModel? {
        return markers.last
    }
    
    func setData(_ markerModel: MarkerModel) {
        guard !markers.contains(where: { $0.placeId == markerModel.placeId }) else { return }
        markers.append(markerModel)
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
}
