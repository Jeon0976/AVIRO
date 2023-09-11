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
//    func makeSlideView()
    func whenViewWillAppear()
    func whenViewWillAppearAfterSearchDataNotInAVIRO()
    func whenAfterPopEditPage()
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
    func ifDenied()
    func requestSuccess()
    func saveCenterCoordinate()
    func moveToCameraWhenNoAVIRO(_ lng: Double,
                                 _ lat: Double)
    func moveToCameraWhenHasAVIRO(_ markerModel:
                                  MarkerModel)
    func loadMarkers(_ markers: [NMFMarker])
    func afterLoadStarButton(noMarkers: [NMFMarker],
                             starMarkers: [NMFMarker]
    )
    func afterClickedMarker(placeModel: PlaceTopModel,
                            placeId: String,
                            isStar: Bool
    )
    func afterSlideupPlaceView(infoModel: PlaceInfoData?,
                               menuModel: PlaceMenuData?,
                               reviewsModel: PlaceReviewsData?
    )
    func showReportPlaceAlert()
    func isDuplicatedReport()
    func isSuccessReportPlaceActionSheet()
    func pushPlaceInfoOpreationHoursViewController(_ models: [EditOperationHoursModel])
    func pushEditPlaceInfoViewController(placeMarkerModel: MarkerModel,
                                         placeId: String,
                                         placeSummary: PlaceSummaryData,
                                         placeInfo: PlaceInfoData
    )
    func pushEditMenuViewController(placeId: String,
                                    isAll: Bool,
                                    isSome: Bool,
                                    isRequest: Bool,
                                    menuArray: [MenuArray])
    func refreshMenuView(_ menuData: PlaceMenuData?)
    func refreshMapPlace(_ mapPlace: MapPlace)
    func deleteMyReviewInView(_ commentId: String)
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let bookmarkManager = BookmarkFacadeManager()
    
    var homeMapData: [HomeMapData]?
    
    private var hasTouchedMarkerBefore = false
    private var afterSearchDataInAVIRO = false
    private var isFirstViewWillappear = true
    private var isShowEditPage = false
    
    private var selectedMarkerIndex = 0 
    private var selectedMarkerModel: MarkerModel?
    private var selectedSummaryModel: PlaceSummaryData?
    private var selectedInfoModel: PlaceInfoData?
    private var selectedMenuModel: PlaceMenuData?
    private var selectedReviewsModel: PlaceReviewsData?
    
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
//        viewController?.makeSlideView()
        
        addKeyboardNotification()
        
        if !isShowEditPage {
            if !afterSearchDataInAVIRO {
                viewController?.whenViewWillAppearAfterSearchDataNotInAVIRO()
            } else {
                afterSearchDataInAVIRO.toggle()
            }
        }
        
        if !isFirstViewWillappear {
            updateMarkerWhenViewWillAppear()
        } else {
            isFirstViewWillappear.toggle()
        }
    }
    
    private func updateMarkerWhenViewWillAppear() {
        let dateTime = TimeUtility.nowDateTime()
        let userId = UserId.shared.userId
        
        AVIROAPIManager().getNerbyPlaceModels(
            userId: userId,
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "100",
            time: dateTime
        ) { [weak self] mapDatas in
            self?.saveMarkers(mapDatas.data.placeData)
        }
    }
    
    func viewDidAppear() {
        
        firstLocationUpdate()
        
        if isShowEditPage {
            viewController?.whenAfterPopEditPage()
            isShowEditPage.toggle()
        }
    }
    
    func viewWillDisappear() {

        if !isShowEditPage {
            initMarkerState()
        }

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
            viewController?.keyboardWillShow(height: keyboardRectangle.height)
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
        
        /// bookmark 초기 데이터 불러오기
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
                mapPlace: place,
                isAll: data.allVegan,
                isSome: data.someMenuVegan,
                isRequest: data.ifRequestVegan
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
            selectedMarkerModel?.isCliced = false
            selectedMarkerModel = nil
            selectedMarkerIndex = 0
            selectedPlaceId = nil
            selectedInfoModel = nil
            selectedMenuModel = nil
            selectedReviewsModel = nil
            selectedSummaryModel = nil
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
        
        selectedMarkerModel?.isCliced = true
        
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
            
            self.selectedSummaryModel = place
            
            let placeTopModel = PlaceTopModel(
                placeState: mapPlace,
                placeTitle: place.title,
                placeCategory: place.category,
                distance: distanceString,
                reviewsCount: reviewsCount,
                address: place.address)
            
            DispatchQueue.main.async { [weak self] in
                let isStar = self?.bookmarkManager.checkData(placeId)
                self?.viewController?.afterClickedMarker(
                    placeModel: placeTopModel,
                    placeId: placeId,
                    isStar: isStar ?? false
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
    
    // MARK: Bookmark Load Method
    func loadBookmark(_ isSelected: Bool) {
        if isSelected {
            whenAfterLoadStarButtonTapped()
        } else {
            whenAfterLoadNotStarButtonTapped()
        }
    }
    
    private func whenAfterLoadStarButtonTapped() {
        let markersModel = MarkerModelArray.shared.getMarkerModels()

        let bookmarks = bookmarkManager.loadAllData()
        
        var starMarkersModel: [MarkerModel] = []
        var noMarkers: [NMFMarker] = []
        
        markersModel.forEach { model in
            if bookmarks.contains(model.placeId) {
                var model = model
                model.isStar = true
                starMarkersModel.append(model)
            } else {
                noMarkers.append(model.marker)
            }
        }
        
        var starMarkers: [NMFMarker] = []

        MarkerModelArray.shared.updateWhenStarButton(starMarkersModel)
        viewController?.afterLoadStarButton(noMarkers: noMarkers, starMarkers: starMarkers)
    }
    
    private func whenAfterLoadNotStarButtonTapped() {
        var starMarkersModel = MarkerModelArray.shared.getOnlyStarMarkerModels()
                
        for index in 0..<starMarkersModel.count {
            switch starMarkersModel[index].mapPlace {
            case .All:
                starMarkersModel[index].marker.makeIcon(.All)
            case .Some:
                starMarkersModel[index].marker.makeIcon(.Some)
            case .Request:
                starMarkersModel[index].marker.makeIcon(.Request)
            }
            starMarkersModel[index].isStar = false
        }
        
        MarkerModelArray.shared.updateWhenStarButton(starMarkersModel)

        let markers = MarkerModelArray.shared.getMarkers()
        
        viewController?.loadMarkers(markers)
    }
    
    // MARK: Bookmark Upload & Delete Method
    func updateBookmark(_ isSelected: Bool) {
        guard let placeId = selectedPlaceId else { return }
        
        if isSelected {
            bookmarkManager.updateData(placeId)
        } else {
            bookmarkManager.deleteData(placeId)
        }
    }
    
    // MARK: Get Place Model Detail
    func getPlaceModelDetail() {
        guard let placeId = selectedPlaceId else { return }

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AVIROAPIManager().getPlaceInfo(placeId: placeId) { [weak self] placeInfoModel in
            
            self?.selectedInfoModel = placeInfoModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AVIROAPIManager().getMenuInfo(placeId: placeId) { [weak self] placeMenuModel in
            self?.selectedMenuModel = placeMenuModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        AVIROAPIManager().getCommentInfo(placeId: placeId) { [weak self] placeReviewsModel in
            self?.selectedReviewsModel = placeReviewsModel.data
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.viewController?.afterSlideupPlaceView(
                infoModel: self?.selectedInfoModel,
                menuModel: self?.selectedMenuModel,
                reviewsModel: self?.selectedReviewsModel
            )
        }
    }
    
    // MARK: Place Id 불러오기
    func checkReportPlaceDuplecated() {
        guard let placeId = selectedPlaceId else { return }
        
        let model = AVIROPlaceReportCheckDTO(
            placeId: placeId,
            userId: UserId.shared.userId
        )
        
        AVIROAPIManager().getPlaceReportIsDuplicated(model) { [weak self] resultModel in
            DispatchQueue.main.async {
                if resultModel.reported {
                    self?.viewController?.isDuplicatedReport()
                } else {
                    self?.viewController?.showReportPlaceAlert()
                }
            }
        }
    }
    
    func reportPlace(_ type: AVIROPlaceReportEnum) {
        guard let placeId = selectedPlaceId else { return }
        
        let model = AVIROPlaceReportDTO(
            placeId: placeId,
            userId: UserId.shared.userId,
            content: type.rawValue)

        AVIROAPIManager().postPlaceReport(model) { [weak self] result in
            if result.statusCode == 200 {
                DispatchQueue.main.async {
                    self?.viewController?.isSuccessReportPlaceActionSheet()
                }
            }
        }
    }
    
    func loadPlaceOperationHours() {
        guard let selectedPlaceId = selectedPlaceId else { return }
        
        AVIROAPIManager().getOperationHour(placeId: selectedPlaceId) { [weak self] model in
            DispatchQueue.main.async {
                self?.viewController?.pushPlaceInfoOpreationHoursViewController(model.data.toEditOperationHoursModels())
            }
        }
    }
    
    func editPlaceInfo() {
        guard let placeMarkerModel = selectedMarkerModel,
              let placeId = selectedPlaceId,
              let placeSummary = selectedSummaryModel,
              let placeInfo = selectedInfoModel
        else { return }
        
        isShowEditPage = true
        
        viewController?.pushEditPlaceInfoViewController(
            placeMarkerModel: placeMarkerModel,
            placeId: placeId,
            placeSummary: placeSummary,
            placeInfo: placeInfo
        )
    }
    
    func editMenu() {
        guard let placeMarkerModel = selectedMarkerModel,
              let placeMenuModel = selectedMenuModel
        else { return }
        
        let placeId = placeMarkerModel.placeId
        let isAll = placeMarkerModel.isAll
        let isSome = placeMarkerModel.isSome
        let isRequest = placeMarkerModel.isRequest
        let menuArray = placeMenuModel.menuArray
        
        isShowEditPage = true

        viewController?.pushEditMenuViewController(
            placeId: placeId,
            isAll: isAll,
            isSome: isSome,
            isRequest: isRequest,
            menuArray: menuArray
        )
    }
    
    func afterEditMenu() {
        guard let placeId = selectedPlaceId else { return }
        AVIROAPIManager().getMenuInfo(placeId: placeId) { [weak self] placeMenuModel in
            DispatchQueue.main.async {
                self?.selectedMenuModel = placeMenuModel.data
                self?.viewController?.refreshMenuView(placeMenuModel.data)
            }
        }
    }
    
    func afterEditMenuChangedMarker(_ changedMarkerModel: EditMenuChangedMarkerModel) {
        guard var selectedMarkerModel = selectedMarkerModel else { return }
        selectedMarkerModel.mapPlace = changedMarkerModel.mapPlace
        selectedMarkerModel.isAll = changedMarkerModel.isAll
        selectedMarkerModel.isSome = changedMarkerModel.isSome
        selectedMarkerModel.isRequest = changedMarkerModel.isRequest
        
        MarkerModelArray.shared.change(selectedMarkerIndex, selectedMarkerModel)
        
        self.selectedMarkerModel = selectedMarkerModel
        
        viewController?.refreshMapPlace(changedMarkerModel.mapPlace)
    }
    
    func uploadReview(_ postReviewModel: AVIROCommentPost) {
        AVIROAPIManager().postCommentModel(postReviewModel)
    }
    
    func editMyReview(_ postEditReviewModel: AVIROEditCommentPost) {
        AVIROAPIManager().postEditCommentModel(postEditReviewModel) { model in
            
        }
    }
    
    func deleteMyReview(_ postDeleteReviewModel: AVIRODeleteCommentPost) {
        AVIROAPIManager().postDeleteCommentModel(postDeleteReviewModel) { [weak self] model in
            DispatchQueue.main.async {
                self?.viewController?.deleteMyReviewInView(postDeleteReviewModel.commentId)
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
