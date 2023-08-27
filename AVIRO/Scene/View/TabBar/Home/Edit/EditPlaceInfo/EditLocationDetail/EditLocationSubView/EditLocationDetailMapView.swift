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
        
        return map
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray0
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("등록", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.backgroundColor = .gray6
        button.setTitleColor(.gray3, for: .normal)
        button.layer.cornerRadius = 10

        return button
    }()
    
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
            enrollButton.widthAnchor.constraint(equalToConstant: 75),
            enrollButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func dataBinding(_ marker: NMFMarker) {
        marker.mapView = naverMap
        
        let latlng = marker.position
        let position = NMFCameraPosition(latlng, zoom: 14)
        let cameraUpdate = NMFCameraUpdate(position: position)
        
        naverMap.moveCamera(cameraUpdate)
    }
}
