//
//  HomeViewController.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import NMapsMap

final class HomeViewController: UIViewController {
    lazy var presenter = HomeViewPresenter(viewController: self)
        
    private lazy var naverMapView = NMFMapView()
    
    // 검색 기능 관련
    private lazy var searchTextField = MainField()

    // 내 위치 최신화 관련
    private lazy var loadLocationButton = UIButton()
    private lazy var starButton = UIButton()
    
    lazy var placeView = PlaceView()
    var placeViewTopConstraint: NSLayoutConstraint?
    var placeViewHeightConstraint: NSLayoutConstraint?
    private var viewHeight: CGFloat!
    
    /// view 위 아래 움직일때마다 height값과 layout의 시간 차 발생?하는것 같음
    var placePopupViewHeight: CGFloat!
    private var isSlideUpView = false
    private var isCanMoveCameraWhenSlideUpView = true
    
    // store 뷰 관련
    var storeInfoView = HomeInfoStoreView()
    private var upGesture = UISwipeGestureRecognizer()
    private var downGesture = UISwipeGestureRecognizer()
    // 최초 화면 뷰
    var firstPopupView = HomeFirstPopUpView()
    var blurEffectView = UIVisualEffectView()
        
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }
}

extension HomeViewController: HomeViewProtocol {
    // MARK: Layout
    func makeLayout() {
        [
            naverMapView,
            loadLocationButton,
            starButton,
            searchTextField,
            placeView
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
            loadLocationButton.bottomAnchor.constraint(equalTo: placeView.topAnchor, constant: -20),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -20),
            
            // starButton
            starButton.bottomAnchor.constraint(equalTo: loadLocationButton.topAnchor, constant: -10),
            starButton.trailingAnchor.constraint(equalTo: loadLocationButton.trailingAnchor),
            
            // searchTextField
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.leadingAnchor.constraint(
                equalTo: naverMapView.leadingAnchor, constant: Layout.Inset.leadingTop),
            searchTextField.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: Layout.Inset.trailingBottom),
            
            // placeView
            placeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        viewHeight = self.view.frame.height
        
        placeViewHeightConstraint = placeView.heightAnchor.constraint(equalToConstant: viewHeight)
        placeViewHeightConstraint?.isActive = true
        
        placeViewTopConstraint = placeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        placeViewTopConstraint?.isActive = true
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // Navigation, View, TabBar
        view.backgroundColor = .gray7

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // NFMAP
        naverMapView.addCameraDelegate(delegate: self)
        naverMapView.touchDelegate = self
        // lodeLocationButton
        loadLocationButton.setImage(UIImage(named: "current-location"), for: .normal)
        loadLocationButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        loadLocationButton.backgroundColor = .gray7
        loadLocationButton.layer.cornerRadius = 15
        loadLocationButton.layer.shadowColor = UIColor.black.cgColor
        loadLocationButton.layer.shadowOpacity = 0.15
        loadLocationButton.layer.shadowOffset = .init(width: 1, height: 3)
        loadLocationButton.layer.shadowRadius = 5
        
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
        
        starButton.setImage(UIImage(named: "star"), for: .normal)
        starButton.setImage(UIImage(named: "selectedStar"), for: .selected)
        starButton.addTarget(self, action: #selector(starButtonTapped(sender:)), for: .touchUpInside)
        starButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        starButton.backgroundColor = .gray7
        starButton.layer.cornerRadius = 15
        starButton.layer.shadowColor = UIColor.black.cgColor
        starButton.layer.shadowOpacity = 0.15
        starButton.layer.shadowOffset = .init(width: 1, height: 3)
        starButton.layer.shadowRadius = 5
        
        // searchTextField
        searchTextField.makePlaceHolder("어디로 이동할까요?")
        searchTextField.makeShadow()
        searchTextField.delegate = self
        
        placeView.topView.whenFullBackButtonTapped = { [weak self] in
            self?.naverMapView.isHidden = false
            self?.placeViewPopUpAfterInitPlacePopViewHeight()
        }
    }
    
    // MARK: Star Button
    @objc func starButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    // MARK: Gesture 설정
    func makeGesture() {
        placeView.addGestureRecognizer(upGesture)
        placeView.addGestureRecognizer(downGesture)

        upGesture.direction = .up
        downGesture.direction = .down
        
        upGesture.addTarget(self, action: #selector(swipeGestureTapped(_:)))
        downGesture.addTarget(self, action: #selector(swipeGestureTapped(_:)))
    }
    
    @objc func swipeGestureTapped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            if isSlideUpView {
                placeViewFullUp()
                naverMapView.isHidden = true
                isSlideUpView = false
            } else {
                placeViewSlideUp()
                isSlideUpView = true
            }
        } else if gesture.direction == .down {
            if isSlideUpView {
                isCanMoveCameraWhenSlideUpView = false
                placeViewPopUpAfterInitPlacePopViewHeight()
                isSlideUpView = false
            }
        }
    }
    
    // MARK: Clicked Marker Data Binding
    func afterClickedMarker(_ placeModel: PlaceTopModel) {
        placeView.topView.dataBinding(placeModel)
        isCanMoveCameraWhenSlideUpView = true
        placeViewPopUp()
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

    }
    
    // MARK: View Will Appear할 때 navigation & Tab Bar hidden Setting
    func whenViewWillAppear() {
        navigationController?.navigationBar.isHidden = true
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(false)
        }
        
        whenViewWillAppearInitPlaceView()
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
    
    // MARK: Marker Map에 대입하는 메소드
    func loadMarkers() {
        DispatchQueue.main.async { [weak self] in
            let markers = MarkerModelArray.shared.getMarkers()
         
            markers.forEach {
                $0.mapView = self?.naverMapView
            }
        }
    }
    
    // MARK: AVIRO에 데이터가 없을 때 지도 이동
    func moveToCameraWhenNoAVIRO(_ lng: Double, _ lat: Double) {
        let latlng = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latlng, zoomTo: 14)
        cameraUpdate.animation = .easeOut
        
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: AVIRO에 데이터가 있을 때 지도 이동
    func moveToCameraWhenHasAVIRO(_ markerModel: MarkerModel) {
        let latlng = markerModel.marker.position
        let cameraUpdate = NMFCameraUpdate(scrollTo: latlng, zoomTo: 14)
        cameraUpdate.animation = .easeOut
        
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: Slide UP View 할때 지도 이동
    func moveToCameraWhenSlideUpView() {
        if isCanMoveCameraWhenSlideUpView {
            let latitude = naverMapView.latitude - 0.006
            let longitude = naverMapView.longitude

            let latlng = NMGLatLng(lat: latitude, lng: longitude)

            let cameraUpdate = NMFCameraUpdate(scrollTo: latlng)

            naverMapView.moveCamera(cameraUpdate)
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

// MARK: View Refer
extension HomeViewController {
    func homeButtonIsHidden(_ hidden: Bool) {
        loadLocationButton.isHidden = hidden
        starButton.isHidden = hidden
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

// MARK: Map 빈 공간 클릭 할 때
extension HomeViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        whenClosedPlaceView()
        isSlideUpView = false
    }
}
