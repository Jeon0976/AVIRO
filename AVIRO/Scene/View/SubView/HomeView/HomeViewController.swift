//
//  HomeViewController.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import NMapsMap

enum Place {
    case All
    case Some
    case Request
}

final class HomeViewController: UIViewController {
    lazy var presenter = HomeViewPresenter(viewController: self)
        
    var naverMapView = NMFMapView()
    
    // 검색 기능 관련
    var searchTextField = MainField()

    // 내 위치 최신화 관련
    var loadLocationButton = UIButton()
    
    // store 뷰 관련
    var storeInfoView = HomeInfoStoreView()
    var panGesture = UIPanGestureRecognizer()
    var pageUpGesture = UISwipeGestureRecognizer()
    var pageDownGesture = UISwipeGestureRecognizer()
    
    // 최초 화면 뷰
    var firstPopupView = HomeFirstPopUpView()
    var blurEffectView = UIVisualEffectView()
    
    let allMap = NMFOverlayImage(name: "AllMap")
    let someMap = NMFOverlayImage(name: "SomeMap")
    let requestMap = NMFOverlayImage(name: "RequestMap")
    let allMapClicked = NMFOverlayImage(name: "AllMapClicked")
    let someMapClicked = NMFOverlayImage(name: "SomeMapClicked")
    let requestMapClicked = NMFOverlayImage(name: "RequestMapClicked")
    
    // MARK: Marker Info
    var markers: [(NMFMarker, Bool, Place)]? {
        didSet {
            if afterSaveAllPlace {
                guard let oldValue = oldValue?[selectedMarkerIndex],
                      let newValue = markers?[selectedMarkerIndex] else {
                    return
                }

                let (oldMarker, oldBoolValue, place) = oldValue
                let (newMarker, newBoolValue, _) = newValue

                if oldBoolValue != newBoolValue {

                    if newBoolValue == false {
                        switch place {
                        case .All:
                            newMarker.iconImage = allMap
                        case .Some:
                            newMarker.iconImage = someMap
                        case .Request:
                            newMarker.iconImage = requestMap
                        }
                    } else {
                        switch place {
                        case .All:
                            newMarker.iconImage = allMapClicked
                        case .Some:
                            newMarker.iconImage = someMapClicked
                        case .Request:
                            newMarker.iconImage = requestMapClicked
                        }
                    }
                }

            }
        }
    }
    var selectedMarkerIndex = 0
    var afterSaveAllPlace = false
    
    // TODO: zoom level
    var zoomLevel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.locationAuthorization()
        presenter.viewDidLoad()
        presenter.makeNotification()
        view.addSubview(zoomLevel)
        zoomLevel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            zoomLevel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zoomLevel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 30)
        ])
        zoomLevel.textColor = .black
        zoomLevel.font = .systemFont(ofSize: 20, weight: .bold)
        presenter.loadVeganData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.firstLocationUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
//        presenter.loadVeganData()
        if let markers = self.markers {
            for (index, _) in markers.enumerated() {
                self.markers?[index].1 = false
            }
        }
    }
    
}

