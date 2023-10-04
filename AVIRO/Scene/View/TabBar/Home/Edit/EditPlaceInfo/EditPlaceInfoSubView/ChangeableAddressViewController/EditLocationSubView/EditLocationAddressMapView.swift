//
//  EditLocationAddressMapView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

final class EditLocationAddressMapView: UIView {
    private lazy var mapSubTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지도를 움직여 아이콘을 원하는 위치로 옮겨보세요."
        label.font = .pretendard(size: 15, weight: .medium)
        label.textColor = .gray1
        
        return label
    }()
    
    private lazy var naverMap: NMFMapView = {
        let map = NMFMapView()
        
        map.addCameraDelegate(delegate: self)
        
        return map
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.numberOfLines = 2
        label.font = .pretendard(size: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var changedButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.backgroundColor = .gray6
        button.setTitleColor(.gray3, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(changedAddressButtonTapped(_:)), for: .touchUpInside)

        return button
    }()
    
    private lazy var loadLocationButton: HomeMapReferButton = {
        let button = HomeMapReferButton()
        
        button.setImage(
            UIImage.currentButton.withTintColor(.gray1),
            for: .normal
        )
        button.setImage(
            UIImage.currentButtonDisable.withTintColor(.gray4),
            for: .disabled
        )
        button.addTarget(
            self,
            action: #selector(locationButtonTapped(_:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private var newMarker = NMFMarker()
    private var afterMarkingMarked = false
    
    var isChangedCoordinate: ((NMGLatLng) -> Void)?
    var isTappedEditButtonWhemMapView: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeLayout() {
        [
            mapSubTitleLabel,
            naverMap,
            addressLabel,
            loadLocationButton,
            changedButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mapSubTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            mapSubTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            naverMap.topAnchor.constraint(equalTo: mapSubTitleLabel.bottomAnchor, constant: 16),
            naverMap.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            naverMap.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            naverMap.bottomAnchor.constraint(equalTo: changedButton.topAnchor, constant: -13),
            
            addressLabel.centerYAnchor.constraint(equalTo: changedButton.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: changedButton.leadingAnchor, constant: -5),
            
            loadLocationButton.bottomAnchor.constraint(equalTo: naverMap.bottomAnchor, constant: -20),
            loadLocationButton.trailingAnchor.constraint(equalTo: naverMap.trailingAnchor, constant: -20),
            
            changedButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            changedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            changedButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func dataBinding(_ marker: NMFMarker) {
        let markerPosition = marker.position
        let markerImage = marker.iconImage
        
        newMarker.position = markerPosition
        newMarker.iconImage = markerImage

        newMarker.mapView = naverMap
        
        let latLng = newMarker.position
        let position = NMFCameraPosition(latLng, zoom: 17)
        
        let cameraUpdate = NMFCameraUpdate(position: position)
        
        naverMap.moveCamera(cameraUpdate)
        
        isChangedCoordinate?(latLng)
    }
    
    func changedAddress(_ address: String) {
        self.addressLabel.text = address
        self.addressLabel.textColor = .gray0
        
        self.changedButton.setTitleColor(.gray7, for: .normal)
        self.changedButton.backgroundColor = .main
    }
    
    func whenNoAddressInMap() {
        self.addressLabel.text = "주소를 알 수 없는 위치입니다."
        self.addressLabel.textColor = .gray3
        
        self.changedButton.setTitleColor(.gray3, for: .normal)
        self.changedButton.backgroundColor = .gray6
    }
    
    @objc private func changedAddressButtonTapped(_ sender: UIButton) {
        if sender.backgroundColor == .main {
            isTappedEditButtonWhemMapView?()
        }
    }
}

extension EditLocationAddressMapView: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if afterMarkingMarked {
            let lat = mapView.latitude
            let lng = mapView.longitude
            
            let latLng = NMGLatLng(lat: lat, lng: lng)
            
            updateMarkerPosition(with: latLng)
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if !afterMarkingMarked {
            let lat = mapView.latitude
            let lng = mapView.longitude
            
            let latLng = NMGLatLng(lat: lat, lng: lng)
            
            newMarker.position = latLng
            
            afterMarkingMarked = true
        }
    }
    
    @objc private func locationButtonTapped(_ sender: UIButton) {
        naverMap.positionMode = .direction
        
        let lat = naverMap.latitude
        let lng = naverMap.longitude
        
        let latLng = NMGLatLng(lat: lat, lng: lng)
        
        updateMarkerPosition(with: latLng)
    }
    
    private func updateMarkerPosition(with latLng: NMGLatLng) {
        newMarker.position = latLng
        
        isChangedCoordinate?(latLng)
    }
}
