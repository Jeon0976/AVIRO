//
//  EditPlaceInfoEditViewController.swift
//  AVIRO
//
//  Created by 전성훈 on 2023/08/25.
//

import UIKit

import NMapsMap

final class EditPlaceInfoViewController: UIViewController {
    lazy var presenter = EditPlaceInfoPresenter(viewController: self)
    
    private let items = ["위치", "전화번호", "영업시간", "홈페이지"]
    
    private lazy var topLine: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray5
        
        return view
    }()
    
    private lazy var segmentedControl: UnderlineSegmentedControl = {
        let segmented = UnderlineSegmentedControl(items: items)
        
        segmented.setAttributedTitle()
        segmented.backgroundColor = .gray7
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmentedChanged(segment:)), for: .valueChanged)
        
        return segmented
    }()
    
    private lazy var safeAreaView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray6
        
        return view
    }()
    
    private lazy var scrollView = UIScrollView()
        
    private lazy var editLocationTopView: EditLocationTopView = {
        let view = EditLocationTopView()
        
        return view
    }()
    
    private lazy var editLocationBottomView: EditLocationBottomView = {
        let view = EditLocationBottomView()
                
        return view
    }()
    
    private lazy var editPhoneView: EditPhoneView = {
        let view = EditPhoneView()
        
        return view
    }()
    
    private lazy var editOperationHoursView: EditOperatingHoursView = {
        let view = EditOperatingHoursView()
        
        return view
    }()
    
    private lazy var editHomePageView: EditHomePageView = {
        let view = EditHomePageView()
        
        return view
    }()
    
    private lazy var tapGesture = UITapGestureRecognizer()
    
    private lazy var blurEffectView = UIVisualEffectView()
    private lazy var operationHourChangebleView = OperationHourChangebleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
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

extension EditPlaceInfoViewController: EditPlaceInfoProtocol {
    func makeLayout() {
        [
            topLine,
            segmentedControl,
            safeAreaView,
            blurEffectView,
            operationHourChangebleView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topLine.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            topLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            segmentedControl.topAnchor.constraint(equalTo: topLine.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            safeAreaView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            operationHourChangebleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            operationHourChangebleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            operationHourChangebleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1, constant: -32)
            
        ])
        
