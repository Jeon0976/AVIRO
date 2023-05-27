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
    func presentPlaceListView(_ placeLists: [PlaceListModel])
    func ifDenied()
    func requestSuccess()
    func makeMarker(_ veganList: [VeganModel])
    func pushDetailViewController(_ veganModel: VeganModel)
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let userDefaults: UserDefaultsManagerProtocol?

    var veganData: [VeganModel]?
    
    init(viewController: HomeViewProtocol,
         userDefaults: UserDefaultsManagerProtocol = UserDefalutsManager()
    ) {
        self.viewController = viewController
        self.userDefaults = userDefaults
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        
        viewController?.makeLayout()
        viewController?.makeAttribute()
    }
    
    // MARK: vegan Data 불러오기
    func loadVeganData() {
        guard let veganData = userDefaults?.getData() else { return }
        self.veganData = veganData
        viewController?.makeMarker(veganData)
    }
    
    // MARK: pushDetailViewController
    func pushDetailViewController(_ address: String) {
        print(address)
        DispatchQueue.global().async { [weak self] in
            guard let veganData = self?.veganData else { return }
            print(veganData)
            if let data = veganData.first(where: { $0.placeModel.address == address }) {
                self?.viewController?.pushDetailViewController(data)
                print(data)
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
    // 1. viewDidLoad 일때
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
    
    // MARK: 개인 Location Data 불러오고 나서 할 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        PersonalLocation.shared.latitude = location.coordinate.latitude
        PersonalLocation.shared.longitude = location.coordinate.longitude

        locationManager.stopUpdatingLocation()
    }
}
