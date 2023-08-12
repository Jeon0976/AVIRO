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
        
    lazy var naverMapView = NMFMapView()
    
    // 검색 기능 관련
    lazy var searchTextField = MainField()

    // 내 위치 최신화 관련
    lazy var loadLocationButton = UIButton()
    lazy var starButton = UIButton()
    
    lazy var placeView = PlaceView()
    private var placeViewTopConstraint: NSLayoutConstraint?

    // store 뷰 관련
    var storeInfoView = HomeInfoStoreView()
    var panGesture = UIPanGestureRecognizer()
    var pageUpGesture = UISwipeGestureRecognizer()
    var pageDownGesture = UISwipeGestureRecognizer()
    
    // 최초 화면 뷰
    var firstPopupView = HomeFirstPopUpView()
    var blurEffectView = UIVisualEffectView()
    
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
        
        // TODO: Autolayout을 활용한 animation 구현 -> 정대리 강의 및 obisidan 정리 후 구현
        placeViewTopConstraint = placeView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        placeViewTopConstraint?.isActive = true

//        placeViewTopConstraint?.constant = -self.view.frame.height * 2/3
//        UIView.animate(withDuration: 0.3) {
//              self.view.layoutIfNeeded()
//          }
//      }
    
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
            placeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            placeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            placeView.heightAnchor.constraint(equalToConstant: self.view.frame.height)
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
        
    }
    
    @objc func starButtonTapped(sender: UIButton) {
        sender.isSelected.toggle()
        var tabBarHeight: CGFloat?
        
        // TODO: popView 될 때
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarHeight = tabBarController.tabBar.frame.height
            tabBarController.hiddenTabBar(true)
        }
        
        placeViewTopConstraint?.constant = -placeView.topView.frame.height + (tabBarHeight ?? CGFloat(32))
        
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

//        view.addSubview(storeInfoView)
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
    
    func loadMarkers() {
        DispatchQueue.main.async { [weak self] in
            let markers = MarkerModelArray.shared.getMarkers()
         
            markers.forEach {
                $0.mapView = self?.naverMapView
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
