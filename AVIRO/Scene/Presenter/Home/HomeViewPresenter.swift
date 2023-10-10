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
    func whenViewWillAppearOffAllCondition()
    func whenAfterPopEditViewController()

    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide()
    
    func isSuccessLocation()
    func ifDeniedLocation(_ mapCoor: NMGLatLng)

    func loadMarkers(with markers: [NMFMarker])
    func afterLoadStarButton(with noStars: [NMFMarker])

    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double)
    func moveToCameraWhenHasAVIRO(_ markerModel: MarkerModel)
    
    func afterClickedMarker(placeModel: PlaceTopModel, placeId: String, isStar: Bool)
    func afterSlideupPlaceView(
        infoModel: AVIROPlaceInfo?,
        menuModel: AVIROPlaceMenus?,
        reviewsModel: AVIROReviewsArray?
    )
    
    func updateMenus(_ menuData: AVIROPlaceMenus?)
    func updateMapPlace(_ mapPlace: MapPlace)
    func deleteMyReview(_ commentId: String)
    
    func pushPlaceInfoOpreationHoursViewController(_ models: [EditOperationHoursModel])
    func pushEditPlaceInfoViewController(
        placeMarkerModel: MarkerModel,
        placeId: String,
        placeSummary: AVIROPlaceSummary,
        placeInfo: AVIROPlaceInfo,
        editSegmentedIndex: Int
    )
    func pushEditMenuViewController(placeId: String, isAll: Bool, isSome: Bool, isRequest: Bool, menuArray: [AVIROMenu])

    func showActionSheetWhenSuccessReport()
    func showToastAlert(_ title: String)
    func showAlertWhenReportPlace()
    func showAlertWhenDuplicatedReport()
    func showErrorAlert(with error: String, title: String?)
    func showErrorAlertWhenLoadMarker()
}

final class HomeViewPresenter: NSObject {
    weak var viewController: HomeViewProtocol?
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let locationManager = CLLocationManager()
    private let bookmarkManager = BookmarkFacadeManager()
    
    var homeMapData: [AVIROMarkerModel]?
    
    private var hasTouchedMarkerBefore = false
    private var whenShowPlaceAfterActionFromOtherViewController = false
    private var isFirstViewWillappear = true
    private var whenKeepPlaceInfoView = false
    
    private var selectedMarkerIndex = 0 
    private var selectedMarkerModel: MarkerModel?
    private var selectedSummaryModel: AVIROPlaceSummary?
    private var selectedInfoModel: AVIROPlaceInfo?
    private var selectedMenuModel: AVIROPlaceMenus?
    private var selectedReviewsModel: AVIROReviewsArray?
        
    private var selectedPlaceId: String?
    
    private var nowDateTime = TimeUtility.nowDateAndTime()
    
    init(viewController: HomeViewProtocol) {
        self.viewController = viewController
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(NotiName.afterMainSearch.rawValue),
            object: nil
        )
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
        
        MyCoordinate.shared.afterFirstLoadLocation = { [weak self] in
            self?.loadVeganData()
        }
            
        setNotification()
        
