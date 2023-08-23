//
//  HomeViewPresenter.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit
import CoreLocation

import NMapsMap

protocol HomeViewProtocol: NSObject {
    func makeLayout()
    func makeAttribute()
    func makeGesture()
    func makeSlideView()
    func whenViewWillAppear()
    func whenViewWillAppearAfterSearchDataNotInAVIRO()
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func ifDenied()
    func requestSuccess()
    func saveCenterCoordinate()
    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double)
    func moveToCameraWhenHasAVIRO(_ markerModel: MarkerModel)
    func loadMarkers(_ markers: [NMFMarker])
    func afterClickedMarker(placeModel: PlaceTopModel,
                            placeId: String
    )
    func afterSlideupPlaceView(infoModel: PlaceInfoData?,
                               menuModel: PlaceMenuData?,
                               reviewsModel: PlaceReviewsData?
    )
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let bookmarkManager = BookmarkFacadeManager()
    
    var homeMapData: [HomeMapData]?
    
    private var hasTouchedMarkerBefore = false
    private var afterSearchDataInAVIRO = false
    private var selectedMarkerIndex = 0 
    private var selectedMarkerModel: MarkerModel?
    
    private var firstLocation = true
    
    private var selectedPlaceId: String?
    
    init(viewController: HomeViewProtocol) {
        self.viewController = viewController
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("checkIsInAVRIO"),
            object: nil
        )
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
        addKeyboardNotification()
        
        if !afterSearchDataInAVIRO {
            viewController?.whenViewWillAppearAfterSearchDataNotInAVIRO()
        } else {
            afterSearchDataInAVIRO.toggle()
        }
    }
    
    func viewWillDisappear() {
        initMarkerState()
        removeKeyboardNotification()
    }
    
    // MARK: Keyboard에 따른 view 높이 변경 Notification
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            viewController?.keyboardWillShow(height: keyboardRectangle.height - 50)
        }
    }
    
    @objc func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    // MARK: vegan Data 불러오기
    func loadVeganData() {
        let userId = UserId.shared.userId
        
        AVIROAPIManager().getNerbyPlaceModels(
            userId: userId,
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "100",
            time: nil
        ) { [weak self] mapDatas in
            self?.saveMarkers(mapDatas.data.placeData)
        }
        
        bookmarkManager.fetchAllData()
    }
    
    // MARK: Marker 상태 초기화
    func initMarkerState() {
        guard let selectedMarkerModel = selectedMarkerModel else { return }
        
        selectedMarkerModel.marker.changeIcon(selectedMarkerModel.mapPlace, false)
    }
    
    // MARK: Marker Data singleton에 저장하기
    func saveMarkers(_ mapData: [HomeMapData]) {
        mapData.forEach { data in
            let latLng = NMGLatLng(lat: data.y, lng: data.x)
            let marker = NMFMarker(position: latLng)
            let placeId = data.placeId
            var place: MapPlace
            
            if data.allVegan {
                place = MapPlace.All
            } else if data.someMenuVegan {
                place = MapPlace.Some
            } else {
                place = MapPlace.Request
            }
            
            marker.makeIcon(place)
            marker.touchHandler = { [weak self] _ in
                self?.touchedMarker(marker)
                
                return true
            }
            
            let markerModel = MarkerModel(
                placeId: placeId,
                marker: marker,
                mapPlace: place
            )
            
            MarkerModelArray.shared.setData(markerModel)
        }
        
        DispatchQueue.main.async { [weak self] in
            let markers = MarkerModelArray.shared.getMarkers()
            self?.viewController?.loadMarkers(markers)
        }
    }
    
    // MARK: Marker Touched Method
    private func touchedMarker(_ marker: NMFMarker) {
        resetPreviouslyTouchedMarker()
        setMarkerToTouchedState(marker)
    }
    
    // MARK: Reset Previous Marker
   func resetPreviouslyTouchedMarker() {
       /// 최초 터치 이후 작동을 위한 분기처리
        if hasTouchedMarkerBefore {
            let markerModel = MarkerModelArray.shared.getMarkerFromIndex(selectedMarkerIndex)
            
            guard let markerModel = markerModel else { return }
            markerModel.marker.changeIcon(markerModel.mapPlace, false)
        }
    }
    
    // MARK: setMarkerToTouchedState
    /// 클릭한 마커 저장 후 viewController에 알리기
    private func setMarkerToTouchedState(_ marker: NMFMarker) {
        let (markerModel, index) = MarkerModelArray.shared.getMarkerFromMarker(marker)
        
        guard let validMarkerModel = markerModel else { return }
        
        guard let validIndex = index else { return }
        
        getPlaceSummaryModel(validMarkerModel)
        
        selectedMarkerIndex = validIndex
        selectedMarkerModel = validMarkerModel
        
        validMarkerModel.marker.changeIcon(validMarkerModel.mapPlace, true)

        hasTouchedMarkerBefore = true
        
        viewController?.moveToCameraWhenHasAVIRO(validMarkerModel)
    }
    
    // MARK: Get PlaceModel
    /// 클릭 된 마커 데이터 받기 위한 api 호출
    private func getPlaceSummaryModel(_ markerModel: MarkerModel) {
        let mapPlace = markerModel.mapPlace
        let placeX = markerModel.marker.position.lng
        let placeY = markerModel.marker.position.lat
        let placeId = markerModel.placeId

        selectedPlaceId = placeId
                
        AVIROAPIManager().getPlaceSummary(placeId: placeId) { summary in
            let place = summary.data

            let distanceValue = LocationUtility.distanceMyLocation(x_lng: placeX, y_lat: placeY)

            let distanceString = String(distanceValue).convertDistanceUnit()
            let reviewsCount = String(place.commentCount)

            let placeTopModel = PlaceTopModel(
                placeState: mapPlace,
                placeTitle: place.title,
                placeCategory: place.category,
                distance: distanceString,
                reviewsCount: reviewsCount,
                address: place.address)

            DispatchQueue.main.async { [weak self] in
                self?.viewController?.afterClickedMarker(
                    placeModel: placeTopModel,
                    placeId: placeId
                )
            }
        }
    }
    
    // MARK: Save Center Coordinate
    func saveCenterCoordinate(_ coordinate: NMGLatLng) {
        CenterCoordinate.shared.longitude = coordinate.lng
        CenterCoordinate.shared.latitude = coordinate.lat
    }
    
    // MARK: Make Notification
    func makeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkIsInAVRIONotificaiton(_:)),
            name: NSNotification.Name("checkIsInAVRIO"),
            object: nil
        )
    }
    
    // MARK: Notification Method afterMainSearch
    @objc func checkIsInAVRIONotificaiton(_ noficiation: Notification) {
        guard let checkIsInAVIRO = noficiation.userInfo?["checkIsInAVRIO"] as? MatchedPlaceModel else { return }
        
        afterMainSearch(checkIsInAVIRO)
    }
    
    // MARK: After Main Search Method
    private func afterMainSearch(_ afterSearchModel: MatchedPlaceModel) {
        // AVIRO에 데이터가 없을 때
        if !afterSearchModel.allVegan && !afterSearchModel.someVegan && !afterSearchModel.requestVegan {
            viewController?.moveToCameraWhenNoAVIRO(
                afterSearchModel.x,
                afterSearchModel.y
            )
        } else {
        // AVIRO에 데이터가 있을 때
            let (markerModel, index) = MarkerModelArray.shared.getMarkerWhenSearchAfter(
                afterSearchModel.x,
                afterSearchModel.y
            )
            
            guard let markerModel = markerModel else { return }
            guard let index = index else { return }
            
            markerModel.marker.changeIcon(markerModel.mapPlace, true)
            afterSearchDataInAVIRO = true
            
            getPlaceSummaryModel(markerModel)
            
            selectedMarkerIndex = index
            selectedMarkerModel = markerModel
            hasTouchedMarkerBefore = true
            
            viewController?.moveToCameraWhenHasAVIRO(markerModel)
        }
    }
    
    // MARK: Get Place Model Detail
    func getPlaceModelDetail() {
        guard let placeId = selectedPlaceId else { return }
        
        let dispatchGroup = DispatchGroup()
        
        var infoModel: PlaceInfoData?
        var menuModel: PlaceMenuData?
        var reviewsModel: PlaceReviewsData?
        
        dispatchGroup.enter()
        AVIROAPIManager().getPlaceInfo(placeId: placeId) { placeInfoModel in
            
            infoModel = placeInfoModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AVIROAPIManager().getMenuInfo(placeId: placeId) { placeMenuModel in
            
            menuModel = placeMenuModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AVIROAPIManager().getCommentInfo(placeId: placeId) { placeReviewsModel in
            
            reviewsModel = placeReviewsModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.viewController?.afterSlideupPlaceView(
                infoModel: infoModel,
                menuModel: menuModel,
                reviewsModel: reviewsModel
            )
        }
    }
  
    func postReviewModel(_ postReviewModel: AVIROCommentPost) {
        print("Test")
        AVIROAPIManager().postCommentModel(postReviewModel)
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
        
        firstLocation.toggle()
    }

    // MARK: 개인 Location Data 불러오고 나서 할 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        MyCoordinate.shared.latitude = location.coordinate.latitude
        MyCoordinate.shared.longitude = location.coordinate.longitude
                
        locationManager.stopUpdatingLocation()
    }
}
