//
//  EditLocationBottomView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

final class EditLocationBottomView: UIView {
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.font = .pretendard(size: 16, weight: .semibold)
        label.text = "가게 주소"
        label.textColor = .gray0
        
        return label
    }()
    
    private lazy var naverMap: NMFMapView = {
        let map = NMFMapView()
        
        map.allowsRotating = false
        map.allowsZooming = false
        map.allowsScrolling = false
        map.allowsTilting = false
        map.isUserInteractionEnabled = false
        map.logoAlign = .rightBottom
        
        map.contentInset = UIEdgeInsets(top: 100, left: 50, bottom: 0, right: 0)
        
        return map
    }()
    
    private lazy var mainAddressField: EnrollField = {
        let field = EnrollField()
        
        field.tag = 0
        field.delegate = self

        field.addRightPushViewControllerButton()
        field.tappedPushViewButton = { [weak self] in
            self?.naverMap.contentInset = .zero
            self?.tappedPushViewButton?()
        }
        
        return field
    }()
    
    private lazy var detailAddressField: EnrollField = {
        let field = EnrollField()
        
        let detail = "상세 정보를 입력하세요. (예. 동,층,호)"
        field.makePlaceHolder(detail)
        
        field.tag = 1
        field.delegate = self
        
        return field
    }()
    
    private var viewHeightConstraint: NSLayoutConstraint?
    
    var tappedPushViewButton: (() -> Void)?
    
    var afterChangedAddress: ((String) -> Void)?
    var afterChangedDetailAddress: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
        makeAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setViewHeight()
    }
    
    private func makeLayout() {
        viewHeightConstraint = self.heightAnchor.constraint(equalToConstant: 380)
        viewHeightConstraint?.isActive = true
        
        [
            addressLabel,
            naverMap,
            mainAddressField,
            detailAddressField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            naverMap.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15),
            naverMap.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            naverMap.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            naverMap.heightAnchor.constraint(equalToConstant: UIWindow().screen.bounds.height * 0.23),
            
            mainAddressField.topAnchor.constraint(equalTo: naverMap.bottomAnchor, constant: 15),
            mainAddressField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainAddressField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            detailAddressField.topAnchor.constraint(equalTo: mainAddressField.bottomAnchor, constant: 15),
            detailAddressField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            detailAddressField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func makeAttribute() {
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray7
        
        naverMap.layer.cornerRadius = 10
    }
    
    private func setViewHeight() {
        let addressLabelHeight = addressLabel.frame.height
        let naverMapHeight = naverMap.frame.height
        let mainAddressFieldHeight = mainAddressField.frame.height
        let detailAddressFieldHeight = detailAddressField.frame.height
        
        // 20 * 2 , 15 * 3
        let inset: CGFloat = 85
        
        let totalHeight = addressLabelHeight + naverMapHeight + mainAddressFieldHeight + detailAddressFieldHeight + inset
        
        viewHeightConstraint?.constant = totalHeight
    }
    
    func dataBinding(marker: NMFMarker, address: String) {
        marker.mapView = naverMap
        
        let latLng = marker.position
        let position = NMFCameraPosition(latLng, zoom: 17)
        let cameraUpdate = NMFCameraUpdate(position: position)
        
        naverMap.moveCamera(cameraUpdate)
        
        mainAddressField.text = address
    }
    
    func checkIsDetailField(notification: NSNotification) -> Bool {
        return detailAddressField.isFirstResponder
    }
    
    func changedAddressLabel(_ address: String) {
        mainAddressField.text = address

        afterChangedAddress?(address)
    }
    
    func changedNaverMap(_ latLng: NMGLatLng) {
        let position = NMFCameraPosition(latLng, zoom: 17)
        let cameraUpdate = NMFCameraUpdate(position: position)
        
        naverMap.moveCamera(cameraUpdate)
    }
}

extension EditLocationBottomView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            return false
        case 1:
            return true
        default:
            return true
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            return
        case 1:
            guard let addressDetail = textField.text else { return }
            afterChangedDetailAddress?(addressDetail)
        default:
            return
        }
    }
}
