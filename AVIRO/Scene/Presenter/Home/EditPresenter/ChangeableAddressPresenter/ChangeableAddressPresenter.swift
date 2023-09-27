//
//  EditLocationDetailPresenter.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

protocol ChangebleAddressProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func dataBindingMap(_ marker: NMFMarker)
    func afterChangedAddressWhenMapView(_ address: String)
    func afterResultShowTable(with totalCount: Int)
    func popViewController()
    func showErrorAlert(with error: String, title: String?)
}

final class ChangeableAddressPresenter {
    weak var viewController: ChangebleAddressProtocol?
    
    private var addressModels = [Juso]() {
        didSet {
            let count = self.totalCount
            viewController?.afterResultShowTable(with: count)
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
    
    init(viewController: ChangebleAddressProtocol,
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
        
        PublicAPIManager().publicAddressSearch(currentPage: String(pageIndex), keyword: text) { [weak self] result in
            switch result {
            case .success(let addressTableModel):
                guard let totalCount = addressTableModel.totalCount else { return }
                
                self?.totalCount = Int(totalCount)!
                self?.addressModels = addressTableModel.juso
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    func whenScrollingTableView() {
        if totalCount > pageIndex * 20 {
            pageIndex += 1
            PublicAPIManager().publicAddressSearch(
                currentPage: String(pageIndex),
                keyword: changedColorText
            ) { [weak self] result in
                switch result {
                case .success(let addressTableModel):
                    self?.addressModels.append(contentsOf: addressTableModel.juso)
                case .failure(let error):
                    self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
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
        
        let model = KakaoCoordinateSearchDTO(lng: lng, lat: lat)
        
        KakaoAPIManager().coordinateSearch(with: model) { [weak self] result in
            switch result {
            case .success(let model):
                guard let firstDocument = model.documents?.first,
                      let address = firstDocument.address?.address else {
                    return
                }
                
                self?.changedAddress = address
                self?.viewController?.afterChangedAddressWhenMapView(address)
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    func editAddress() {
        self.afterChangedAddress?(changedAddress)

        viewController?.popViewController()
    }
    
}