        makeSafeAreaViewLayout()
    }
    
    private func makeSafeAreaViewLayout() {
        [
            scrollView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            safeAreaView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaView.bottomAnchor)
        ])
        
        [
            editLocationTopView,
            editLocationBottomView,
            editPhoneView,
            editOperationHoursView,
            editHomePageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            editLocationTopView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editLocationTopView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationTopView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editLocationBottomView.topAnchor.constraint(
                equalTo: editLocationTopView.bottomAnchor, constant: 15),
            editLocationBottomView.leadingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editLocationBottomView.trailingAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editLocationBottomView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            
            editPhoneView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editPhoneView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editPhoneView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
            editOperationHoursView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editOperationHoursView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editOperationHoursView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            editOperationHoursView.bottomAnchor.constraint(equalTo: scrollView.frameLayoutGuide.bottomAnchor),
            
            editHomePageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            editHomePageView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            editHomePageView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16)
        ])
        
    }
    
    func makeAttribute() {
        self.view.backgroundColor = .gray7
        
        self.setupCustomBackButton()
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.title = "정보 수정 요청하기"
        
        let rightBarButton = UIBarButtonItem(title: "요청하기", style: .plain, target: self, action: #selector(editStore))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let tabBarController = self.tabBarController as? TabBarViewController {
            tabBarController.hiddenTabBarIncludeIsTranslucent(true)
        }
        
        makeBlurEffect()
        
        activeLocation()
    }
    
    private func makeBlurEffect() {
        let blurEffectStyle = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        blurEffectView.effect = blurEffectStyle
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.4
        blurEffectView.isHidden = true
        operationHourChangebleView.isHidden = true
    }
    
    func handleClosure() {
        editLocationBottomView.tappedPushViewButton = { [weak self] in
            self?.presenter.pushAddressEditViewController()
        }

        editOperationHoursView.openChangebleOperationHourView = { [weak self] timeModel in
            self?.showOperationHourChangebleView(true, timeModel)
        }
    }
    
    private func showOperationHourChangebleView(
        _ show: Bool,
        _ operationHoursModel: EditOperationHoursModel
    ) {
        navigationController?.navigationBar.isUserInteractionEnabled = !show
        blurEffectView.isHidden = !show
        operationHourChangebleView.isHidden = !show
        
        operationHourChangebleView.makeBindingData(operationHoursModel)
    }
    
    private func showTimeChangebleView(_ show: Bool) {
        
    }
    
    @objc private func editStore() {
        
    }
    
    @objc private func segmentedChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            activeLocation()
        case 1:
            activePhone()
        case 2:
            activeWorkingHours()
        case 3:
            activeHomepage()
        default:
            break
        }
    }
    
    private func activeLocation() {
        editPhoneView.isHidden = true
        editHomePageView.isHidden = true
        editOperationHoursView.isHidden = true
        
        editLocationTopView.isHidden = false
        editLocationBottomView.isHidden = false
    }
    
    private func activePhone() {
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editHomePageView.isHidden = true
        editOperationHoursView.isHidden = true
        
        editPhoneView.isHidden = false
    }
    
    private func activeWorkingHours() {
        editHomePageView.isHidden = true
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editPhoneView.isHidden = true
        
        editOperationHoursView.isHidden = false
    }
    
    private func activeHomepage() {
        editOperationHoursView.isHidden = true
        editLocationTopView.isHidden = true
        editLocationBottomView.isHidden = true
        editPhoneView.isHidden = true
        
        editHomePageView.isHidden = false
    }
    
    func makeGesture() {
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func isDetailFieldCheckBeforeKeyboardShowAndHide(notification: NSNotification) -> Bool {
        return self.editLocationBottomView.checkIsDetailField(notification: notification)
    }
    
    func keyboardWillShow(height: CGFloat) {
        self.navigationController?.isNavigationBarHidden = true
        self.segmentedControl.isHidden = true
        
        UIView.animate(
            withDuration: 0.3,
            animations: { self.scrollView.transform = CGAffineTransform(
                translationX: 0,
                y: -(height))
            }
        )
    }
    
    func keyboardWillHide() {
        self.navigationController?.isNavigationBarHidden = false
        self.segmentedControl.isHidden = false
        
        self.scrollView.transform = .identity
    }
    
    func dataBindingLocation(title: String,
                             category: String,
                             marker: NMFMarker,
                             address: String
    ) {
        editLocationTopView.dataBinding(title: title, category: category)
        editLocationBottomView.dataBinding(marker: marker, address: address)
    }
    
    func dataBindingPhone(phone: String) {
        editPhoneView.dataBinding(phone)
    }
    
    func dataBindingOperatingHours(operatingHourModels: [EditOperationHoursModel]) {
        editOperationHoursView.dataBinding(operatingHourModels)
    }
    
    func dataBindingHomepage(homepage: String) {
        editHomePageView.dataBinding(homepage)
    }
    
    func pushAddressEditViewController(placeMarkerModel: MarkerModel) {
        let vc = EditLocationDetailViewController()
        let presenter = EditLocationDetailPresenter(
            viewController: vc,
            placeMarkerModel: placeMarkerModel
        )
        
        // MARK: Address가 봐뀐 후 메소드
        presenter.afterChangedAddress = { [weak self] address in
            guard let address = address else { return }
            
            // TODO: 수정 예정
            self?.editLocationBottomView.changedAddressLabel(address)
            self?.presenter.saveChangedAddress(address)
        }
        
        vc.presenter = presenter
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateNaverMap(_ latLng: NMGLatLng) {
        editLocationBottomView.changedNaverMap(latLng)
    }
}

extension EditPlaceInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is EnrollField {
            return false
        }
        
        view.endEditing(true)
        return true
    }
}
