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
    func markingMap()
    func presentPlaceListView(_ placeLists: [PlaceListModel])
    func ifDenied()
    func showWarnningAelrt(_ alert: UIAlertController)
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let requestManager = KakaoMapRequestManager()

    init(viewController: HomeViewProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        
        viewController?.makeLayout()
        viewController?.makeAttribute()
        
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: 개인 Location Data 불러오고 나서 할 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        PersonalLocation.shared.latitude = location.coordinate.latitude
        PersonalLocation.shared.longitude = location.coordinate.longitude

        viewController?.markingMap()
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: 최초 검색 시 마켓,카페 검색 API 호출
    func showPlaceListView(_ locations: String) {
        guard PersonalLocation.shared.latitude != nil else {
            let alert = CustomAlertController.shared.whenSearchAfterDeniedLocation("검색 불가", "위치를 활성화 해주세요.")
            viewController?.showWarnningAelrt(alert)
            return
        }
//        QuerySingleTon.shared.query = locations
        requestManager.kakaoMapKeywordSearch(query: locations,
                                      longitude: PersonalLocation.shared.longitudeString,
                                      latitude: PersonalLocation.shared.latitudeString,
                                      page: "1") { model in
            PageEndingCheck.shared.isend = model.meta.isEnd
            
            let placeLists = model.documents.map { location in
                let placeListCellModel = PlaceListModel(
                    title: location.name,
                    distance: location.distance,
                    category: location.category,
                    address: location.address,
                    phone: location.phone,
                    url: location.url,
                    x: Double(location.xToLongitude)!,
                    y: Double(location.yToLatitude)!
                )
                return placeListCellModel
            }
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.presentPlaceListView(placeLists)
            }
        }
    }
}
