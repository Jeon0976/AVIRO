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
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // naverMapView
            naverMapView.topAnchor.constraint(equalTo: view.topAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            // loadLoactionButton
            loadLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loadLocationButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16),
            
            // searchTextField
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: naverMapView.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchLocationButton.leadingAnchor, constant: -16),
            
            // searchLocationButton
            searchLocationButton.trailingAnchor.constraint(equalTo: naverMapView.trailingAnchor, constant: -16),
            searchLocationButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor)
        ])

    }
    
    // MARK: Attribute
    func makeAttribute() {
        // lodeLocationButton
        loadLocationButton.customImageConfig("plus.circle", "plus.circle.fill")
        loadLocationButton.addTarget(self, action: #selector(refreshMyLocation), for: .touchUpInside)
        
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
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        searchTextField.rightView = clearButton
        searchTextField.rightViewMode = .whileEditing

        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 8
        searchTextField.delegate = self
        
        tapGesture.delegate = self
        
        // searchLocationButton
        searchLocationButton.customImageConfig("magnifyingglass.circle", "magnifyingglass.circle.fill")
        searchLocationButton.addTarget(self, action: #selector(findLocation), for: .touchUpInside)
        
    }
    
    // MARK: 내 위치 최신화
    func markingMap() {
        naverMapView.positionMode = .direction
    }
    
    //  MARK: PlaceListView 불러오기
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
    
    // MARK: 1. 돋보기 버튼 눌렀을 때
    @objc func findLocation() {
        guard let searchText = searchTextField.text else { return }
        
        presenter.findLocation(searchText)
    }
    
}

extension MainViewController: UITextFieldDelegate {
    // MARK: 2.키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = searchTextField.text else { return true }
        
        presenter.findLocation(searchText)
        
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
