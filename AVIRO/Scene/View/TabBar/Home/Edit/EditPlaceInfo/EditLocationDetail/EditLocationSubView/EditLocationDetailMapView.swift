//
//  EditLocationDetailMapView.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/27.
//

import UIKit

import NMapsMap

final class EditLocationDetailMapView: UIView {
    
    private lazy var mapSubTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "지도를 움직여 아이콘을 원하는 위치로 옮겨보세요."
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.backgroundColor = .gray6
        button.setTitleColor(.gray3, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

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
            enrollButton
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
            naverMap.bottomAnchor.constraint(equalTo: enrollButton.topAnchor, constant: -13),
            
            addressLabel.centerYAnchor.constraint(equalTo: enrollButton.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addressLabel.trailingAnchor.constraint(equalTo: enrollButton.leadingAnchor, constant: -5),
            
            enrollButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            enrollButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            enrollButton.widthAnchor.constraint(equalToConstant: 80)
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
    }
    
    @objc private func buttonTapped() {
        isTappedEditButtonWhemMapView?()
    }
}

extension EditLocationDetailMapView: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if afterMarkingMarked {
            let lat = mapView.latitude
            let lng = mapView.longitude
            
            let latLng = NMGLatLng(lat: lat, lng: lng)
            
            newMarker.position = latLng
            
            isChangedCoordinate?(latLng)
            
            self.enrollButton.setTitleColor(.gray7, for: .normal)
            self.enrollButton.backgroundColor = .main
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
}
