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
    
    // 동적 뷰 관련
    var storeInfoView = HomeInfoStoreView()
    var pageUpGesture = UISwipeGestureRecognizer()
    var pageDownGesture = UISwipeGestureRecognizer()
    
    // 최초 화면 뷰
    var firstPopupView = HomeFirstPopUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.locationAuthorization()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        presenter.loadVeganData()
        let height = view.frame.height * 0.4

        storeInfoView.frame = CGRect(
            x: 0,
            y: view.frame.height,
            width: view.frame.width,
            height: height
        )
        storeInfoView.entireView.alpha = 0
        storeInfoView.imageView.isHidden = false
        
        // TabBar Controller
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.backgroundColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.firstLocationUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}

extension HomeViewController: HomeViewProtocol {
    // MARK: Layout
    func makeLayout() {
        view.backgroundColor = .white
        
        [
            naverMapView,
            loadLocationButton,
            searchTextField,
            firstPopupView
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
                equalTo: naverMapView.trailingAnchor, constant: -16),
            
            // firstPopUpView
            firstPopupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            firstPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstPopupView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.4)
        ])
        
        // storeInfoView
        let height = view.frame.height * 0.4

        storeInfoView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: height)
        
        view.addSubview(storeInfoView)
        
        [
            pageUpGesture,
            pageDownGesture
        ].forEach {
            storeInfoView.addGestureRecognizer($0)
        }
        
        pageUpGesture.direction = .up
        pageDownGesture.direction = .down
        
        pageUpGesture.addTarget(self, action: #selector(respondToSwipeGesture))
        pageDownGesture.addTarget(self, action: #selector(respondToSwipeGesture))
        
        // firstPopUpView
        firstPopupView.cancelButton.addTarget(self, action: #selector(firstPopupViewDelete), for: .touchUpInside)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewTouchDown(_:)), for: .touchDown)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewReport(_:)), for: .touchDragExit)
        firstPopupView.reportButton.addTarget(self, action: #selector(firstPopupViewReport(_:)), for: .touchUpInside)
    }
    
    // MARK: Attribute
    func makeAttribute() {
        // View, Navigation
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // lodeLocationButton
        loadLocationButton.setImage(UIImage(named: "PersonalLocation"), for: .normal)
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocation),
            for: .touchUpInside
        )
        
        // searchTextField
        searchTextField.makeCustomPlaceHolder("점심으로 비건까스 어떠세요?")
        searchTextField.delegate = self
        
    }
    
    // MARK: firstPopupViewButton
    @objc func firstPopupViewDelete() {
        firstPopupView.isHidden = true
    }
    
    // MARK: firstPopUpViewButton
    @objc func firstPopupViewTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.layer.opacity = 0.4
        })
    }
    
    @objc func firstPopupViewReport(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform.identity
            sender.layer.opacity = 1

        }, completion: {  [weak self] _ in
            self?.firstPopupView.isHidden = true

            self?.tabBarController?.selectedIndex = 2
            let inrollViewController = InrollPlaceViewController()
            let navigationController = self?.tabBarController?.viewControllers?[2] as? UINavigationController
            
            navigationController?.setViewControllers([inrollViewController], animated: false)
        })
        
    }
    
    // MARK: PlaceListView 불러오기
    func presentPlaceListView(_ placeLists: [PlaceListModel]) {
        let viewController = PlaceListViewController()
        let presenter = PlaceListViewPresenter(
            viewController: viewController,
            placeList: placeLists
        )
        viewController.presenter = presenter
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
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
                                 
                                 let height = view.frame.height * 0.4
                                 UIView.animate(withDuration: 0.3) {
                                     self.storeInfoView.frame = CGRect(
                                        x: 0,
                                        y: self.view.frame.height - height,
                                        width: self.view.frame.width,
                                        height: height + 20
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
    @objc func refreshMyLocation() {
        presenter.locationUpdate()
    }
    
    // MARK: swipeUp&Down Gesture
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            let height = view.frame.height * 0.4
            switch swipeGesture.direction {
            case .up:
                UIView.animate(withDuration: 0.4, animations: { [weak self] in
                    self?.storeInfoView.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: self?.view.frame.width ?? 0,
                        height: self?.view.frame.height ?? 0
                    )
                    self?.storeInfoView.entireView.alpha = 1
                    self?.storeInfoView.imageView.isHidden = true
                }, completion: { [weak self] _ in
                    guard let address = self?.storeInfoView.address.text else { return }
                    self?.presenter.pushDetailViewController(address)
                })
            case .down:
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.storeInfoView.frame = CGRect(
                        x: 0,
                        y: self?.view.frame.height ?? 0,
                        width: self?.view.frame.width ?? 0,
                        height: height
                    )
                    self?.storeInfoView.imageView.isHidden = false
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
