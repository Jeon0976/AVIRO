//
//  CustomLocationViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/05/22.
//

import UIKit

import NMapsMap

final class CustomLocationViewController: UIViewController {
    lazy var presenter = CustomLocationPresenter(viewController: self)
    
    var naverMapView = NMFMapView()
    
    var addressLabel = UILabel()
    
    // 내 위치 최신화 관련
    var loadLocationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension CustomLocationViewController: CustomLocationProtocol {
    // MARK: Layout
    func makeLayout() {
        view.backgroundColor = .white
        
        [
            naverMapView,
            loadLocationButton,
            addressLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // naverMapView
            naverMapView.topAnchor.constraint(
                equalTo: view.topAnchor),
            naverMapView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            naverMapView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            naverMapView.bottomAnchor.constraint(
                equalTo: addressLabel.topAnchor),
            
            // loadLocationButton
            loadLocationButton.bottomAnchor.constraint(
                equalTo: naverMapView.bottomAnchor, constant: -16),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -16),
            
            // detailView
            addressLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // navigationTitle
        let view = UIView(
            frame: CGRect(x: 0, y: 0,
                          width: (navigationController?.navigationBar.frame.width)!/2,
                          height: (navigationController?.navigationBar.frame.height)!)
        )
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        let titleLabel = UILabel()
        titleLabel.text = "위치를 선택해주세요"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        navigationItem.titleView = view

        // naverMapView
        naverMapView.positionMode = .direction
        naverMapView.touchDelegate = self
        
        // loadLocationButton
        loadLocationButton.customImageConfig("scope", "scope")
        loadLocationButton.addTarget(self, action: #selector(refreshMyLocation), for: .touchUpInside)
        
        // addressLabel
        addressLabel.font = .systemFont(ofSize: 18, weight: .bold)
        addressLabel.layer.cornerRadius = 8
        addressLabel.textColor = .black
    }
    
    func showAddress(_ address: String) {
        addressLabel.text = address
    }

}

extension CustomLocationViewController {
    @objc func refreshMyLocation() {
        naverMapView.positionMode = .direction
    }
}

// MARK: 지도 터치로 좌표 받기
extension CustomLocationViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        let lat = String(latlng.lat)
        let lng = String(latlng.lng)
        
        print(lat)
        presenter.searchCoodinate(lng, lat)
    }
}

extension CustomLocationViewController: UITableViewDelegate {
    
}
