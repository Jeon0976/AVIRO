//
//  PlaceInfoEditPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

protocol PlaceInfoEditProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class PlaceInfoEditPresenter {
    weak var viewController: PlaceInfoEditProtocol?
    
    private var placeId: String?
    private var placeInfo: PlaceInfoData?
    
    init(viewController: PlaceInfoEditProtocol,
         placeId: String? = nil,
         placeInfo: PlaceInfoData? = nil
    ) {
        self.viewController = viewController
        self.placeId = placeId
        self.placeInfo = placeInfo
    }
    
    func viewDidLoad() {
        print("placeId", placeId)
        print("placeInfo", placeInfo)
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
