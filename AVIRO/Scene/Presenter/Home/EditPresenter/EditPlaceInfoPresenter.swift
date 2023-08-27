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
    func isDetailFieldCheckBeforeKeyboardShowAndHide(notification: NSNotification) -> Bool
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String
    )
    func dataBindingPhone(phone: String)
    func dataBindingHomepage(homepage: String)
    func pushAddressEditViewController(placeMarkerModel: MarkerModel)
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
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
    }
    
    func viewWillAppear() {
        addKeyboardNotification()
        
        dataBinding()
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    func addKeyboardNotification() {
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
    
    func removeKeyboardNotification() {
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(notification: notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
                viewController.keyboardWillShow(height: keyboardRectangle.height)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let viewController = viewController else { return }
        
        if viewController.isDetailFieldCheckBeforeKeyboardShowAndHide(notification: notification) {
            viewController.keyboardWillHide()
        }
    }
    
    // MARK: Data Binding
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
        guard let placeInfo = placeInfo,
              let phone = placeInfo.phone
        else { return }
        
        viewController?.dataBindingPhone(phone: phone)
    }
    
    private func dataBindingWorkingHours() {
        
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
}