        viewController?.setupLayout()
        viewController?.setupAttribute()
        viewController?.setupGesture()
                
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(afterMainSearchPlace(_:)),
            name: NSNotification.Name(NotiName.afterMainSearch.rawValue),
            object: nil
        )
    }
    
    func viewWillAppear() {
        addKeyboardNotification()

        handleMarkerUpdate()
        handleViewWillAppearActions()
    }
    
    private func handleMarkerUpdate() {
        if !whenKeepPlaceInfoView && !isFirstViewWillappear {
            refreshMapMarkers()
        }
    }
    
    private func handleViewWillAppearActions() {
        viewController?.whenViewWillAppear()
        
        if isFirstViewWillappear {
            isFirstViewWillappear.toggle()
            
            return
        }
        
        if whenKeepPlaceInfoView { return }

        if !whenShowPlaceAfterActionFromOtherViewController {
            viewController?.whenViewWillAppearOffAllCondition()
        }
    }
    
    func viewDidAppear() {
        if whenKeepPlaceInfoView {
            viewController?.whenAfterPopEditViewController()
            whenKeepPlaceInfoView.toggle()
        }
    }
    
    func viewWillDisappear() {
        removeKeyboardNotification()

        if whenShowPlaceAfterActionFromOtherViewController {
            whenShowPlaceAfterActionFromOtherViewController.toggle()
        }
        
        if !whenKeepPlaceInfoView {
            initMarkerState()
        }
    }
    
    // MARK: 전화, url 들어가고 난 후에도 계속 place 정보 보여주기 위한 함수
    func shouldKeepPlaceInfoViewState(_ state: Bool) {
        whenKeepPlaceInfoView = state
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
    func loadVeganData() {
        let mapModel = AVIROMapModelDTO(
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "0.0",
            time: nil
        )
                
        AVIROAPIManager().loadNerbyPlaceModels(with: mapModel) { [weak self] result in
            switch result {
            case .success(let mapDatas):
                if mapDatas.statusCode == 200 {
                    self?.saveMarkers(mapDatas.data.updatedPlace)
                } else {
                    self?.viewController?.showErrorAlertWhenLoadMarker()
                }
                
            case .failure(_):
                self?.viewController?.showErrorAlertWhenLoadMarker()
            }
        }
        
        bookmarkManager.fetchAllData { [weak self] error in
            self?.viewController?.showErrorAlert(with: error, title: nil)
        }
    }
    
    private func saveMarkers(_ mapData: [AVIROMarkerModel]?) {
        guard let mapData = mapData else { return }
        
        var markerModels = [MarkerModel]()

        mapData.forEach { data in
            let markerModel = createMarkerModel(from: data)
            markerModels.append(markerModel)
        }
        
        LocalMarkerData.shared.setMarkerModel(markerModels)
        
        DispatchQueue.main.async { [weak self] in
            let markers = LocalMarkerData.shared.getMarkers()
            self?.viewController?.loadMarkers(with: markers)
        }
    }
    
    // MARK: Refresh Vegan Data
    private func refreshMapMarkers() {
        let mapModel = AVIROMapModelDTO(
            longitude: MyCoordinate.shared.longitudeString,
            latitude: MyCoordinate.shared.latitudeString,
            wide: "0.0",
            time: nowDateTime
        )
        
        AVIROAPIManager().loadNerbyPlaceModels(with: mapModel) { [weak self] result in
            switch result {
            case .success(let mapDatas):
                if let updatePlace = mapDatas.data.updatedPlace {
                    self?.updateMarkers(updatePlace)
                }
               
                if let deletedPlace = mapDatas.data.deletedPlace {
                    self?.deleteMarkers(deletedPlace)
                }
                
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    private func updateMarkers(_ mapData: [AVIROMarkerModel]?) {
        guard let mapData = mapData else { return }
        
        let uniqueMapData = Array(Set(mapData))

        uniqueMapData.forEach { data in
            let markerModel = createMarkerModel(from: data)
            LocalMarkerData.shared.updateMarkerModel(markerModel)
        }
        
        DispatchQueue.main.async { [weak self] in
            let markers = LocalMarkerData.shared.getUpdatedMarkers()
            self?.viewController?.loadMarkers(with: markers)
            self?.nowDateTime = TimeUtility.nowDateAndTime()
            
            if CenterCoordinate.shared.isChangedFromEnrollView {
                self?.whenShowPlaceAfterActionFromOtherViewController = true
                
                self?.whenAfterEnrollPlace()
            }
        }
    }
    
    private func deleteMarkers(_ placeId: [String]) {
        DispatchQueue.main.async {
            placeId.forEach {
                LocalMarkerData.shared.deleteMarkerModel(with: $0)
            }
        }
    }
    
    private func whenAfterEnrollPlace() {
        guard let lat = CenterCoordinate.shared.latitude,
              let lng = CenterCoordinate.shared.longitude
        else { return }
        
        let (markerModel, index) = LocalMarkerData.shared.getMarkerWhenEnrollAfter(x: lat, y: lng)
        
        guard var markerModel = markerModel else { return }
        guard let index = index else { return }
        
        markerModel.isClicked = true
                
        getPlaceSummaryModel(markerModel)
        
        hasTouchedMarkerBefore = true
        
        selectedMarkerIndex = index
        selectedMarkerModel = markerModel
        selectedMarkerModel?.isClicked = true
        
        LocalMarkerData.shared.updateWhenClickedMarker(selectedMarkerModel!)
        
        viewController?.moveToCameraWhenHasAVIRO(markerModel)
        
        CenterCoordinate.shared.isChangedFromEnrollView = false
    }
    
    // MARK: Create Marker
    private func createMarkerModel(from data: AVIROMarkerModel) -> MarkerModel {
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
        
        let test =  MarkerModel(
            placeId: placeId,
            marker: marker,
            mapPlace: place,
            isAll: data.allVegan,
            isSome: data.someMenuVegan,
            isRequest: data.ifRequestVegan
        )
                
        return test
    }
    
    // MARK: Marker Touched Method
    private func touchedMarker(_ marker: NMFMarker) {
        resetPreviouslyTouchedMarker()
        
        setMarkerToTouchedState(marker)
    }
    
    func initMarkerState() {
        resetPreviouslyTouchedMarker()
    }

    private func resetPreviouslyTouchedMarker() {
       /// 최초 터치 이후 작동을 위한 분기처리
        if hasTouchedMarkerBefore {
            if var selectedMarkerModel = selectedMarkerModel {
                selectedMarkerModel.isClicked = false
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
        
        selectedMarkerModel?.isClicked = true
        
        hasTouchedMarkerBefore = true
        
        LocalMarkerData.shared.updateWhenClickedMarker(selectedMarkerModel!)
        
        viewController?.moveToCameraWhenHasAVIRO(validMarkerModel)
    }
    
    // MARK: Load Place Sumamry
    private func getPlaceSummaryModel(_ markerModel: MarkerModel) {
        let mapPlace = markerModel.mapPlace
        let placeX = markerModel.marker.position.lng
        let placeY = markerModel.marker.position.lat
        let placeId = markerModel.placeId

        selectedPlaceId = placeId
        
        AVIROAPIManager().loadPlaceSummary(with: placeId) { [weak self] result in
            switch result {
            case .success(let summary):
                if summary.statusCode == 200 {
                    if let place = summary.data {
                        let distanceValue = LocationUtility.distanceMyLocation(
                            x_lng: placeX,
                            y_lat: placeY
                        )
                        let distanceString = String(distanceValue).convertDistanceUnit()
                        let reviewsCount = String(place.commentCount)
                        
                        self?.selectedSummaryModel = place
                        
                        let placeTopModel = PlaceTopModel(
                            placeState: mapPlace,
                            placeTitle: place.title,
                            placeCategory: place.category,
                            distance: distanceString,
                            reviewsCount: reviewsCount,
                            address: place.address
                        )
                        
                        self?.appDelegate?.amplitude?.track(
                            eventType: AMType.popupPlace.rawValue,
                            eventProperties: ["Place": place.title]
                        )
                        
                        DispatchQueue.main.async {
                            let isStar = self?.bookmarkManager.checkData(placeId)
                            
                            self?.viewController?.afterClickedMarker(
                                placeModel: placeTopModel,
                                placeId: placeId,
                                isStar: isStar ?? false
                            )
                        }
                    }
                } else {
                    if let message = summary.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    // MARK: Save Center Coordinate
    func saveCenterCoordinate(_ coordinate: NMGLatLng) {
        CenterCoordinate.shared.longitude = coordinate.lng
        CenterCoordinate.shared.latitude = coordinate.lat
    }
    
    // MARK: Notification Method afterMainSearch
    @objc func afterMainSearchPlace(_ noficiation: Notification) {
        guard let checkIsInAVIRO = noficiation.userInfo?[NotiName.afterMainSearch.rawValue]
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
            
            whenShowPlaceAfterActionFromOtherViewController = true
            
            getPlaceSummaryModel(markerModel)
                        
            selectedMarkerIndex = index
            selectedMarkerModel = markerModel
            selectedMarkerModel?.isClicked = true
            
            LocalMarkerData.shared.updateWhenClickedMarker(selectedMarkerModel!)
            
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
        viewController?.afterLoadStarButton(with: noMarkers)
    }
    
    private func whenAfterLoadNotStarButtonTapped() {
        var starMarkersModel = LocalMarkerData.shared.getOnlyStarMarkerModels()
                
        for index in 0..<starMarkersModel.count {
            starMarkersModel[index].isStar = false
        }
        
        LocalMarkerData.shared.updateWhenStarButton(starMarkersModel)

        let markers = LocalMarkerData.shared.getMarkers()
        
        viewController?.loadMarkers(with: markers)
    }
    
    // MARK: Bookmark Upload & Delete Method
    func updateBookmark(_ isSelected: Bool) {
        guard let placeId = selectedPlaceId else { return }
        
        if isSelected {
            bookmarkManager.updateData(placeId) { [weak self] error in
                self?.viewController?.showToastAlert(error)
            }
        } else {
            bookmarkManager.deleteData(placeId) { [weak self] error in
                self?.viewController?.showToastAlert(error)
            }
        }
    }
    
    // MARK: Get Place Model Detail
    func getPlaceModelDetail() {
        guard let placeId = selectedPlaceId else { return }

        let dispatchGroup = DispatchGroup()
        
        loadPlaceInfo(with: placeId, dispatchGroup: dispatchGroup)
        loadPlaceMenus(with: placeId, dispatchGroup: dispatchGroup)
        loadPlaceReviews(with: placeId, dispatchGroup: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.viewController?.afterSlideupPlaceView(
                infoModel: self?.selectedInfoModel,
                menuModel: self?.selectedMenuModel,
                reviewsModel: self?.selectedReviewsModel
            )
        }
    }
    
    private func loadPlaceInfo(with placeId: String, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        AVIROAPIManager().loadPlaceInfo(with: placeId) { [weak self] result in
            defer { dispatchGroup.leave() }
            
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    self?.selectedInfoModel = model.data
                } else {
                    if let message = model.message {
                        self?.viewController?.showErrorAlert(with: message, title: "가게 에러")
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: "가게 에러")
                }
            }
        }
    }
    
    private func loadPlaceMenus(with placeId: String, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        AVIROAPIManager().loadMenus(with: placeId) { [weak self] result in
            defer { dispatchGroup.leave() }
            
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    self?.selectedMenuModel = model.data
                } else {
                    if let message = model.message {
                        self?.viewController?.showErrorAlert(with: message, title: "메뉴 에러")
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: "메뉴 에러")
                }
            }
        }
    }
    
    private func loadPlaceReviews(with placeId: String, dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        AVIROAPIManager().loadReviews(with: placeId) { [weak self] result in
            defer { dispatchGroup.leave() }
            
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    self?.selectedReviewsModel = model.data
                } else {
                    if let message = model.message {
                        self?.viewController?.showErrorAlert(with: message, title: "후기 에러")
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: "후기 에러")
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

        AVIROAPIManager().reportPlace(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    self?.viewController?.showActionSheetWhenSuccessReport()
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    func checkReportPlaceDuplecated() {
        guard let placeId = selectedPlaceId else { return }
        
        let model = AVIROPlaceReportCheckDTO(
            placeId: placeId,
            userId: MyData.my.id
        )
        
        AVIROAPIManager().checkPlaceReportIsDuplicated(with: model) { [weak self] result in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    if success.reported {
                        self?.viewController?.showAlertWhenDuplicatedReport()
                    } else {
                        self?.viewController?.showAlertWhenReportPlace()
                    }
                } else {
                    if let message = success.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }

    func getPlace() -> String {
        guard let place = selectedSummaryModel?.title else { return "" }
        return place
    }
    
    func loadPlaceOperationHours() {
        guard let placeId = selectedPlaceId else { return }
        
        AVIROAPIManager().loadOperationHours(with: placeId) { [weak self] result in
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    if let model = model.data {
                        self?.viewController?.pushPlaceInfoOpreationHoursViewController(
                            model.toEditOperationHoursModels()
                        )
                    }
                } else {
                    if let message = model.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                if let error = error.errorDescription {
                    self?.viewController?.showErrorAlert(with: error, title: nil)
                }
            }
        }
    }
    
    func editPlaceInfo(withSelectedSegmentedControl placeEditSegmentedIndex: Int = 0) {
        guard let placeMarkerModel = selectedMarkerModel,
              let placeId = selectedPlaceId,
              let placeSummary = selectedSummaryModel,
              let placeInfo = selectedInfoModel
        else { return }
        
        whenKeepPlaceInfoView = true
                
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
        
        whenKeepPlaceInfoView = true
        
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
        AVIROAPIManager().loadMenus(with: placeId) { [weak self] result in
            switch result {
            case .success(let menuModel):
                if menuModel.statusCode == 200 {
                    if let model = menuModel.data {
                        self?.setAmplitudeWhenEditMenu(with: model.menuArray)
                        
                        self?.selectedMenuModel = model
                        self?.viewController?.updateMenus(model)
                    }
                } else {
                    if let message = menuModel.message {
                        self?.viewController?.showErrorAlert(with: message, title: nil)
                    }
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    private func setAmplitudeWhenEditMenu(with menuArray: [AVIROMenu]) {
        guard let beforeMenus = selectedMenuModel?.menuArray else { return }
        
        var beforeMenusString = ""
        
        for (index, menu) in beforeMenus.enumerated() {
            let menuString = "\(index + 1): (\(menu.menu) \(menu.price) \(menu.howToRequest))"
            beforeMenusString += menuString + "\n"
        }
        
        var afterMenusString = ""
        
        for (index, menu) in menuArray.enumerated() {
            let menuString = "\(index + 1): (\(menu.menu) \(menu.price) \(menu.howToRequest))"
            afterMenusString += menuString + "\n"
        }
        
        appDelegate?.amplitude?.track(
            eventType: AMType.afterEditMenu.rawValue,
            eventProperties: [
                "Place": selectedSummaryModel?.title as Any,
                "BeforeChangedMenuArray": beforeMenusString,
                "AfterChangedMenuArray": afterMenusString
            ]
        )
    }
    
    func afterEditMenuChangedMarker(_ changedMarkerModel: EditMenuChangedMarkerModel) {
        guard var selectedMarkerModel = selectedMarkerModel else { return }
        
        selectedMarkerModel.mapPlace = changedMarkerModel.mapPlace
        selectedMarkerModel.isAll = changedMarkerModel.isAll
        selectedMarkerModel.isSome = changedMarkerModel.isSome
        selectedMarkerModel.isRequest = changedMarkerModel.isRequest

        LocalMarkerData.shared.changeMarkerModel(selectedMarkerIndex, selectedMarkerModel)

        self.selectedMarkerModel = selectedMarkerModel
        
        viewController?.updateMapPlace(changedMarkerModel.mapPlace)
    }
    
    func uploadReview(_ postReviewModel: AVIROEnrollReviewDTO) {
        AVIROAPIManager().createReview(with: postReviewModel) { [weak self] result in
            switch result {
            case .success(let model):
                if let message = model.message {
                    self?.appDelegate?.amplitude?.track(
                        eventType: AMType.afterUploadReview.rawValue,
                        eventProperties: [
                            "Place": self?.selectedSummaryModel?.title as Any,
                            "Review": postReviewModel.content
                        ]
                    )
                    self?.viewController?.showToastAlert(message)
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    func editMyReview(_ postEditReviewModel: AVIROEditReviewDTO) {
        
        AVIROAPIManager().editReview(with: postEditReviewModel) { [weak self] result in
            switch result {
            case .success(let model):
                if let message = model.message {
                    self?.viewController?.showToastAlert(message)
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
    
    func deleteMyReview(_ postDeleteReviewModel: AVIRODeleteReveiwDTO) {
        AVIROAPIManager().deleteReview(with: postDeleteReviewModel) { [weak self] result in
            switch result {
            case .success(let model):
                if model.statusCode == 200 {
                    self?.viewController?.deleteMyReview(postDeleteReviewModel.commentId)
                }
                
                if let message = model.message {
                    self?.viewController?.showToastAlert(message)
                }
            case .failure(let error):
                self?.viewController?.showErrorAlert(with: error.localizedDescription, title: nil)
            }
        }
    }
}

// MARK: CLLocationManagerDelegate
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
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            if !isFirstViewWillappear {
                ifDeniedLocation()
            }
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        MyCoordinate.shared.latitude = location.coordinate.latitude
        MyCoordinate.shared.longitude = location.coordinate.longitude

        if !MyCoordinate.shared.isFirstLoadLocation {
            MyCoordinate.shared.isFirstLoadLocation = true
        }
        
        locationManager.stopUpdatingLocation()
        
        viewController?.isSuccessLocation()
    }
    
    private func ifDeniedLocation() {
        MyCoordinate.shared.latitude = DefaultCoordinate.lat.rawValue
        MyCoordinate.shared.longitude = DefaultCoordinate.lng.rawValue

        if !MyCoordinate.shared.isFirstLoadLocation {
            MyCoordinate.shared.isFirstLoadLocation = true
        }
        
        let mapCoor = NMGLatLng(lat: DefaultCoordinate.lat.rawValue, lng: DefaultCoordinate.lng.rawValue)
        
        viewController?.ifDeniedLocation(mapCoor)
    }
}
