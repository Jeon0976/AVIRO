//
//  EditPlaceInfoPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

protocol EditPlaceInfoProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String
    )
    
}

final class EditPlaceInfoPresenter {
    weak var viewController: EditPlaceInfoProtocol?
    
    private var placeId: String?
    private var placeMarkerModel: MarkerModel?
    private var placeSummary: PlaceSummaryData?
    private var placeInfo: PlaceInfoData?
    
    init(viewController: EditPlaceInfoProtocol,
         placeMarkerModel: MarkerModel? = nil,
         placeId: String? = nil,
         placeSummary: PlaceSummaryData? = nil,
         placeInfo: PlaceInfoData? = nil
    ) {
        self.viewController = viewController
        self.placeMarkerModel = placeMarkerModel
        self.placeId = placeId
        self.placeSummary = placeSummary
        self.placeInfo = placeInfo
    }
    
    func viewDidLoad() {
        print(placeMarkerModel?.marker)
        print("placeId", placeId)
        print("placeInfo", placeInfo)
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func dataBinding() {
        dataBindingLocation()
        dataBindingPhone()
        dataBindingHomepage()
        dataBindingWorkingHours()
    }
    
    private func dataBindingLocation() {
        guard let placeSummary = placeSummary,
              let placeMarkerModel = placeMarkerModel else { return }
        let title = placeSummary.title
        let category = placeSummary.category
        let address = placeSummary.address
        let marker = placeMarkerModel.marker
        
        viewController?.dataBindingLocation(
            title: title,
            category: category,
            marker: marker,
            address: address
        )
    }
    
    private func dataBindingPhone() {
        
    }
    
    private func dataBindingWorkingHours() {
        
    }
    
    private func dataBindingHomepage() {
        
    }
}
