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
    
    // 검색 기능 관련
    var searchTextField = InsetTextField()
    var searchLocationButton = UIButton()
    var loadCustomLocationButton = UIButton()

    // 내 위치 최신화 관련
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(selectedPlace(_:)),
            name: NSNotification.Name("selectedPlace"),
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("selectedPlace"), object: nil)

    }

}

extension MainViewController: MainViewProtocol {
    // MARK: Layout
    func makeLayout() {
        view.backgroundColor = .systemBackground
        
        [
            naverMapView,
            loadLocationButton,
            searchTextField,
            searchLocationButton,
            loadCustomLocationButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // naverMapView
            naverMapView.topAnchor.constraint(
                equalTo: view.topAnchor),
            naverMapView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            naverMapView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // loadLoactionButton
            loadLocationButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loadLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -16),
            
            // searchTextField
            searchTextField.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(
                equalTo: naverMapView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(
                equalTo: searchLocationButton.leadingAnchor, constant: -16),
            
            // searchLocationButton
            searchLocationButton.leadingAnchor.constraint(
                equalTo: searchTextField.trailingAnchor, constant: -16),
            searchLocationButton.centerYAnchor.constraint(
                equalTo: searchTextField.centerYAnchor),
            
            // loadCustomLoactionButton
            loadCustomLocationButton.trailingAnchor.constraint(
                equalTo: naverMapView.trailingAnchor, constant: -16),
            loadCustomLocationButton.leadingAnchor.constraint(
                equalTo: searchLocationButton.trailingAnchor, constant: 16),
            loadCustomLocationButton.centerYAnchor.constraint(
                equalTo: searchTextField.centerYAnchor)
        ])

    }
    
    // MARK: Attribute
    func makeAttribute() {
        view.addGestureRecognizer(tapGesture)
        navigationController?.navigationBar.isHidden = true
        tapGesture.delegate = self

        // lodeLocationButton
        loadLocationButton.customImageConfig("scope", "scope")
        loadLocationButton.addTarget(
            self,
            action: #selector(refreshMyLocation),
            for: .touchUpInside
        )
        loadLocationButton.backgroundColor = .white
        loadLocationButton.layer.cornerRadius = 16
        
        // searchTextField
        let placeholder = "식당을 검색하세요."
        let placeholderColor = UIColor.gray

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor
        ]

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: placeholderAttributes
        )
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(
            UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal)
        clearButton.contentEdgeInsets = UIEdgeInsets(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        
        searchTextField.rightView = clearButton
        searchTextField.rightViewMode = .whileEditing

        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 8
        searchTextField.delegate = self
                
        // searchLocationButton
        searchLocationButton.customImageConfig("magnifyingglass.circle", "magnifyingglass.circle.fill")
        searchLocationButton.addTarget(
            self,
            action: #selector(showPlaceListView),
            for: .touchUpInside
        )
        searchLocationButton.backgroundColor = .white
        searchLocationButton.layer.cornerRadius = 16
        
        // loadCustomLocationButton
        loadCustomLocationButton.customImageConfig("plus.circle", "plus.circle.fill")
        loadCustomLocationButton.backgroundColor = .white
        loadCustomLocationButton.layer.cornerRadius = 16
        loadCustomLocationButton.addTarget(
            self,
            action: #selector(showCustomLocationView),
            for: .touchUpInside)
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
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: true)
    }
    
    // MARK: Selected Place Inroll 불러오기
    func presentInrollPlaceView(_ selectedPlace: PlaceListModel) {
        let viewController = InrollPlaceViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController {
    // MARK: 내 위치 최신화 버튼 클릭 시
    @objc func refreshMyLocation() {
        presenter.locationUpdate()
    }
    
    // MARK: 아이탬이 선택 되었을 때 inroll view present
    @objc func selectedPlace(_ notification: Notification) {
        guard let selectedPlace = notification.userInfo?["selectedPlace"] as? PlaceListModel else { return }
        
        let viewController = InrollPlaceViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    // MARK: 좌표 커스텀 입력
    @objc func showCustomLocationView() {
        let viewController = CustomLocationViewController()
        
    }
    
    // MARK: 1. 돋보기 버튼 눌렀을 때
    @objc func showPlaceListView() {
        guard let searchText = searchTextField.text else { return }
        
        presenter.showPlaceListView(searchText)
    }
}

extension MainViewController: UITextFieldDelegate {
    // MARK: 2.키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = searchTextField.text else { return true }
        
        presenter.showPlaceListView(searchText)
        
        return true
    }
    
    // MARK: textField 입력 들어갈 때 취소버튼 보여짐
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchTextField.rightView?.isHidden = false
        return true
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    // MARK: 외부 클릭시 키보드 내려가면서, 키보드 취소버튼 사라짐
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view as? UIButton, touchedView == searchTextField.rightView {
            searchTextField.text = ""
            searchTextField.rightView?.isHidden = true
              return true
          }
          view.endEditing(true)
          return true
    }
}

// MARK: Present method custom
extension MainViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return CustomPresentation(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresentation: true)
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresentation: false)
    }
}
