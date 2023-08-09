//
//  Marker+Extension.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import Foundation

import NMapsMap

extension NMFMarker {
    func makeIcon(_ place: MapPlace) {
        switch place {
        case .All:
            self.iconImage = MapIcon.allMap.image
        case .Some:
            self.iconImage = MapIcon.someMap.image
        case .Request:
            self.iconImage = MapIcon.requestMap.image
        }
    }
    
    func changeIcon(_ place: MapPlace, _ isSelected: Bool) {
        
        switch place {
        case .All:
            self.iconImage = isSelected ? MapIcon.allMapClicked.image : MapIcon.allMap.image
        case .Some:
            self.iconImage = isSelected ? MapIcon.someMapClicked.image : MapIcon.someMap.image
        case .Request:
            self.iconImage = isSelected ? MapIcon.requestMapClicked.image : MapIcon.requestMap.image
        }
    }
}
