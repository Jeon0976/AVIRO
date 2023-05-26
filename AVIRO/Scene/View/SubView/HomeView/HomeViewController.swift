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
        
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
        presenter.locationAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        presenter.locationUpdate()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("selectedPlace"), object: nil)
        
        navigationController?.navigationBar.isHidden = false
        
        // positionMode 싱글톤인가??? 여기서 모드를 꺼야 다음 창에서 나옴
        naverMapView.positionMode = .disabled
    }

}

extension HomeViewController: HomeViewProtocol {
    // MARK: Layout
    func makeLayout() {
        view.backgroundColor = .white
        
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
        // lodeLocationButton
        loadLocationButton.setImage(UIImage(named: "PersonalLocation"), for: .normal)
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocation),
            for: .touchUpInside
        )
        
        let placeholderText = "점심으로 비건까스 어떠세요?"
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 138/255, green: 133/255, blue: 133/255, alpha: 1),
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let placeholderAttributedString = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        searchTextField.attributedPlaceholder = placeholderAttributedString
        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.delegate = self
        searchTextField.textAlignment = .natural
    }
    
    // MARK: 내 위치 최신화
    func markingMap() {
        naverMapView.positionMode = .direction
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
        print(placeLists)
        present(viewController, animated: true)
    }
    
    // 위치 denied 할 때
    func ifDenied() {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.153354, lng: 129.118924))
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // 위치 denied 후 검색할 때
    func showWarnningAelrt(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension HomeViewController {
    // MARK: 내 위치 최신화 버튼 클릭 시
    @objc func refreshMyLocation() {
        presenter.locationUpdate()
    }
    
    // MARK: PlaceListViewController에서 아이탬이 선택 되었을 때 inroll view present
    @objc func selectedPlace(_ notification: Notification) {
        
        let viewController = InrollPlaceViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: UITextFieldDelegate {
    // MARK: 2.키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let searchText = searchTextField.text else { return true }
        
        presenter.showPlaceListView(searchText)
        
        return true
    }
}
