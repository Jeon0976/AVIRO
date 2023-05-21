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
            naverMapView.topAnchor.constraint(equalTo: view.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loadLocationButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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
        
        let placeholder = "식당을 검색하세요."
        let placeholderColor = UIColor.gray // Change this to your desired color

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor
        ]

        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        clearButton.addTarget(self, action: #selector(clearField), for: .touchUpInside)

        
        searchTextField.rightView = clearButton
        searchTextField.rightViewMode = .whileEditing

        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 8
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
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
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
    
//    @objc func clearField() {
//        print("test")
//        searchTextField.text = " "
//    }
}

// MARK: textField Delegate (키보드 확인 눌렀을 때)
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = searchTextField.text else { return true }
        
        presenter.findLocation(searchText)
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchTextField.rightViewMode = .whileEditing
        return true
    }
}

// MARK: 외부 클릭시 키보드 내려감
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == searchTextField.rightView {
            searchTextField.text = ""
            searchTextField.rightViewMode = .never
              return true
          }
          view.endEditing(true)
          return true
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return CustomPresentation(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresentation: false)
    }
}
