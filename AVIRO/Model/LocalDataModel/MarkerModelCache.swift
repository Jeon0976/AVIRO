//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import NMapsMap.NMFMarker

// MARK: 아래 함수들 존재 유무 확인 필요
protocol MarkerModelCacheProtocol {
    func getMarkers() -> [NMFMarker]
    func getMarkerModels() -> [MarkerModel]
    func updateMarkerModelWhenClicked(with markerModel: MarkerModel)
    func getOnlyStarMarkerModels() -> [MarkerModel]
    func getMarker(with marker: NMFMarker) -> (MarkerModel?, Int?)
    func getMarker(with afterSearchModel: MatchedPlaceModel
    ) -> (MarkerModel?, Int?)
    func getMarker(x: Double, y: Double) -> (MarkerModel?, Int?)
    func setMarkerModel(_ markerModels: [MarkerModel])
    func updateMarkerModel(_ index: Int, _ markerModel: MarkerModel)
    func resetAllStarMarkers()
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
    
    // MARK: Set Marker Model
    /// 가공된 데이터로 저장
    func setMarkerModel(_ markerModels: [MarkerModel]) {
        markers = markerModels
        
        for model in markers {
            adjustMarkerCoordinatesWhenOverlapping(for: model)
        }
    }
    
    // MARK: Get Markers
    /// 가공된 데이터에서 Marker 불러오기
    func getMarkers() -> [NMFMarker] {
        var nmfMarkers = [NMFMarker]()
        
        markers.forEach { nmfMarkers.append($0.marker)}
        
        return nmfMarkers
    }
    
    // MARK: Update Marker Model
    /// 앱이 실행 중일때 Marker Model 업데이트 하는 경우 가공된 데이터로 저장
    func updateMarkerModel(_ markerModel: MarkerModel) {
        if let index = markers.firstIndex(where: { $0.placeId == markerModel.placeId }) {
            
            var updateMarker = markerModel
            
            DispatchQueue.main.async { [weak self] in
                self?.markers[index].marker.changeIcon(
                    updateMarker.mapPlace,
                    updateMarker.isClicked
                )
            }
            
            updateMarker.marker = markers[index].marker
            
            markers[index] = updateMarker
        } else {
            markers.append(markerModel)
            updatedMarkers.append(markerModel.marker)
        }
        
        for model in markers {
            adjustMarkerCoordinatesWhenOverlapping(for: model)
        }
    }
    
    private func adjustMarkerCoordinatesWhenOverlapping(for markerModel: MarkerModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let samePositionMarkers = self.markers.filter { $0.marker.position == markerModel.marker.position }
            
            guard samePositionMarkers.count >= 2 else { return }
            
            for (index, model) in samePositionMarkers.enumerated() {
                let changedPositionLat = model.marker.position.lat
                let changedPositionLng = model.marker.position.lng + (Double(index) * 0.0000300)
                
                let latLng = NMGLatLng(lat: changedPositionLat, lng: changedPositionLng)
                
                model.marker.position = latLng
                
            }
        }
    }
    
    func updateMarkerModelWhenClicked(with markerModel: MarkerModel) {
        if let index = markers.firstIndex(where: { $0.placeId == markerModel.placeId}) {
            markers[index].isClicked = markerModel.isClicked
        }
    }
    
    // MARK: DeleteMarkerModel
    /// update간 삭제된 마커데이터 삭제하기
    func deleteMarkerModel(with placeId: String) {
        DispatchQueue.main.async { [weak self] in
            guard let markerModel = self?.markers.first(where: { $0.placeId == placeId })  else { return }
            
            markerModel.marker.mapView = nil
            
            self?.markers.removeAll { $0 == markerModel }
        }
    }
    
    // MARK: Get Updated Markers
    /// 업데이트된 마커모델에서 마커 데이터만 뽑아내기
    func getUpdatedMarkers() -> [NMFMarker] {
        let markers = updatedMarkers
        
        updatedMarkers.removeAll()
        
        return markers
    }
    
    func getMarkerModels() -> [MarkerModel] {
        return markers
    }
    
//    func getMarkerFromIndex(_ index: Int) -> MarkerModel? {
//        guard index < markers.count else { return nil }
//
//        return markers[index]
//    }
    
    // MARK: Marker 불러오기
    /// marker from marker
    func getMarker(with marker: NMFMarker) -> (MarkerModel?, Int?) {
        if let index = markers.enumerated().first(where: {$0.element.marker == marker})?.offset {
            return (markers[index], index)
        }
        
        return (nil, nil)
    }
    
    /// marker from searchModel
    func getMarker(with afterSearchModel: MatchedPlaceModel
    ) -> (MarkerModel?, Int?) {
        if let index = markers.enumerated()
            .first(where: {
                $0.element.placeId == afterSearchModel.placeId
            })?.offset {
            return (markers[index], index)
        }
        
        return (nil, nil)
    }

    /// marker from coordinate
    func getMarker(x: Double, y: Double) -> (MarkerModel?, Int?) {
        let latlng = NMGLatLng(lat: x, lng: y)
        
        if let index = markers.enumerated()
            .first(where: {
                $0.element.marker.position == latlng
            })?.offset {
            return (markers[index], index)
        }

        return (nil, nil)
    }
    
    // MARK: Index를 활용한 마커 직접 변경
    func updateMarkerModel(_ index: Int, _ markerModel: MarkerModel) {

        markers[index] = markerModel
    }
    
    func updateWhenStarButton(_ makerModel: [MarkerModel]) {
        makerModel.forEach { model in
            if let index = markers.firstIndex(where: { $0.placeId == model.placeId}) {
                markers[index].isStar = true
            }
        }
    }
    
    func resetAllStarMarkers() {
        for index in markers.indices where markers[index].isStar {
            markers[index].isStar = false
        }
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
    
    func deleteAllMarkerModel() {
        markers.forEach {
            $0.marker.mapView = nil
        }
        
        markers.removeAll()
    }
}
