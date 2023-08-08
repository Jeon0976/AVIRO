//
//  MarkerModel.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/08.
//

import UIKit

final class MarkerModelArray {
    static let shared = MarkerModelArray()
    
    var markers = [MarkerModel]()
    
    private init(markers: [MarkerModel] = [MarkerModel]()) {
        self.markers = markers
    }
    
}
