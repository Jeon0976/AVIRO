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
    func makeGesture()
    func handleClosure()
    func isDetailFieldCheckBeforeKeyboardShowAndHide(notification: NSNotification) -> Bool
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String
    )
    func dataBindingPhone(phone: String)
    func dataBindingOperatingHours(operatingHourModels: [EditOperationHoursModel])
    func dataBindingHomepage(homepage: String)
    func pushAddressEditViewController(placeMarkerModel: MarkerModel)
    func updateNaverMap(_ latLng: NMGLatLng)
}

final class EditPlaceInfoPresenter {
    weak var viewController: EditPlaceInfoProtocol?
    
    private var placeId: String?
    private var placeMarkerModel: MarkerModel?
    private var placeSummary: PlaceSummaryData?
    private var placeInfo: PlaceInfoData?
    
    private var newMarker = NMFMarker()
    
    private var changedAddress = "" {
        didSet {
            afterEditAddress()
        }
    }
    
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
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
        viewController?.handleClosure()
        
        dataBinding()
    }
    
    func viewWillAppear() {
        addKeyboardNotification()
        
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(notification: notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
                viewController.keyboardWillShow(height: keyboardRectangle.height)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(notification: notification) {
            viewController.keyboardWillHide()
        }
    }
    
    // MARK: Data Binding
    func dataBinding() {
        dataBindingLocation()
        dataBindingPhone()
        dataBindingWorkingHours()
        dataBindingHomepage()
    }
    
    private func dataBindingLocation() {
        guard let placeSummary = placeSummary,
              let placeMarkerModel = placeMarkerModel else { return }
        let title = placeSummary.title
        let category = placeSummary.category
        let address = placeSummary.address
        
        let markerPosition = placeMarkerModel.marker.position
        let markerImage = placeMarkerModel.marker.iconImage
        
        newMarker.position = markerPosition
        newMarker.iconImage = markerImage
        
        viewController?.dataBindingLocation(
            title: title,
            category: category,
            marker: newMarker,
            address: address
        )
    }
    
    private func dataBindingPhone() {
        guard let placeInfo = placeInfo,
              let phone = placeInfo.phone
        else { return }
        
        viewController?.dataBindingPhone(phone: phone)
    }
    
    private func dataBindingWorkingHours() {
        guard let placeId = placeId else { return }
        AVIROAPIManager().getOperationHour(placeId: placeId) { [weak self] model in
            DispatchQueue.main.async {
                self?.viewController?.dataBindingOperatingHours(operatingHourModels: model.data.toEditOperationHoursModels())
            }
        }
    }
    
    private func dataBindingHomepage() {
        guard let placeInfo = placeInfo,
              let homepage = placeInfo.url
        else { return }
        
        viewController?.dataBindingHomepage(homepage: homepage)
    }
    
    func pushAddressEditViewController() {
        guard let placeMarkerModel = placeMarkerModel else { return }
        
        viewController?.pushAddressEditViewController(placeMarkerModel: placeMarkerModel)
    }
    
    func saveChangedAddress(_ address: String) {
        self.changedAddress = address
    }
    
    private func afterEditAddress() {
        KakaoMapRequestManager().kakaoMapAddressSearch(address: changedAddress) { [weak self] addressModel in
            guard let documents = addressModel.documents, documents.count > 0 else { return }
            
            let firstCoordinate = documents[0]
            
            if let x = firstCoordinate.x, let y = firstCoordinate.y {
                DispatchQueue.main.async {
                    self?.changedMarker(lat: y, lng: x)
                }
            }
        }
    }
    
    private func changedMarker(lat: String, lng: String) {
        guard let lat = Double(lat),
              let lng = Double(lng) else { return }
        
        let latLng = NMGLatLng(lat: lat, lng: lng)
        
        newMarker.position = latLng
        
        viewController?.updateNaverMap(latLng)
    }
}
