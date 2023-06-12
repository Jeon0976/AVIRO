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
    
    // home slide view 높이
    var slideViewHeight = 280
    
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
        
        navigationController?.navigationBar.isHidden = true
        
        // TabBar Controller
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBar(false)
        }
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
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -4),
            
            // searchTextField
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(
                equalTo: naverMapView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -16)
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
        loadLocationButton.setImage(UIImage(named: "PersonalLocation"), for: .normal)
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
        searchTextField.makeCustomPlaceHolder("점심으로 비건까스 어떠세요?")
        searchTextField.delegate = self
        
    }
    // MARK: Gesture 설정
    func makeGesture() {
        storeInfoView.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(panGestureHandler))
    }
    
    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: storeInfoView)
        let velocity = recognizer.velocity(in: self.view)
        
        let minHeight = view.frame.minY
        let maxHeight = view.frame.maxY
        
        let currentHeight = storeInfoView.frame.height
        
        if recognizer.state == .changed {
            let newHeight = currentHeight - translation.y
            if newHeight >= minHeight && newHeight <= maxHeight {
                storeInfoView.frame = CGRect(x: 0,
                                             y: self.view.frame.height - newHeight + 32,
                                             width: view.frame.width,
                                             height: newHeight
                )
                recognizer.setTranslation(CGPoint.zero, in: self.view)
                
                let newAlpha = (newHeight - minHeight) / (maxHeight - minHeight)
                storeInfoView.entireView.alpha = newAlpha
                storeInfoView.activityIndicator.alpha = newAlpha
            }
        } else if recognizer.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.y >= 0 {
                    self.storeInfoView.frame = CGRect(x: 0,
                                                      y: self.view.frame.height,
                                                      width: self.view.frame.width,
                                                      height: CGFloat(self.slideViewHeight)
                    )
                    self.storeInfoView.entireView.alpha = 0
                    self.storeInfoView.activityIndicator.alpha = 0
                    self.view.layoutIfNeeded()
                } else {
                    self.storeInfoView.frame = CGRect(x: 0,
                                                      y: self.view.frame.height - maxHeight + 32,
                                                      width: self.view.frame.width,
                                                      height: maxHeight
                    )
                    self.storeInfoView.entireView.alpha = 1
                    self.storeInfoView.activityIndicator.alpha = 1
                }
                self.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                if !(velocity.y >= 0) {
                    guard let address = self?.storeInfoView.address.text else { return }
                    self?.presenter.pushDetailViewController(address)
                }
            })
        }
    }

    // MARK: SlideView 설정
    func makeSlideView() {
        // first popup view
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.5
        
        firstPopupView.cancelButton.addTarget(self, action: #selector(firstPopupViewDelete), for: .touchUpInside)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewTouchDown(_:)), for: .touchDown)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewReportOnlyPopUp(_:)), for: .touchDragExit)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewReport(_:)), for: .touchUpInside)
        
        // store info view
        storeInfoView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: CGFloat(slideViewHeight))
        storeInfoView.entireView.alpha = 0
        storeInfoView.activityIndicator.alpha = 0
        
        [
            blurEffectView,
            firstPopupView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addSubview(storeInfoView)
        
        NSLayoutConstraint.activate([
            // firstPopUpView
            firstPopupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            firstPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstPopupView.heightAnchor.constraint(equalToConstant: CGFloat(slideViewHeight))
        ])
    }
    
    // MARK: firstPopupViewButton
    @objc func firstPopupViewDelete() {
        firstPopupView.isHidden = true
        blurEffectView.isHidden = true
    }
    
    // MARK: firstPopUpViewButton
    @objc func firstPopupViewTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.layer.opacity = 0.4
        })
    }
    
    @objc func firstPopupViewReportOnlyPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        })
    }
    
    @objc func firstPopupViewReport(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1

        }, completion: {  [weak self] _ in
            self?.firstPopupView.isHidden = true
            self?.blurEffectView.isHidden = true

            self?.tabBarController?.selectedIndex = 2
        })
    }
    
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
                    marker.iconImage = NMFOverlayImage(name: "allVegan")
                } else if veganModel.someMenuVegan {
                    marker.iconImage = NMFOverlayImage(name: "someMenuVegan")
                } else {
                    marker.iconImage = NMFOverlayImage(name: "requestVegan")
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
                                        named: "HomeInfoVegan")
                                     storeInfoView.topImageView.image = UIImage(
                                        named: "HomeInfoVeganTitle")
                                 } else if veganModel.someMenuVegan {
                                     storeInfoView.imageView.image = UIImage(
                                        named: "HomeInfoSomeVegan")
                                     storeInfoView.topImageView.image = UIImage(
                                        named: "HomeInfoSomeVeganTItle")
                                 } else {
                                     storeInfoView.imageView.image = UIImage(
                                        named: "HomeInfoRequestVegan")
                                     storeInfoView.topImageView.image = UIImage(
                                        named: "HomeInfoRequestVeganTitle")
                                 }
                                 storeInfoView.imageView.contentMode = .scaleAspectFit
                                 storeInfoView.topImageView.contentMode = .scaleAspectFit
                                                                  
                                 UIView.animate(withDuration: 0.3) {
                                     self.storeInfoView.frame = CGRect(
                                        x: 0,
                                        y: self.view.frame.height - CGFloat(self.slideViewHeight) + 16,
                                        width: self.view.frame.width,
                                        height: CGFloat(self.slideViewHeight + 16)
                                     )
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
            let presenter = DetailViewPresenter(viewController: viewController, veganModel: veganModel)
            viewController.presenter = presenter
            
            self?.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

extension HomeViewController {
    // MARK: 내 위치 최신화 버튼 클릭 시
    @objc func refreshMyLocationTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.layer.opacity = 0.4
        })
    }
    
    @objc func refreshMyLocationOnlyPopUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        })
    }
    
    @objc func refreshMyLocation(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1
        }, completion: { [weak self] _ in
            self?.presenter.locationUpdate()
        })
    }
    
    // MARK: swipeUp&Down Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .up:
                UIView.animate(withDuration: 0.4, animations: {
                    self.storeInfoView.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: self.view.frame.width,
                        height: self.view.frame.height
                    )
                    self.storeInfoView.entireView.alpha = 1
                }, completion: { [weak self] _ in
                    guard let address = self?.storeInfoView.address.text else { return }
                    self?.presenter.pushDetailViewController(address)
                })
            case .down:
                UIView.animate(withDuration: 0.3) {
                    self.storeInfoView.frame = CGRect(
                        x: 0,
                        y: self.view.frame.height,
                        width: self.view.frame.width,
                        height: CGFloat(self.slideViewHeight)
                    )
                }
            default:
                break
            }
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let viewController = HomeSearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
        
        return false
    }
}
