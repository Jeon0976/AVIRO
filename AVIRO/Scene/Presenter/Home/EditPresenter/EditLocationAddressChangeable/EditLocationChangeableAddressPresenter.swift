//
//  EditLocationDetailPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

protocol EditLocationChangebleAddressProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func dataBindingMap(_ marker: NMFMarker)
    func afterChangedAddressWhenMapView(_ address: String)
    func afterResultShowTable(with totalCount: Int)
    func popViewController()
}

final class EditLocationChangeableAddressPresenter {
    weak var viewController: EditLocationChangebleAddressProtocol?
    
    private var addressModels = [Juso]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let count = self?.totalCount else { return }
                self?.viewController?.afterResultShowTable(with: count)
            }
        }
    }
    var changedColorText = ""
    private var totalCount = 0
    private var pageIndex = 1
    
    private var placeMarkerModel: MarkerModel?
    
    private var changedAddress: String?
        
    var afterChangedAddress: ((String?) -> Void)?
    
    var addressModelCount: Int {
        return addressModels.count
    }
    
    init(viewController: EditLocationChangebleAddressProtocol,
         placeMarkerModel: MarkerModel? = nil
    ) {
        self.viewController = viewController
        self.placeMarkerModel = placeMarkerModel
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
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
    
    func whenAfterSearchAddress(_ text: String) {
        totalCount = 0
        pageIndex = 1
        self.changedColorText = text
        
        PublicAPIRequestManager().publicAddressSearch(currentPage: String(pageIndex), keyword: text) { [weak self] result in
            switch result {
            case .success(let addressTableModel):
                guard let totalCount = addressTableModel.totalCount else { return }
                
                self?.totalCount = Int(totalCount)!
                self?.addressModels = addressTableModel.juso
            case .failure(let error):
                // TODO: Error 처리
                print(error.localizedDescription)
            }
        }
    }
    
    func whenScrollingTableView() {
        if totalCount > pageIndex * 20 {
            pageIndex += 1
            PublicAPIRequestManager().publicAddressSearch(
                currentPage: String(pageIndex),
                keyword: changedColorText
            ) { [weak self] result in
                switch result {
                case .success(let addressTableModel):
                    self?.addressModels.append(contentsOf: addressTableModel.juso)
                case .failure(let error):
                    // TODO: Error 처리
                    print(error)
                }
            }
        }
    }
    
    func checkSearchData(_ indexPath: IndexPath) -> Juso {
        return addressModels[indexPath.row]
    }
    
    func whenAfterClickedAddress(_ address: String?) {
        guard let address = address else { return }
        self.changedAddress = address
        
        self.afterChangedAddress?(changedAddress)
        
        viewController?.popViewController()
    }
    
    func whenAfterChangedCoordinate(_ coordinate: NMGLatLng) {
        let lat = String(coordinate.lat)
        let lng = String(coordinate.lng)
        KakaoMapRequestManager().kakaoMapCoordinateSearch(longtitude: lng, latitude: lat) { [weak self] coordinateModel in
            
            guard let firstDocument = coordinateModel.documents?.first,
                  let address = firstDocument.address?.address else {
                return
            }
            
            self?.changedAddress = address
            DispatchQueue.main.async {
                self?.viewController?.afterChangedAddressWhenMapView(address)
            }
        }
    }
    
    func editAddress() {
        self.afterChangedAddress?(changedAddress)

        viewController?.popViewController()
    }
    
}
