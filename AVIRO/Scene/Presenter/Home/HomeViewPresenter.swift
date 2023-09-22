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
    func setupLayout()
    func setupAttribute()
    func setupGesture()
    func whenViewWillAppear()
    func whenViewWillAppearAfterSearchDataNotInAVIRO()
    func whenAfterPopEditPage()
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
    func ifDeniedLocation()
    func isSuccessLocation()
    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double)
    func moveToCameraWhenHasAVIRO(_ markerModel: MarkerModel)
    func loadMarkers(_ markers: [NMFMarker])
    func afterLoadStarButton(noMarkers: [NMFMarker])
    func afterClickedMarker(
        placeModel: PlaceTopModel,
        placeId: String,
        isStar: Bool
    )
    func afterSlideupPlaceView(
        infoModel: AVIROPlaceInfo?,
        menuModel: AVIROPlaceMenus?,
        reviewsModel: AVIROReviewsArrayDTO?
    )
    func showReportPlaceAlert()
    func isDuplicatedReport()
    func isSuccessReportPlaceActionSheet()
    func pushPlaceInfoOpreationHoursViewController(_ models: [EditOperationHoursModel])
    func pushEditPlaceInfoViewController(
        placeMarkerModel: MarkerModel,
        placeId: String,
        placeSummary: AVIROPlaceSummary,
        placeInfo: AVIROPlaceInfo,
        editSegmentedIndex: Int
    )
    func pushEditMenuViewController(
        placeId: String,
        isAll: Bool,
        isSome: Bool,
        isRequest: Bool,
        menuArray: [AVIROMenu]
    )
    func refreshMenuView(_ menuData: AVIROPlaceMenus?)
    func refreshMapPlace(_ mapPlace: MapPlace)
    func deleteMyReviewInView(_ commentId: String)
    func showToastAlert(_ title: String)
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let locationManager = CLLocationManager()
    private let bookmarkManager = BookmarkFacadeManager()
    
    var homeMapData: [AVIROMarkerModel]?
    
    private var hasTouchedMarkerBefore = false
    private var afterSearchDataInAVIRO = false
    private var isFirstViewWillappear = true
    private var shouldKeepPlaceInfoView = false
    
    private var selectedMarkerIndex = 0 
    private var selectedMarkerModel: MarkerModel?
    private var selectedSummaryModel: AVIROPlaceSummary?
    private var selectedInfoModel: AVIROPlaceInfo?
    private var selectedMenuModel: AVIROPlaceMenus?
    private var selectedReviewsModel: AVIROReviewsArrayDTO?
        
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
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupGesture()
        makeNotification()

        locationManager.delegate = self
        locationAuthorization()
                
        loadVeganData()
    }
    
    func viewWillAppear() {
        addKeyboardNotification()

        viewController?.whenViewWillAppear()

        if !isFirstViewWillappear {

            updateMarkerWhenViewWillAppear()

            if !shouldKeepPlaceInfoView {
                if !afterSearchDataInAVIRO {
                    viewController?.whenViewWillAppearAfterSearchDataNotInAVIRO()
                } else {
                    afterSearchDataInAVIRO.toggle()
                }
            }
        } else {
            isFirstViewWillappear.toggle()
        }
        
        moveToCamraWhenAfterEnrollPlace()
    }
    
    private func moveToCamraWhenAfterEnrollPlace() {
        CenterCoordinate.shared.coordinateChanged = { [weak self] in
            self?.viewController?.moveToCameraWhenNoAVIRO(
                CenterCoordinate.shared.longitude ?? 0.0,
                CenterCoordinate.shared.latitude ?? 0.0
            )
        }
    }
    
    private func updateMarkerWhenViewWillAppear() {
        let dateTime = TimeUtility.nowDateAndTime()
        
        let getMarkerModel = AVIROMapModelDTO(
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "0.0",
            time: dateTime
        )
        
        AVIROAPIManager().getNerbyPlaceModels(
            mapModel: getMarkerModel
        ) { [weak self] mapDatas in
            self?.saveMarkers(mapDatas.data.updatedPlace)
        }
    }
    
    func viewDidAppear() {
        if shouldKeepPlaceInfoView {
            viewController?.whenAfterPopEditPage()
            shouldKeepPlaceInfoView.toggle()
        }
    }
    
    func viewWillDisappear() {
        if !shouldKeepPlaceInfoView {
            initMarkerState()
        }

        removeKeyboardNotification()
    }
    
    // MARK: 전화, url 들어가고 난 후에도 계속 place 정보 보여주기 위한 함수
    func shouldKeepPlaceInfoViewState(_ state: Bool) {
        shouldKeepPlaceInfoView = state
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
        viewController?.keyboardWillShow(notification: notification)
    }
    
    @objc func keyboardWillHide() {
        viewController?.keyboardWillHide()
    }
    
    // MARK: vegan Data 불러오기
    private func loadVeganData() {
        
        let getMarkerModel = AVIROMapModelDTO(
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "0.0",
            time: nil
        )
        
        AVIROAPIManager().getNerbyPlaceModels(
            mapModel: getMarkerModel
        ) { [weak self] mapDatas in
            self?.saveMarkers(mapDatas.data.updatedPlace)
        }
        
        /// bookmark 초기 데이터 불러오기
        bookmarkManager.fetchAllData()
    }
    
    // MARK: Marker 상태 초기화
    func initMarkerState() {
        resetPreviouslyTouchedMarker()
    }
    
    // MARK: Marker Data singleton에 저장하기
    func saveMarkers(_ mapData: [AVIROMarkerModel]?) {
        guard let mapData = mapData else { return }
        mapData.forEach { data in
            let latLng = NMGLatLng(
                lat: data.y,
                lng: data.x
            )
            
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
            
            LocalMarkerData.shared.setMarkerModel(markerModel)
        }
        
        DispatchQueue.main.async { [weak self] in
            let markers = LocalMarkerData.shared.getMarkers()
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
            if var selectedMarkerModel = selectedMarkerModel {
                selectedMarkerModel.isCliced = false
                LocalMarkerData.shared.updateWhenClickedMarker(selectedMarkerModel)
            }
            
            selectedMarkerModel = nil
            selectedMarkerIndex = 0
            selectedPlaceId = nil
            selectedInfoModel = nil
            selectedMenuModel = nil
            selectedReviewsModel = nil
            selectedSummaryModel = nil
        }
    }
    
    /// 클릭한 마커 저장 후 viewController에 알리기
    private func setMarkerToTouchedState(_ marker: NMFMarker) {
        let (markerModel, index) = LocalMarkerData.shared.getMarkerFromMarker(marker)
        
        guard let validMarkerModel = markerModel else { return }
        
        guard let validIndex = index else { return }
        getPlaceSummaryModel(validMarkerModel)
        
        selectedMarkerIndex = validIndex
        selectedMarkerModel = validMarkerModel
        
        selectedMarkerModel?.isCliced = true
        
        hasTouchedMarkerBefore = true
        
        LocalMarkerData.shared.updateWhenClickedMarker(selectedMarkerModel!)
        
        viewController?.moveToCameraWhenHasAVIRO(validMarkerModel)
    }
    
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
    private func makeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkIsInAVRIONotificaiton(_:)),
            name: NSNotification.Name(UDKey.matchedPlaceModel.rawValue),
            object: nil
        )
    }
    
    // MARK: Notification Method afterMainSearch
    @objc func checkIsInAVRIONotificaiton(_ noficiation: Notification) {
        guard let checkIsInAVIRO = noficiation.userInfo?[UDKey.matchedPlaceModel.rawValue]
                as? MatchedPlaceModel else { return }
        
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
            let (markerModel, index) = LocalMarkerData.shared.getMarkerWhenSearchAfter(afterSearchModel)
            
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
        let markersModel = LocalMarkerData.shared.getMarkerModels()

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
                
        LocalMarkerData.shared.updateWhenStarButton(starMarkersModel)
        viewController?.afterLoadStarButton(noMarkers: noMarkers)
    }
    
    private func whenAfterLoadNotStarButtonTapped() {
        var starMarkersModel = LocalMarkerData.shared.getOnlyStarMarkerModels()
                
        for index in 0..<starMarkersModel.count {
            starMarkersModel[index].isStar = false
        }
        
        LocalMarkerData.shared.updateWhenStarButton(starMarkersModel)

        let markers = LocalMarkerData.shared.getMarkers()
        
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
            userId: MyData.my.id
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
    
    func reportPlace(_ type: AVIROReportPlaceType) {
        guard let placeId = selectedPlaceId else { return }
        
        let model = AVIROReportPlaceDTO(
            placeId: placeId,
            userId: MyData.my.id,
            nickname: MyData.my.nickname,
            code: type.code
        )

        AVIROAPIManager().postPlaceReport(model) { [weak self] result in
            if result.statusCode == 200 {
                DispatchQueue.main.async {
                    self?.viewController?.isSuccessReportPlaceActionSheet()
                }
            }
        }
    }
    
    func getPlace() -> String {
        guard let place = selectedSummaryModel?.title else { return "" }
        return place
    }
    
    func loadPlaceOperationHours() {
        guard let selectedPlaceId = selectedPlaceId else { return }
        
        AVIROAPIManager().getOperationHour(placeId: selectedPlaceId) { [weak self] model in
            DispatchQueue.main.async {
                self?.viewController?.pushPlaceInfoOpreationHoursViewController(model.data.toEditOperationHoursModels())
            }
        }
    }
    
    func editPlaceInfo(withSelectedSegmentedControl placeEditSegmentedIndex: Int = 0) {
        guard let placeMarkerModel = selectedMarkerModel,
              let placeId = selectedPlaceId,
              let placeSummary = selectedSummaryModel,
              let placeInfo = selectedInfoModel
        else { return }
        
        shouldKeepPlaceInfoView = true
        
        viewController?.pushEditPlaceInfoViewController(
            placeMarkerModel: placeMarkerModel,
            placeId: placeId,
            placeSummary: placeSummary,
            placeInfo: placeInfo,
            editSegmentedIndex: placeEditSegmentedIndex
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
        
        shouldKeepPlaceInfoView = true

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
        
        LocalMarkerData.shared.changeMarkerModel(selectedMarkerIndex, selectedMarkerModel)
        
        self.selectedMarkerModel = selectedMarkerModel
        
        viewController?.refreshMapPlace(changedMarkerModel.mapPlace)
    }
    
    func uploadReview(_ postReviewModel: AVIROEnrollReviewDTO) {
        AVIROAPIManager().postCommentModel(postReviewModel) { [weak self] model in
            if let message = model.message {
                DispatchQueue.main.async {
                    self?.viewController?.showToastAlert(message)
                }
            }
        }
        
    }
    
    func editMyReview(_ postEditReviewModel: AVIROEditReviewDTO) {
        AVIROAPIManager().postEditCommentModel(postEditReviewModel) { [weak self] model in
            if let message = model.message {
                DispatchQueue.main.async {
                    self?.viewController?.showToastAlert(message)
                }
            }
        }
    }
    
    // MARK: 수정 요망
    func deleteMyReview(_ postDeleteReviewModel: AVIRODeleteReveiwDTO) {
        AVIROAPIManager().postDeleteCommentModel(postDeleteReviewModel) { [weak self] model in
            DispatchQueue.main.async {
                if let message = model.message {
                    self?.viewController?.showToastAlert(message)
                } else {
                    self?.viewController?.showToastAlert("삭제에 성공했습니다.")
                }
                self?.viewController?.deleteMyReviewInView(postDeleteReviewModel.commentId)
            }
        }
    }
}

// MARK: user location 불러오기 관련 작업들
extension HomeViewPresenter: CLLocationManagerDelegate {
    func locationUpdate() {
        locationAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorization()
    }
    
    private func locationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            viewController?.isSuccessLocation()
            
        case .denied, .restricted:
            viewController?.ifDeniedLocation()

        default:
            break
        }
    }
    
    // MARK: 개인 Location Data 불러오고 나서 할 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        MyCoordinate.shared.latitude = location.coordinate.latitude
        MyCoordinate.shared.longitude = location.coordinate.longitude
                
        locationManager.stopUpdatingLocation()
        viewController?.isSuccessLocation()
    }
}
