//
//  CustomLocationPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit
import CoreLocation

protocol CustomLocationProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func showAddress(_ address: String)
}

final class CustomLocationPresenter: NSObject {
    weak var viewController: CustomLocationProtocol?
    
    private let requestManager = KakaoMapRequestManager()
        
    init(viewController: CustomLocationProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: 주소 정보 호출
    func searchCoodinate(_ longitude: String, _ latitude: String) {
        requestManager.kakaoMapCoordinateSearch(longtitude: longitude,
                                                latitude: latitude) { [weak self] model in
            let placeAddress = model.documents.map { return CustomLocationCellModel(address: $0.address.address) }
            
            guard let address = placeAddress.first?.address else { return }
            
            DispatchQueue.main.async {
                self?.viewController?.showAddress(address)
            }
        }
    }
}
