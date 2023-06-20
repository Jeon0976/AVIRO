//
//  HomeViewPresenter.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit
import CoreLocation

protocol HomeViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func makeSlideView()
    func whenViewWillAppear()
    func ifDenied()
    func requestSuccess()
    func makeMarker(_ veganList: [HomeMapData])
    func pushDetailViewController(_ veganModel: HomeMapData)
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let aviroManager = AVIROAPIManager()

    var homeMapData: [HomeMapData]?
    
    var firstLocation = true
    
    init(viewController: HomeViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        
        viewController?.makeLayout()
        viewController?.makeAttribute()
        viewController?.makeGesture()
    }
    
    func viewWillAppear() {
        viewController?.whenViewWillAppear()
        viewController?.makeSlideView()
    }
    
    // MARK: vegan Data 불러오기
    func loadVeganData() {
        aviroManager.getPlaceModels(
            longitude: PersonalLocation.shared.longitudeString,
            latitude: PersonalLocation.shared.latitudeString,
            wide: "0.0") { [weak self] mapDatas in
                self?.homeMapData = mapDatas.data.placeData
                self?.viewController?.makeMarker((self?.homeMapData)!)
            }
    }
    
    // MARK: pushDetailViewController
    func pushDetailViewController(_ placeId: String) {
        DispatchQueue.global().async { [weak self] in
            guard let homeMapData = self?.homeMapData else { return }
            if let data = homeMapData.first(where: { $0.placeId == placeId }) {
                self?.viewController?.pushDetailViewController(data)
            }
        }
    }
}

// MARK: user location 불러오기 관련 작업들
extension HomeViewPresenter: CLLocationManagerDelegate {
    func locationAuthorization() {
        
        switch locationManager.authorizationStatus {
        case .denied:
            viewController?.ifDenied()
            // TODO: 만약 거절했을 시 앞으로 해야할 작업
            
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    // MARK: 개인 location data 불러오기 작업
    // 1. viewWillAppear 일때
    // 2. 위치 확인 데이터 누를 때
    func locationUpdate() {
        if locationManager.authorizationStatus != .authorizedAlways,
           locationManager.authorizationStatus != .authorizedWhenInUse {
            viewController?.ifDenied()
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            viewController?.requestSuccess()
        }
    }
    
    // MARK: first location data 불러오기
    func firstLocationUpdate() {
        guard firstLocation else { return }
        if locationManager.authorizationStatus != .authorizedAlways,
           locationManager.authorizationStatus != .authorizedWhenInUse {
            viewController?.ifDenied()
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            viewController?.requestSuccess()
        }
        
        firstLocation = !firstLocation
    }

    // MARK: 개인 Location Data 불러오고 나서 할 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        PersonalLocation.shared.latitude = location.coordinate.latitude
        PersonalLocation.shared.longitude = location.coordinate.longitude

        locationManager.stopUpdatingLocation()
    }
}