extension HomeViewController: HomeViewProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            naverMapView,
            loadLocationButton,
            searchTextField
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // naverMapView
            naverMapView.topAnchor.constraint(
                equalTo: view.topAnchor),
            naverMapView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor, constant: 40),
            naverMapView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            naverMapView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            // loadLoactionButton
            loadLocationButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Layout.HomeView.minusLocationInset),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: Layout.HomeView.minusLocationInset),
            
            // searchTextField
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.leadingAnchor.constraint(
                equalTo: naverMapView.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: Layout.Inset.trailingBottom)
        ])
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // Navigation, View, TabBar
        view.backgroundColor = .white

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // NFMAP
        naverMapView.addCameraDelegate(delegate: self)

        // lodeLocationButton
        loadLocationButton.setImage(UIImage(named: Image.PersonalLocation), for: .normal)
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocationTouchDown),
            for: .touchDown
        )
        
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocationOnlyPopUp),
            for: .touchDragExit
        )
        
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocation),
            for: .touchUpInside
        )
        
        // searchTextField
        searchTextField.makePlaceHolder("어디로 이동할까요?")
        searchTextField.makeShadow()
        searchTextField.delegate = self
        
    }
    
    // MARK: Gesture 설정
    func makeGesture() {
        storeInfoView.addGestureRecognizer(panGesture)
        panGesture.addTarget(
            self,
            action: #selector(panGestureHandler)
        )
    }
    
    // MARK: SlideView 설정
    func makeSlideView() {
        // first popup view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.4
        
        firstPopupView.cancelButton.addTarget(self,
                                              action: #selector(firstPopupViewDelete),
                                              for: .touchUpInside
        )
        firstPopupView.reportButton.addTarget(self,
                                              action: #selector(firstPopupViewTouchDown(_:)),
                                              for: .touchDown
        )
        firstPopupView.reportButton.addTarget(self,
                                              action: #selector(firstPopupViewReportOnlyPopUp(_:)),
                                              for: .touchDragExit
        )
        firstPopupView.reportButton.addTarget(self,
                                              action: #selector(firstPopupViewReport(_:)),
                                              for: .touchUpInside
        )
        
        [
            blurEffectView,
            firstPopupView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // firstPopUpView
            firstPopupView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            firstPopupView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            firstPopupView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            firstPopupView.heightAnchor.constraint(
                equalToConstant: Layout.SlideView.firstHeight)
        ])
        
        // store info view
        storeInfoView.frame = CGRect(x: 0,
                                     y: self.view.frame.height,
                                     width: self.view.frame.width,
                                     height: CGFloat(Layout.SlideView.height)
        )
                
        storeInfoView.entireView.alpha = 0
        storeInfoView.activityIndicator.alpha = 0

        view.addSubview(storeInfoView)
    }
    
    // MARK: View Will Appear할 때 navigation & Tab Bar hidden Setting
    func whenViewWillAppear() {
        navigationController?.navigationBar.isHidden = true
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(false)
        }
    }
    
    // MARK: 위치 denided or approval
    // 위치 denied 할 때
    func ifDenied() {
        MyCoordinate.shared.longitude = 129.118924
        MyCoordinate.shared.latitude = 35.153354
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.153354, lng: 129.118924))
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // 위치 승인 되었을 때
    func requestSuccess() {
        naverMapView.positionMode = .direction
    }
    
    // MARK: center 위치 coordinate 저장하기
    func saveCenterCoordinate() {
        let center = naverMapView.cameraPosition.target

        CenterCoordinate.shared.longitude = center.lng
        CenterCoordinate.shared.latitude = center.lat
    }
    
    // MARK: AVIRO에 데이터가 없을때 지도 이동
    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double) {
        let latlng = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latlng, zoomTo: 14)
        cameraUpdate.animation = .easeOut
        
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: 지도에 마크 표시하기 작업
    func makeMarker(_ veganList: [HomeMapData]) {
        afterSaveAllPlace = false
        self.markers = [(NMFMarker, Bool, Place)]()
        
        veganList.forEach { homeMapData in
            
            let title = homeMapData.title
            let address = homeMapData.address
            let latLng = NMGLatLng(lat: homeMapData.y, lng: homeMapData.x)
            let marker = NMFMarker(position: latLng)
            let placeId = homeMapData.placeId
            
            if homeMapData.allVegan {
                marker.iconImage = allMap
                markers?.append((marker, false, Place.All))
            } else if homeMapData.someMenuVegan {
                marker.iconImage = someMap
                markers?.append((marker, false, Place.Some))
            } else {
                marker.iconImage = requestMap
                markers?.append((marker, false, Place.Request))
            }
            // Marker 터치할 때
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if nil != overlay as? NMFMarker {
        
                    let title = title
                    let address = address
                    guard let self = self else { return false }
                    
                    storeInfoView.title.text = title
                    storeInfoView.address.text = address
                    storeInfoView.placeId = placeId
                    
                    // 이전 선택된 마커를 원래 이미지로 되돌리기
                    let prevSelectedIndex = self.selectedMarkerIndex
                    if let prevMarker = self.markers?[prevSelectedIndex] {
                        switch prevMarker.2 {
                        case .All:
                            prevMarker.0.iconImage = self.allMap
                        case .Some:
                            prevMarker.0.iconImage = self.someMap
                        case .Request:
                            prevMarker.0.iconImage = self.requestMap
                        }
                        // 이전 선택된 마커의 선택 상태 업데이트
                        self.markers?[prevSelectedIndex].1 = false
                    }
                    
                    let latLng = marker.position
                    let cameraUpdate = NMFCameraUpdate(scrollTo: latLng, zoomTo: 14)
                    cameraUpdate.animation = .easeOut
                    naverMapView.moveCamera(cameraUpdate)
                    
                    if homeMapData.allVegan {
                        storeInfoView.imageView.image = UIImage(
                            named: Image.homeInfoVegan)
                        storeInfoView.topImageView.image = UIImage(
                            named: Image.homeInfoVeganTitle)
                    } else if homeMapData.someMenuVegan {
                        storeInfoView.imageView.image = UIImage(
                            named: Image.homeInfoSomeVegan)
                        storeInfoView.topImageView.image = UIImage(
                            named: Image.homeInfoSomeVeganTitle)
                    } else {
                        storeInfoView.imageView.image = UIImage(
                            named: Image.homeInfoRequestVegan)
                        storeInfoView.topImageView.image = UIImage(
                            named: Image.homeInfoRequestVeganTitle)
                    }
                    storeInfoView.imageView.contentMode = .scaleAspectFit
                    storeInfoView.topImageView.contentMode = .scaleAspectFit
                    
                    UIView.animate(withDuration: 0.15) {
                        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 32
                        self.storeInfoView.frame.origin.y =
                        self.view.frame.height - Layout.SlideView.height
                        self.storeInfoView.frame.size.height =
                        Layout.SlideView.height + tabBarHeight
                    }
                    
                    if let index = markers?.enumerated().first(where: { $0.element.0 == marker})?.offset {
                        selectedMarkerIndex = index
                        markers?[index].1 = true
                    }
                    
                }
                return true
            }
        }
        afterSaveAllPlace = true
        DispatchQueue.main.async { [weak self] in
            guard let markers = self?.markers else { return }
            for marker in markers {
                marker.0.mapView = self?.naverMapView
            }
        }
    }
    
    // MARK: pushDetailViewController
    func pushDetailViewController(_ placeId: String) {
        DispatchQueue.main.async { [weak self] in
            let viewController = DetailViewController()
            let presenter = DetailViewPresenter(viewController: viewController,
                                                placeId: placeId)
            viewController.presenter = presenter
            
            self?.navigationController?.pushViewController(
                viewController,
                animated: false
            )
        }
    }
}

// MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let viewController = HomeSearchViewController()
        navigationController?.pushViewController(viewController,
                                                 animated: false
        )
        return false
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        zoomLevel.text = String(mapView.zoomLevel)
        
        saveCenterCoordinate()
    }
}
