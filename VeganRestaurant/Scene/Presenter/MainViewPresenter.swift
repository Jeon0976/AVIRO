//
//  MainViewPresenter.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit
import CoreLocation

protocol MainViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func showAlert(_ alert: UIAlertController)
    func markingMap()
}

final class MainViewPresenter: NSObject {
    weak var viewController: MainViewProtocol?
    
    private let locationManager = CLLocationManager()
    
    init(viewController: MainViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
}


// MARK: user location 불러오기 관련 작업들
extension MainViewPresenter: CLLocationManagerDelegate {
    func locationAuthorization() {
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .denied:
            //TODO: 만약 거절했을 시 앞으로 해야할 작업
            print("왜 거절?")
            makeAlert("왜..?", "너 암것도 모태용~")
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationUpdate() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        PersonalLocation.shared.latitude = location.coordinate.latitude
        PersonalLocation.shared.longtitude = location.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        viewController?.markingMap()
    }
}


extension MainViewPresenter {
    func makeAlert(_ title: String, _ message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let checkAlertAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(checkAlertAction)
        
        viewController?.showAlert(alert)
    }
}
