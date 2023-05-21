//
//  MainViewController.swift
//  VeganRestaurant
//
//  Created by 전성훈 on 2023/05/19.
//

import UIKit

import NMapsMap

final class MainViewController: UIViewController {
    lazy var presenter = MainViewPresenter(viewController: self)
        
    var naverMapView = NMFMapView()
    
    var searchTextField = InsetTextField()
    var searchLocationButton = UIButton()
    
    var loadLocationButton = UIButton()
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        presenter.locationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.locationUpdate()
    }

}

extension MainViewController: MainViewProtocol {
    // MARK: layout
    func makeLayout() {
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(tapGesture)
        [
            naverMapView,
            loadLocationButton,
            searchTextField,
            searchLocationButton
        ].forEach { view.addSubview($0) }
        
        naverMapView.translatesAutoresizingMaskIntoConstraints = false
        loadLocationButton.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadLocationButton.bottomAnchor.constraint(equalTo: naverMapView.bottomAnchor, constant: -16),
            loadLocationButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: naverMapView.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: naverMapView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchLocationButton.leadingAnchor, constant: -16),
            searchLocationButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16),
            searchLocationButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor)
        ])

    }
    
    // MARK: Attribute
    func makeAttribute() {
        
        loadLocationButton.customImageConfig("plus.circle", "plus.circle.fill")
        loadLocationButton.addTarget(self, action: #selector(refreshMyLocation), for: .touchUpInside)
        
        searchTextField.placeholder = "장소를 입력하세요."
        searchTextField.backgroundColor = .white
        searchTextField.clearButtonMode = .always
        searchTextField.delegate = self
        
        searchLocationButton.customImageConfig("magnifyingglass.circle", "magnifyingglass.circle.fill")
        searchLocationButton.addTarget(self, action: #selector(findLocation), for: .touchUpInside)
        
        tapGesture.delegate = self
    }
    
    // MARK: 내 위치 최신화
    func markingMap() {
        naverMapView.positionMode = .direction
    }
    
    func presentPlaceListView(_ placeLists: [PlaceListModel]) {
        let viewController = PlaceListViewController()
        let presenter = PlaceListViewPresenter(
            viewController: viewController,
            placeList: placeLists
        )
        viewController.presenter = presenter
        
        present(viewController, animated: true)
    }
}

extension MainViewController {
    // MARK: 내 위치 최신화 버튼 클릭 시
    @objc func refreshMyLocation() {
        presenter.locationUpdate()
    }
    
    @objc func findLocation() {
        guard let searchText = searchTextField.text else { return }
        
        presenter.findLocation(searchText)
    }
}

// MARK: textField Delegate (키보드 확인 눌렀을 때)
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = searchTextField.text else { return true }
        
        presenter.findLocation(searchText)
        
        return true
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        view.endEditing(true)
        return true
    }
}
