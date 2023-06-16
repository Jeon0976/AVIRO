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
        
    var naverMapView = NMFMapView()
    
    // 검색 기능 관련
    var searchTextField = TitleTextField()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.locationAuthorization()
        presenter.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        presenter.viewWillAppear()
        presenter.loadVeganData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.firstLocationUpdate()
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            naverMapView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
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
        searchTextField.makeCustomPlaceHolder(StringValue.HomeView.searchPlaceHolder)
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
        PersonalLocation.shared.longitude = 129.118924
        PersonalLocation.shared.latitude = 35.153354
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.153354, lng: 129.118924))
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // 위치 승인 되었을 때
    func requestSuccess() {
        naverMapView.positionMode = .direction
    }
    
    // MARK: 지도에 마크 표시하기 작업
    func makeMarker(_ veganList: [VeganModel]) {
        DispatchQueue.global().async {
            var markers = [NMFMarker]()
            
            veganList.forEach { veganModel in
                
                let title = veganModel.placeModel.title
                let address = veganModel.placeModel.address
                let latLng = NMGLatLng(lat: veganModel.placeModel.y, lng: veganModel.placeModel.x)
                let marker = NMFMarker(position: latLng)
                marker.width = 30
                marker.height = 30
                markers.append(marker)
                if veganModel.allVegan {
                    marker.iconImage = NMFOverlayImage(name: Image.allVegan)
                } else if veganModel.someMenuVegan {
                    marker.iconImage = NMFOverlayImage(name: Image.someMenuVegan)
                } else {
                    marker.iconImage = NMFOverlayImage(name: Image.requestVegan)
                }
                // Marker 터치할 때
                marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                             if nil != overlay as? NMFMarker {
                                 let title = title
                                 let address = address
                                 guard let self = self else { return false }
                                 storeInfoView.title.text = title
                                 storeInfoView.address.text = address
                                 
                                 if veganModel.allVegan {
                                     storeInfoView.imageView.image = UIImage(
                                        named: Image.homeInfoVegan)
                                     storeInfoView.topImageView.image = UIImage(
                                        named: Image.homeInfoVeganTitle)
                                 } else if veganModel.someMenuVegan {
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
                             }
                             return true
                         }
            }
            DispatchQueue.main.async { [weak self] in
                for marker in markers {
                    marker.mapView = self?.naverMapView
                }
            }
        }
    }
    
    // MARK: pushDetailViewController
    func pushDetailViewController(_ veganModel: VeganModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = DetailViewController()
            let presenter = DetailViewPresenter(viewController: viewController,
                                                veganModel: veganModel
            )
            viewController.presenter = presenter
            
            self?.navigationController?.pushViewController(viewController,
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
                                                 animated: true
        )
        return false
    }
}
