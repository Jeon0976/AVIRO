//
//  MainViewController.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import NMapsMap

final class MainViewController: UIViewController {
    lazy var presenter = MainViewPresenter(viewController: self)
    
    var naverMapView = NMFMapView()
    
    var testButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        presenter.locationAuthorization()
    }

}

// MARK: MainViewProtocol
extension MainViewController: MainViewProtocol {
    func makeLayout() {
        view.backgroundColor = .systemBackground
        
        [
            naverMapView,
            testButton
        ].forEach { view.addSubview($0) }
        
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        testButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            testButton.bottomAnchor.constraint(equalTo: naverMapView.bottomAnchor, constant: -16),
            testButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16)
        ])

    }
    
    func makeAttribute() {
        
        testButton.setImage(
            UIImage(
                systemName: "plus.circle",
                withConfiguration: Config.shared.buttonImageConfig),
            for: .normal
        )
        testButton.setImage(
            UIImage(
                systemName: "plus.circle.fill",
                withConfiguration: Config.shared.buttonImageConfig),
            for: .highlighted
        )
        testButton.addTarget(self, action: #selector(testLocation), for: .touchUpInside)
    }
    
    func showAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func markingMap() {
        guard let lat = PersonalLocation.shared.latitude,
              let lng = PersonalLocation.shared.longitude else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        naverMapView.positionMode = .direction
    }
}

// MARK: @Objc func
extension MainViewController {
    @objc func testLocation() {
        presenter.locationUpdate()

    }
}
