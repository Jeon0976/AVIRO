//
//  EditPlaceInfoPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import Foundation

protocol EditPlaceInfoProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
}

final class EditPlaceInfoPresenter {
    weak var viewController: EditPlaceInfoProtocol?
    
    private var placeId: String?
    private var placeSummary: PlaceSummaryData?
    private var placeInfo: PlaceInfoData?
    
    init(viewController: EditPlaceInfoProtocol,
         placeId: String? = nil,
         placeSummary: PlaceSummaryData? = nil,
         placeInfo: PlaceInfoData? = nil
    ) {
        self.viewController = viewController
        self.placeId = placeId
        self.placeSummary = placeSummary
        self.placeInfo = placeInfo
    }
    
    func viewDidLoad() {
        print("placeId", placeId)
        print("placeInfo", placeInfo)
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
}
