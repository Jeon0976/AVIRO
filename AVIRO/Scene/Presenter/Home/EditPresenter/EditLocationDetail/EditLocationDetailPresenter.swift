//
//  EditLocationDetailPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

protocol EditLocationDetailProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func dataBindingMap(_ marker: NMFMarker)
}

final class EditLocationDetailPresenter {
    weak var viewController: EditLocationDetailProtocol?
    
    private var placeMarkerModel: MarkerModel?

    init(viewController: EditLocationDetailProtocol,
         placeMarkerModel: MarkerModel? = nil
    ) {
        self.viewController = viewController
        self.placeMarkerModel = placeMarkerModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    func viewWillAppear() {
        dataBinding()
    }
    
    func dataBinding() {
        dataBindingMap()
    }
    
    private func dataBindingMap() {
        guard let placeMarkerModel = placeMarkerModel else { return }
        
        let marker = placeMarkerModel.marker
        
        viewController?.dataBindingMap(marker)
    }
}
